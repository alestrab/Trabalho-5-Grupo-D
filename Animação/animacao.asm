#Inverte a cor de um pixel entre preto e branco, de maneira alternada
loop:
    LOAD i 
    JNZ mantem      #Se 1, inverte a cor do pixel, do contrario mantem
    LDV  #Carrega o pixel
    JNZ branco      #Cor eh branca
    LOAD max #Inverte
    JNZ done
  branco:
    LOAD zero #Inverte
  done:
    STVI            #Salva e incrementa a posicao
    LOAD one
    STORE i         #Proximo irah manter a cor
    JNZ final
  mantem:
    LDV
    STVI            #Proximo pixel
    LOAD zero
    STORE i
  final:
    LOAD max

delay:          #Delay para visualizacao
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

.video 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF

.one 1
.temp 0
.max 255
.zero 0
.i 0