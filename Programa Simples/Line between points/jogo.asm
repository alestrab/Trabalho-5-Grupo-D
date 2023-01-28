#Encontra a distancia entre os dois pontos
finddist: 
  LOAD counter
  ADD one
  STORE counter
  LDV 
  JNZ next  #Checa se chegou em um ponto preto 
  LOAD first 
  JNZ second  #Checa se eh o primeiro 
  LOAD counter 
  STORE first #Adiciona o valor do contador na variavel first
  LOAD one
  JNZ next
second:
  LOAD counter
  SUB first
  STORE dist  #dist = counter - first, dando a distancia entre os pontos pretos
  JNZ enddist
next:
  LDV
  STVI
  LOAD one
  JNZ finddist
enddist:
#Corrige a posicao de video para o primeiro ponto preto
    LOAD size   #size = tamanho da imagem (79 pixels)
    SUB counter #subtrai o numero de pixels que foi percorrido ateh encontrar os dois pontos 
    ADD first   
    STORE first 
posinitial:
#Incrementa o endereco de video ateh que o mesmo esteja na posicao do primeiro ponto preto
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
    JNZ posinitial

#Formacao da linha entre os pontos
#dist = distancia entre os pontos, vai sendo subtraido 1 ateh chegar em 0
#finaldist = distancia final, vai sendo subtraido apenas multiplos de 8 ateh chegar no valor final nao multiplo
fillline:
  LOAD dist  
  SUB one    
  STORE dist
  JNZ move   
#Preenche as celulas finais
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
#Subrotina de fazer a linha - Move para outro endereco de video e checa se eh multiplo de 8 (numero de linhas)
move:
  LOAD seven
  SUB i
  JNZ nmultiplo 
  LOAD finaldist
  SUB i
  STORE finaldist
multiplo:
#Preenche a celula na linha para alinhar com o ponto preto inicial
  LOAD i   
  JNZ prox 
  LOAD zero 
  STVI
  LOAD one
  JNZ fillline
prox:
#Passa para o proximo endereco ateh chegar na linha na celula multipla a ser preenchida
  LDV
  STVI
  LOAD i
  SUB one
  STORE i
  LOAD one
  JNZ multiplo
nmultiplo:
  LOAD i
  ADD one
  STORE i
  JNZ fillline
#Delay e redelay
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

#Contador para achar a distancia entre pontos
.counter 0
#Distancia entre os pontos
.dist 0
#Guarda o resto de enderecos a serem preenchidos para completar a linha
.finaldist 0
#Posicao do primeiro ponto preto
.first 0
#Contador para verificar se o numero tem uma componente multiplo do numero de colunas
.i 0
#Numero de colunas
.seven 7
#Tamanho da imagem
.size 79

.zero 0
.one 1
.max 255
.temp 0