//////////////////////////////////////////////////////////////////////////////////
// Company: UFSCar
// Author: Ricardo Menotti
// 
// Create Date: 29.05.2021 13:50:41
// Project Name: Lab. Remoto de Logica Digital - DC/UFSCar
// Design Name: uP1 with Video 20x15 
// Module Name: top
// Target Devices: xc7z020
// Tool Versions: Vivado v2019.2 (64-bit)
//////////////////////////////////////////////////////////////////////////////////

module top(
  input sysclk, // 125MHz
  output [3:0] led,
  output led5_r, led5_g, led5_b, led6_r, led6_g, led6_b,
  output [3:0] VGA_R, VGA_G, VGA_B, 
  output VGA_HS_O, VGA_VS_O);

  wire pixel_clk, reset, we; 
  wire [7:0] data, vdata;
  wire [8:0] address, vaddr;
  
  power_on_reset por(sysclk, reset);
  clk_wiz_1 clockdiv(pixel_clk, sysclk); // 25MHz
  cpu proc(sysclk, reset, data, we, address);
  mem ram(sysclk, we, address, data, vaddr, vdata); 
  vga video(pixel_clk, reset, vdata, vaddr, VGA_R, VGA_G, VGA_B, VGA_HS_O, VGA_VS_O);
endmodule

module cpu(
  input clock, reset,
  inout [7:0] mbr,
  output logic we,
  output logic [8:0] mar,
  output logic [7:0] pc, ir);
  
  parameter FETCH = 0, DECODE = 1, EXECUTE = 2;
  reg [1:0] state, nextstate;
  
  reg [7:0] acc;
  reg [9:0] vaddr;
  
  always @(posedge clock or posedge reset)
  begin
    if (reset) begin
      pc <= 'b0;
      vaddr <= 10'b0011010110; // 212..511
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
        if (ir[7:5] == 3'b000)       // load/store video
          mar <= vaddr;
        else 
          mar <= {5'b01111, ir[3:0]};
      end
      EXECUTE: begin
        if (ir[7] == 1'b1 && acc != 8'b00000000) // jnz
          pc <= {1'b0, ir[6:0]};
        else if (ir[7:4] == 4'b0100) // indirect load 
          acc <= mbr;
        else if (ir[7:4] == 4'b0101) // add acc + data
          acc <= acc + mbr;
        else if (ir[7:4] == 4'b0110) // sub acc - data
          acc <= acc - mbr;
        else if (ir[7:4] == 4'b0011) // store
          we <= 1'b1;
        else if (ir[7:4] == 4'b0000) // load video
          acc <= mbr;
        else if (ir[7:4] == 4'b0001) // store video
        begin
          we <= 1'b1;
          vaddr <= vaddr + 1;
          if (vaddr > 511) 
            vaddr <= 10'b0011010110;  // 212
        end
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

module mem(input clock, we,
        input [8:0] address,
        inout [7:0] data,
        input [8:0] vaddr,
       output [7:0] vdata);

  reg [7:0] RAM[511:0];

  initial
  begin
    RAM[0]= 8'b00001111;
    RAM[1]= 8'b00110011;
    RAM[2]= 8'b00110100;
    RAM[3]= 8'b00011111;
    RAM[4]= 8'b01000110;
    RAM[5]= 8'b00110101;
    RAM[6]= 8'b00001111;
    RAM[7]= 8'b00110011;
    RAM[8]= 8'b01000100;
    RAM[9]= 8'b00011111;
    RAM[10]= 8'b01000011;
    RAM[11]= 8'b00110100;
    RAM[12]= 8'b01000101;
    RAM[13]= 8'b01100000;
    RAM[14]= 8'b00110101;
    RAM[15]= 8'b10000110;
    RAM[16]= 8'b01000010;
    RAM[17]= 8'b01100000;
    RAM[18]= 8'b00110001;
    RAM[19]= 8'b10000100;
    RAM[20]= 8'b00000000;
    RAM[21]= 8'b00000000;
    RAM[22]= 8'b00000000;
    RAM[23]= 8'b00000000;
    RAM[24]= 8'b00000000;
    RAM[25]= 8'b00000000;
    RAM[26]= 8'b00000000;
    RAM[27]= 8'b00000000;
    RAM[28]= 8'b00000000;
    RAM[29]= 8'b00000000;
    RAM[30]= 8'b00000000;
    RAM[31]= 8'b00000000;
    RAM[32]= 8'b00000000;
    RAM[33]= 8'b00000000;
    RAM[34]= 8'b00000000;
    RAM[35]= 8'b00000000;
    RAM[36]= 8'b00000000;
    RAM[37]= 8'b00000000;
    RAM[38]= 8'b00000000;
    RAM[39]= 8'b00000000;
    RAM[40]= 8'b00000000;
    RAM[41]= 8'b00000000;
    RAM[42]= 8'b00000000;
    RAM[43]= 8'b00000000;
    RAM[44]= 8'b00000000;
    RAM[45]= 8'b00000000;
    RAM[46]= 8'b00000000;
    RAM[47]= 8'b00000000;
    RAM[48]= 8'b00000000;
    RAM[49]= 8'b00000000;
    RAM[50]= 8'b00000000;
    RAM[51]= 8'b00000000;
    RAM[52]= 8'b00000000;
    RAM[53]= 8'b00000000;
    RAM[54]= 8'b00000000;
    RAM[55]= 8'b00000000;
    RAM[56]= 8'b00000000;
    RAM[57]= 8'b00000000;
    RAM[58]= 8'b00000000;
    RAM[59]= 8'b00000000;
    RAM[60]= 8'b00000000;
    RAM[61]= 8'b00000000;
    RAM[62]= 8'b00000000;
    RAM[63]= 8'b00000000;
    RAM[64]= 8'b00000000;
    RAM[65]= 8'b00000000;
    RAM[66]= 8'b00000000;
    RAM[67]= 8'b00000000;
    RAM[68]= 8'b00000000;
    RAM[69]= 8'b00000000;
    RAM[70]= 8'b00000000;
    RAM[71]= 8'b00000000;
    RAM[72]= 8'b00000000;
    RAM[73]= 8'b00000000;
    RAM[74]= 8'b00000000;
    RAM[75]= 8'b00000000;
    RAM[76]= 8'b00000000;
    RAM[77]= 8'b00000000;
    RAM[78]= 8'b00000000;
    RAM[79]= 8'b00000000;
    RAM[80]= 8'b00000000;
    RAM[81]= 8'b00000000;
    RAM[82]= 8'b00000000;
    RAM[83]= 8'b00000000;
    RAM[84]= 8'b00000000;
    RAM[85]= 8'b00000000;
    RAM[86]= 8'b00000000;
    RAM[87]= 8'b00000000;
    RAM[88]= 8'b00000000;
    RAM[89]= 8'b00000000;
    RAM[90]= 8'b00000000;
    RAM[91]= 8'b00000000;
    RAM[92]= 8'b00000000;
    RAM[93]= 8'b00000000;
    RAM[94]= 8'b00000000;
    RAM[95]= 8'b00000000;
    RAM[96]= 8'b00000000;
    RAM[97]= 8'b00000000;
    RAM[98]= 8'b00000000;
    RAM[99]= 8'b00000000;
    RAM[100]= 8'b00000000;
    RAM[101]= 8'b00000000;
    RAM[102]= 8'b00000000;
    RAM[103]= 8'b00000000;
    RAM[104]= 8'b00000000;
    RAM[105]= 8'b00000000;
    RAM[106]= 8'b00000000;
    RAM[107]= 8'b00000000;
    RAM[108]= 8'b00000000;
    RAM[109]= 8'b00000000;
    RAM[110]= 8'b00000000;
    RAM[111]= 8'b00000000;
    RAM[112]= 8'b00000000;
    RAM[113]= 8'b00000000;
    RAM[114]= 8'b00000000;
    RAM[115]= 8'b00000000;
    RAM[116]= 8'b00000000;
    RAM[117]= 8'b00000000;
    RAM[118]= 8'b00000000;
    RAM[119]= 8'b00000000;
    RAM[120]= 8'b00000000;
    RAM[121]= 8'b00000000;
    RAM[122]= 8'b00000000;
    RAM[123]= 8'b00000000;
    RAM[124]= 8'b00000000;
    RAM[125]= 8'b00000000;
    RAM[126]= 8'b00000000;
    RAM[127]= 8'b00000000;
    RAM[128]= 8'b00000001; //Data
    RAM[129]= 8'b00000000;
    RAM[130]= 8'b11111111;
    RAM[131]= 8'b00000000;
    RAM[132]= 8'b00000000;
    RAM[133]= 8'b00000000;
    RAM[134]= 8'b00010011;
    RAM[135]= 8'b00000000;
    RAM[136]= 8'b00000000;
    RAM[137]= 8'b00000000;
    RAM[138]= 8'b00000000;
    RAM[139]= 8'b00000000;
    RAM[140]= 8'b00000000;
    RAM[141]= 8'b00000000;
    RAM[142]= 8'b00000000;
    RAM[143]= 8'b00000000;
    RAM[144]= 8'b00000000;
    RAM[145]= 8'b00000000;
    RAM[146]= 8'b00000000;
    RAM[147]= 8'b00000000;
    RAM[148]= 8'b00000000;
    RAM[149]= 8'b00000000;
    RAM[150]= 8'b00000000;
    RAM[151]= 8'b00000000;
    RAM[152]= 8'b00000000;
    RAM[153]= 8'b00000000;
    RAM[154]= 8'b00000000;
    RAM[155]= 8'b00000000;
    RAM[156]= 8'b00000000;
    RAM[157]= 8'b00000000;
    RAM[158]= 8'b00000000;
    RAM[159]= 8'b00000000;
    RAM[160]= 8'b00000000;
    RAM[161]= 8'b00000000;
    RAM[162]= 8'b00000000;
    RAM[163]= 8'b00000000;
    RAM[164]= 8'b00000000;
    RAM[165]= 8'b00000000;
    RAM[166]= 8'b00000000;
    RAM[167]= 8'b00000000;
    RAM[168]= 8'b00000000;
    RAM[169]= 8'b00000000;
    RAM[170]= 8'b00000000;
    RAM[171]= 8'b00000000;
    RAM[172]= 8'b00000000;
    RAM[173]= 8'b00000000;
    RAM[174]= 8'b00000000;
    RAM[175]= 8'b00000000;
    RAM[176]= 8'b00000000;
    RAM[177]= 8'b00000000;
    RAM[178]= 8'b00000000;
    RAM[179]= 8'b00000000;
    RAM[180]= 8'b00000000;
    RAM[181]= 8'b00000000;
    RAM[182]= 8'b00000000;
    RAM[183]= 8'b00000000;
    RAM[184]= 8'b00000000;
    RAM[185]= 8'b00000000;
    RAM[186]= 8'b00000000;
    RAM[187]= 8'b00000000;
    RAM[188]= 8'b00000000;
    RAM[189]= 8'b00000000;
    RAM[190]= 8'b00000000;
    RAM[191]= 8'b00000000;
    RAM[192]= 8'b00000000;
    RAM[193]= 8'b00000000;
    RAM[194]= 8'b00000000;
    RAM[195]= 8'b00000000;
    RAM[196]= 8'b00000000;
    RAM[197]= 8'b00000000;
    RAM[198]= 8'b00000000;
    RAM[199]= 8'b00000000;
    RAM[200]= 8'b00000000;
    RAM[201]= 8'b00000000;
    RAM[202]= 8'b00000000;
    RAM[203]= 8'b00000000;
    RAM[204]= 8'b00000000;
    RAM[205]= 8'b00000000;
    RAM[206]= 8'b00000000;
    RAM[207]= 8'b00000000;
    RAM[208]= 8'b00000000;
    RAM[209]= 8'b00000000;
    RAM[210]= 8'b00000000;
    RAM[211]= 8'b00000000;                          // ...
    RAM[212] = 8'b00111111; // .video
    RAM[213] = 8'b00111111;
    RAM[214] = 8'b00111111;
    RAM[215] = 8'b00111111;
    RAM[216] = 8'b00111111;
    RAM[217] = 8'b00111111;
    RAM[218] = 8'b00111111;
    RAM[219] = 8'b00110000;
    RAM[220] = 8'b00110000;
    RAM[221] = 8'b00110000;
    RAM[222] = 8'b00110000;
    RAM[223] = 8'b00110000;
    RAM[224] = 8'b00111111;
    RAM[225] = 8'b00111111;
    RAM[226] = 8'b00111000;
    RAM[227] = 8'b00111000;
    RAM[228] = 8'b00111000;
    RAM[229] = 8'b00111111;
    RAM[230] = 8'b00111111;
    RAM[231] = 8'b00111111;
    RAM[232] = 8'b00111111;
    RAM[233] = 8'b00111111;
    RAM[234] = 8'b00111111;
    RAM[235] = 8'b00111111;
    RAM[236] = 8'b00111111;
    RAM[237] = 8'b00111111;
    RAM[238] = 8'b00110000;
    RAM[239] = 8'b00110000;
    RAM[240] = 8'b00110000;
    RAM[241] = 8'b00110000;
    RAM[242] = 8'b00110000;
    RAM[243] = 8'b00110000;
    RAM[244] = 8'b00110000;
    RAM[245] = 8'b00110000;
    RAM[246] = 8'b00110000;
    RAM[247] = 8'b00111000;
    RAM[248] = 8'b00111000;
    RAM[249] = 8'b00111111;
    RAM[250] = 8'b00111111;
    RAM[251] = 8'b00111111;
    RAM[252] = 8'b00111111;
    RAM[253] = 8'b00111111;
    RAM[254] = 8'b00111111;
    RAM[255] = 8'b00111111;
    RAM[256] = 8'b00111111;
    RAM[257] = 8'b00111111;
    RAM[258] = 8'b00010000;
    RAM[259] = 8'b00010000;
    RAM[260] = 8'b00010000;
    RAM[261] = 8'b00111000;
    RAM[262] = 8'b00111000;
    RAM[263] = 8'b00000000;
    RAM[264] = 8'b00111000;
    RAM[265] = 8'b00110000;
    RAM[266] = 8'b00110000;
    RAM[267] = 8'b00110000;
    RAM[268] = 8'b00110000;
    RAM[269] = 8'b00111111;
    RAM[270] = 8'b00111111;
    RAM[271] = 8'b00111111;
    RAM[272] = 8'b00111111;
    RAM[273] = 8'b00111111;
    RAM[274] = 8'b00111111;
    RAM[275] = 8'b00111111;
    RAM[276] = 8'b00111111;
    RAM[277] = 8'b00010000;
    RAM[278] = 8'b00111000;
    RAM[279] = 8'b00010000;
    RAM[280] = 8'b00111000;
    RAM[281] = 8'b00111000;
    RAM[282] = 8'b00111000;
    RAM[283] = 8'b00000000;
    RAM[284] = 8'b00111000;
    RAM[285] = 8'b00111000;
    RAM[286] = 8'b00111000;
    RAM[287] = 8'b00110000;
    RAM[288] = 8'b00110000;
    RAM[289] = 8'b00111111;
    RAM[290] = 8'b00111111;
    RAM[291] = 8'b00111111;
    RAM[292] = 8'b00111111;
    RAM[293] = 8'b00111111;
    RAM[294] = 8'b00111111;
    RAM[295] = 8'b00111111;
    RAM[296] = 8'b00111111;
    RAM[297] = 8'b00010000;
    RAM[298] = 8'b00111000;
    RAM[299] = 8'b00010000;
    RAM[300] = 8'b00010000;
    RAM[301] = 8'b00111000;
    RAM[302] = 8'b00111000;
    RAM[303] = 8'b00111000;
    RAM[304] = 8'b00000000;
    RAM[305] = 8'b00111000;
    RAM[306] = 8'b00111000;
    RAM[307] = 8'b00111000;
    RAM[308] = 8'b00110000;
    RAM[309] = 8'b00111111;
    RAM[310] = 8'b00111111;
    RAM[311] = 8'b00111111;
    RAM[312] = 8'b00111111;
    RAM[313] = 8'b00111111;
    RAM[314] = 8'b00111111;
    RAM[315] = 8'b00111111;
    RAM[316] = 8'b00111111;
    RAM[317] = 8'b00010000;
    RAM[318] = 8'b00010000;
    RAM[319] = 8'b00111000;
    RAM[320] = 8'b00111000;
    RAM[321] = 8'b00111000;
    RAM[322] = 8'b00111000;
    RAM[323] = 8'b00000000;
    RAM[324] = 8'b00000000;
    RAM[325] = 8'b00000000;
    RAM[326] = 8'b00000000;
    RAM[327] = 8'b00000000;
    RAM[328] = 8'b00111111;
    RAM[329] = 8'b00111111;
    RAM[330] = 8'b00111111;
    RAM[331] = 8'b00111111;
    RAM[332] = 8'b00111111;
    RAM[333] = 8'b00111111;
    RAM[334] = 8'b00111111;
    RAM[335] = 8'b00111111;
    RAM[336] = 8'b00111111;
    RAM[337] = 8'b00111111;
    RAM[338] = 8'b00111111;
    RAM[339] = 8'b00111000;
    RAM[340] = 8'b00111000;
    RAM[341] = 8'b00111000;
    RAM[342] = 8'b00111000;
    RAM[343] = 8'b00111000;
    RAM[344] = 8'b00111000;
    RAM[345] = 8'b00111000;
    RAM[346] = 8'b00110000;
    RAM[347] = 8'b00110000;
    RAM[348] = 8'b00111111;
    RAM[349] = 8'b00111111;
    RAM[350] = 8'b00111111;
    RAM[351] = 8'b00111111;
    RAM[352] = 8'b00111111;
    RAM[353] = 8'b00111111;
    RAM[354] = 8'b00111111;
    RAM[355] = 8'b00111111;
    RAM[356] = 8'b00110000;
    RAM[357] = 8'b00110000;
    RAM[358] = 8'b00110000;
    RAM[359] = 8'b00110000;
    RAM[360] = 8'b00000011;
    RAM[361] = 8'b00110000;
    RAM[362] = 8'b00110000;
    RAM[363] = 8'b00110000;
    RAM[364] = 8'b00000011;
    RAM[365] = 8'b00110000;
    RAM[366] = 8'b00110000;
    RAM[367] = 8'b00111111;
    RAM[368] = 8'b00111111;
    RAM[369] = 8'b00010000;
    RAM[370] = 8'b00111111;
    RAM[371] = 8'b00111111;
    RAM[372] = 8'b00111111;
    RAM[373] = 8'b00111111;
    RAM[374] = 8'b00111000;
    RAM[375] = 8'b00111000;
    RAM[376] = 8'b00110000;
    RAM[377] = 8'b00110000;
    RAM[378] = 8'b00110000;
    RAM[379] = 8'b00110000;
    RAM[380] = 8'b00110000;
    RAM[381] = 8'b00000011;
    RAM[382] = 8'b00110000;
    RAM[383] = 8'b00110000;
    RAM[384] = 8'b00110000;
    RAM[385] = 8'b00000011;
    RAM[386] = 8'b00111111;
    RAM[387] = 8'b00111111;
    RAM[388] = 8'b00010000;
    RAM[389] = 8'b00010000;
    RAM[390] = 8'b00111111;
    RAM[391] = 8'b00111111;
    RAM[392] = 8'b00111111;
    RAM[393] = 8'b00111111;
    RAM[394] = 8'b00111000;
    RAM[395] = 8'b00111000;
    RAM[396] = 8'b00111000;
    RAM[397] = 8'b00110000;
    RAM[398] = 8'b00110000;
    RAM[399] = 8'b00110000;
    RAM[400] = 8'b00110000;
    RAM[401] = 8'b00000011;
    RAM[402] = 8'b00000011;
    RAM[403] = 8'b00000011;
    RAM[404] = 8'b00000011;
    RAM[405] = 8'b00111100;
    RAM[406] = 8'b00000011;
    RAM[407] = 8'b00000011;
    RAM[408] = 8'b00010000;
    RAM[409] = 8'b00010000;
    RAM[410] = 8'b00111111;
    RAM[411] = 8'b00111111;
    RAM[412] = 8'b00111111;
    RAM[413] = 8'b00111111;
    RAM[414] = 8'b00111111;
    RAM[415] = 8'b00111000;
    RAM[416] = 8'b00111111;
    RAM[417] = 8'b00111111;
    RAM[418] = 8'b00000011;
    RAM[419] = 8'b00000011;
    RAM[420] = 8'b00000011;
    RAM[421] = 8'b00000011;
    RAM[422] = 8'b00111100;
    RAM[423] = 8'b00000011;
    RAM[424] = 8'b00000011;
    RAM[425] = 8'b00000011;
    RAM[426] = 8'b00000011;
    RAM[427] = 8'b00000011;
    RAM[428] = 8'b00010000;
    RAM[429] = 8'b00010000;
    RAM[430] = 8'b00111111;
    RAM[431] = 8'b00111111;
    RAM[432] = 8'b00111111;
    RAM[433] = 8'b00111111;
    RAM[434] = 8'b00111111;
    RAM[435] = 8'b00111111;
    RAM[436] = 8'b00010000;
    RAM[437] = 8'b00010000;
    RAM[438] = 8'b00000011;
    RAM[439] = 8'b00000011;
    RAM[440] = 8'b00000011;
    RAM[441] = 8'b00000011;
    RAM[442] = 8'b00000011;
    RAM[443] = 8'b00000011;
    RAM[444] = 8'b00000011;
    RAM[445] = 8'b00000011;
    RAM[446] = 8'b00000011;
    RAM[447] = 8'b00000011;
    RAM[448] = 8'b00010000;
    RAM[449] = 8'b00010000;
    RAM[450] = 8'b00111111;
    RAM[451] = 8'b00111111;
    RAM[452] = 8'b00111111;
    RAM[453] = 8'b00111111;
    RAM[454] = 8'b00111111;
    RAM[455] = 8'b00010000;
    RAM[456] = 8'b00010000;
    RAM[457] = 8'b00010000;
    RAM[458] = 8'b00000011;
    RAM[459] = 8'b00000011;
    RAM[460] = 8'b00000011;
    RAM[461] = 8'b00000011;
    RAM[462] = 8'b00000011;
    RAM[463] = 8'b00000011;
    RAM[464] = 8'b00111111;
    RAM[465] = 8'b00111111;
    RAM[466] = 8'b00111111;
    RAM[467] = 8'b00111111;
    RAM[468] = 8'b00111111;
    RAM[469] = 8'b00111111;
    RAM[470] = 8'b00111111;
    RAM[471] = 8'b00111111;
    RAM[472] = 8'b00111111;
    RAM[473] = 8'b00111111;
    RAM[474] = 8'b00111111;
    RAM[475] = 8'b00010000;
    RAM[476] = 8'b00010000;
    RAM[477] = 8'b00111111;
    RAM[478] = 8'b00111111;
    RAM[479] = 8'b00111111;
    RAM[480] = 8'b00111111;
    RAM[481] = 8'b00111111;
    RAM[482] = 8'b00111111;
    RAM[483] = 8'b00111111;
    RAM[484] = 8'b00111111;
    RAM[485] = 8'b00111111;
    RAM[486] = 8'b00111111;
    RAM[487] = 8'b00111111;
    RAM[488] = 8'b00111111;
    RAM[489] = 8'b00111111;
    RAM[490] = 8'b00111111;
    RAM[491] = 8'b00111111;
    RAM[492] = 8'b00111111;
    RAM[493] = 8'b00111111;
    RAM[494] = 8'b00111111;
    RAM[495] = 8'b00111111;
    RAM[496] = 8'b00111111;
    RAM[497] = 8'b00111111;
    RAM[498] = 8'b00111111;
    RAM[499] = 8'b00111111;
    RAM[500] = 8'b00111111;
    RAM[501] = 8'b00111111;
    RAM[502] = 8'b00111111;
    RAM[503] = 8'b00111111;
    RAM[504] = 8'b00111111;
    RAM[505] = 8'b00111111;
    RAM[506] = 8'b00000011;
    RAM[507] = 8'b00001100;
    RAM[508] = 8'b00110000;
    RAM[509] = 8'b00111100;
    RAM[510] = 8'b00110011;
    RAM[511] = 8'b00001111;
  end

  assign data  = we ? 'bz : RAM[address]; 
  assign vdata = RAM[vaddr]; 

  always @(posedge clock)
    if (we) RAM[address] <= data;
endmodule

module vga(
  input clk, reset,
  input  [7:0] vdata,
  output [8:0] vaddr,
  output [3:0] VGA_R, VGA_G, VGA_B, 
  output VGA_HS_O, VGA_VS_O);

  reg [9:0] CounterX, CounterY;
  reg inDisplayArea;
  reg vga_HS, vga_VS;

  wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
  wire CounterYmaxed = (CounterY == 525); // 10 +  2 + 33 + 480
  wire [3:0] row, col;

  always @(posedge clk or posedge reset)
    if (reset)
      CounterX <= 0;
    else 
      if (CounterXmaxed)
        CounterX <= 0;
      else
        CounterX <= CounterX + 1;

  always @(posedge clk or posedge reset)
    if (reset)
      CounterY <= 0;
    else 
      if (CounterXmaxed)
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 1;

  assign row = (CounterY>>5); // 32 pixels x
  assign col = (CounterX>>5); // 32 pixels 
  assign vaddr = 212 + col + (row<<4) + (row<<2); // addr = offset + col + row x 20

  always @(posedge clk)
  begin
    vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
    vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 +  2)));   // active for  2 clocks
    inDisplayArea <= (CounterX < 640) && (CounterY < 480);
  end

  assign VGA_HS_O = ~vga_HS;
  assign VGA_VS_O = ~vga_VS;  

  assign VGA_R = inDisplayArea ? {vdata[5:4], 2'b00} : 4'b0000;
  assign VGA_G = inDisplayArea ? {vdata[3:2], 2'b00} : 4'b0000;
  assign VGA_B = inDisplayArea ? {vdata[1:0], 2'b00} : 4'b0000;
endmodule
 
module power_on_reset(
  input clk, 
  output reset);

  reg q0 = 1'b0;
  reg q1 = 1'b0;
  reg q2 = 1'b0;
 
  always@(posedge clk)
  begin
       q0 <= 1'b1;
       q1 <= q0;
       q2 <= q1;
  end

  assign reset = !(q0 & q1 & q2);
endmodule
