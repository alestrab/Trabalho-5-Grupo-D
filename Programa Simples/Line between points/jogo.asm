#Procura dois pontos pretos e conecta uma linha entre eles
#Video possui 8x10 no total

finddist: #Encontra a distancia entre dois pixels pretos e coloca na variavel dist
  LOAD counter
  ADD one
  STORE counter
  LDV 
  JNZ next 
  #Achou um ponto preto 
  LOAD first
  JNZ second
  #Eh o primeiro a ser encontrado
  LOAD counter
  STORE first
  LOAD one
  JNZ next
second:
  #Segundo ponto preto
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
LOAD zero
STORE counter

fillline:
  LOAD dist     #Carrega a distancia
  SUB one       #Aproxima 1
  STORE dist
  JNZ move   #Checa se ainda falta pra chegar
  #Chegou
fillcolumn:
  LOAD finaldist
  JNZ fill
  LOAD one
  JNZ end
fill:
  LDV zero
  STVI
  LOAD finaldist
  SUB one
  STORE finaldist
  LOAD one
  JNZ fillcolumn

move:
  LOAD seven
  SUB i
  JNZ nmultiplo #Checa se jah foram feitas 8 subtracoes, indicando que a distancia tem um multiplo de oito
  #Deu 8
  LOAD finaldist
  SUB i
  STORE finaldist
multiplo:
  #Chegou no 8
  LOAD i    #Carrega o contador de posicao
  JNZ prox #Checa se ja andou 8 posicoes de memoria
  #Chegou na posicao
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
nmultiplo:    #Nao deu 8
  LOAD i
  ADD one
  STORE i
  JNZ fillline

end:
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
  JNZ end 

.video 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
.counter 0
.first 0
.dist 0
.finaldist 0
.i 0

.zero 0
.one 1
.seven 7
.temp 0
.max 255