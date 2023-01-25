inst_table = {
    "LDV"   : "0000",
    "STVI"  : "0001",
    "ADD"   : "0101",
    "SUB"   : "0110",
    "LOAD"  : "0100",
    "STORE" : "0011",
    "JNZ"   : "1"
}

space_table = {       #   dec   |        bin        |  hex
    "code"   : 128,   #   0:127 | 00000000:01111111 | 00:7f
    "video"  :  80,   # 128:207 | 10000000:11001111 | 80:cf
    "unused" :  32,   # 208:239 | 11010000:11101111 | d0:ef
    "data"   :  16    # 240:255 | 11110000:11111111 | f0:ff
}

fields_table = {
    "opcode"  : 4,
    "address" : 4,
    "jump"    : 7
}