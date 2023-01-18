inst_table = {
    "ADD": "0000",
    "SUB": "0001",
    "STR": "0010",
    "LDR": "0011",
    "LDRV": "01",
    "STRV": "10",
    "JNZ": "11"
}

space_table = {       #   dec   |        bin        |  hex
    "code"   : 64,   #   0:63 | 00000000:00111111 | 00:3f
    "stvideo"  :  64,   # 64:127 | 01000000:01111111 | 40:7f
    "ldvideo"  :  64,   # 128:191 | 10000000:10111111 | c0:ef
    "unused"  :  48,   # 192:239 | 11000000:11101111 | c0:ef
    "data"   :  16    # 240:255 | 11110000:11111111 | f0:ff
}

fields_table = {
    "opcode"  : 4,
    "address" : 4,
    "jump"    : 6
}
