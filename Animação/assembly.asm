LDV
STORE a
STORE b
STVI
loop:
    LOAD coluna
    STORE c
    column:
        LDV  
        STORE a
        LOAD b
        STVI
        LOAD a
        STORE b
        LOAD c
        SUB one
        STORE c
        JNZ column
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
  JNZ loop 

.video 0xff,0x7f,0x55,0xaf,0xfe,0xff,0x5f,0x55,0x95,0xfe,0xff,0xf,0x28,0x56,0xfd,0xff,0x23,0x2a,0x6a,0xfd,0xff,0x23,0xa8,0xa8,0xfd,0xff,0x83,0x2a,0x0,0xff,0xff,0xbf,0xaa,0x5a,0xff,0xff,0x55,0x55,0xd5,0xf3,0xaf,0x55,0x55,0xf5,0xf0,0xaf,0x56,0x55,0x59,0xf0,0xbf,0x5f,0x65,0x55,0xf0,0xff,0x50,0x55,0x55,0xf0,0x3f,0x50,0x55,0xff,0xff,0x3f,0xfc,0xff,0xff,0xff,0xff,0xff,0xff,0x9f,0xa9

.one 1
.temp 0
.max 255
.a 0
.b 0
.c 0
.coluna 7