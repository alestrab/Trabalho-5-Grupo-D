
finddist: 
  LOAD counter
  ADD one
  STORE counter
  LDV 
  JNZ next 
  LOAD first
  JNZ second
  LOAD counter
  STORE first
  LOAD one
  JNZ next
second:
  LOAD counter
  SUB first
  STORE dist
  JNZ enddist
next:
  LDV
  STVI
  LOAD one
  JNZ finddist
enddist:
    LOAD size
    SUB counter
    ADD first
    STORE first
enddist2:
    LOAD first
    JNZ offset
    LOAD one
    JNZ fillline
offset:
    LDV
    STVI
    LOAD first
    SUB one
    STORE first
    LOAD one
    JNZ enddist2
fillline:
  LOAD dist  
  SUB one    
  STORE dist
  JNZ move   
fillcolumn:
  LOAD finaldist
  JNZ fill
  LOAD one
  JNZ end
fill:
  LOAD zero
  STVI
  LOAD finaldist
  SUB one
  STORE finaldist
  LOAD one
  JNZ fillcolumn
move:
  LOAD seven
  SUB i
  JNZ nmultiplo 
  LOAD finaldist
  SUB i
  STORE finaldist
multiplo:
  LOAD i   
  JNZ prox 
  LOAD zero 
  STVI
  LOAD one
  JNZ fillline
prox:
  LDV
  STVI
  LOAD i
  SUB i
  JNZ multiplo
nmultiplo:
  LOAD i
  ADD one
  STORE i
  JNZ fillline

end:
LOAD max
delay:    
  SUB one
  STORE temp
  LOAD max
redelay:
  SUB one
  JNZ redelay
  LOAD temp
  JNZ delay
  LOAD max 
  JNZ end 

.video 0xFF,0xFF,0xFF,0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF

.counter 0
.first 0
.dist 0
.finaldist 0
.i 0
.zero 0
.one 1
.seven 7
.size 79
.temp 0
.max 255