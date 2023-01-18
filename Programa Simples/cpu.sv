module cpu(
  input clock, reset,
  inout [7:0] mbr,
  output logic we,
  output logic [7:0] mar, pc, ir);
  
  typedef enum logic [1:0] {FETCH, DECODE, EXECUTE} statetype;
  statetype state, nextstate;
  
  logic [7:0] acc, vaddr;
  
  always @(posedge clock or posedge reset)
  begin
    if (reset) begin
      pc <= 'b0;
      vaddr <= 8'b10000000; // 128
      state <= FETCH;
    end
    else begin
      case(state)
      FETCH: begin
        we <= 0;
        pc <= pc + 1;
        mar <= pc;
      end
      DECODE: begin
        ir = mbr;
        if (ir[7:6] == 2'b01)       // store video
          mar <= {4'b01, ir[5:0]};
        else if (ir[7:6] == 2'b10) // load video
          mar <= {4'b10, ir[5:0]};
        else 
          mar <= {4'b1111, ir[3:0]};
      end
      EXECUTE: begin
        if (ir[7:6] == 2'b11 && acc != 8'b00000000) // jnz
          pc <= {1'b0, ir[6:0]};
        else if (ir[7:4] == 4'b0000) // add acc + data
          acc <= acc + mbr;
        
        else if (ir[7:4] == 4'b0001) // sub acc - data
          acc <= acc - mbr;

        else if (ir[7:4] == 4'b0010 || ir[7:6] == 2'b10)// store video or data
          we <= 1'b1;

        else if (ir[7:4] == 4'b0011 || ir[7:6] == 2'b01) // load video or data
          acc <= mbr;
      end
      endcase  
      state <= nextstate;                  
    end
  end
  
  always_comb
    casex(state)
      FETCH:   nextstate = DECODE;
      DECODE:  nextstate = EXECUTE;
      EXECUTE: nextstate = FETCH;
      default: nextstate = FETCH; 
    endcase
  
  assign mbr = we ? acc : 'bz;
endmodule
