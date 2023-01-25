#!/usr/bin/python

from tables import *
from helpers import *
import sys
import time
from pathlib import Path
from tkinter import filedialog

atable, ltable, dtable, vtable = {}, {}, {}, [] #initialize global tables
address_size = fields_table["address"]
jump_size = fields_table["jump"]
filename = filedialog.askopenfilename()
if filename=='':
    sys.exit(1)

def main():
    a = prepare_file(filename)
    make_ltable(a)
    make_dtable(a)
    make_atable(a)
    results = translate(a)
    write_file(results)  

def prepare_file(filename):
    file = open(filename)
    a = file.readlines()
    a = map(filter_line, a) #map remove comments    
    a = [ i.strip() for i in [ x for x in a ] ] #remove white space
    a = list(filter(lambda x : x != '', a)) #remove empty elements    
    return a

def translate(a):
    global vtable
    f = []
    code = 0
    for i in a:
        if not is_l_command(i) and not is_d_command(i):
            f.append(atable[i])
            code += 1
    if code > space_table["code"]:
        print("Error: out of code memory!")
        sys.exit(2)
    elif code < space_table["code"]:
        for i in range(space_table["code"] - code):
            f.append(to_b(0, 8))
    data = [to_b(0, 8) for i in range(space_table["data"])]
    for i in dtable:
        data[try_parse_int(dtable[i][0], base=2)] = dtable[i][1]
    for i in data:
        f.append(i) 
    video = len(vtable)
    if video > space_table["video"]:
        print( "Warning: video data truncated", video)
        vtable = vtable[0:space_table["video"]] 
    for i in vtable:
        if is_hex(i):
            f.append(to_b(try_parse_int(i, 16),8))
        else:
            f.append(to_b(try_parse_int(i),8))
    if video < space_table["video"]:
        for i in range(space_table["video"] - video):
            f.append(to_b(63, 8)) # white fill
    print( "Video:", len(vtable), "/", space_table["video"] )
    print( "Code:", code, "/", space_table["code"] )
    return f    
        
def make_ltable(a):
    x = 0
    for i in a: # add to symbols table
        x += 1
        if is_l_command(i): #find a label, add line number to it
            x -= 1
            ltable[i[0:-1]] = to_b(x, jump_size) #use binary helper with 0's padding
            print( "Label:", i[0:-1], "address", x)

def make_dtable(a):
    global vtable
    space = 0
    for i in a: # add to symbols table
        if is_d_command(i): 
            var = i.split(' ')[0][1:]
            if len(i.split(' ')) < 2:
                print( "Error: missing value for variable '" + var + "'!")
                sys.exit(8)
            else:
                val = i.split(' ')[1] 
                if var in dtable.keys():
                    print( "Error: redefinition of variable '" + var + "'!")
                    sys.exit(7)
                elif var == "video":
                    print( "Video data declaration")
                    vtable = val.split(",") 
                elif try_parse_int(val) is not None:
                    dtable[var] = [to_b(space, address_size), to_b(int(val))]      
                    space += 1
                    print( "Data declaration"), var
                else:
                    dtable[var] = [to_b(space, address_size),  to_b(0)] # unable to parse
                    space += 1
        if space > space_table["data"]:
            print( "Error: out of data memory!"   )        	
            sys.exit(3)
    print( "Data:", space, "/", space_table["data"])

def make_atable(a):
    for i in a:
        if not is_d_command(i) and not is_l_command(i):
            mnemo = i.split(' ')[0]
            if mnemo != 'LDV' and mnemo != 'STVI':
                param = i.split(' ')[1]
            else:
                atable[i] = inst_table[mnemo] + "1111"
                continue
            if mnemo in inst_table.keys():
                if mnemo[0] == 'J':
                    if param in ltable:
                        param = ltable[param]
                    else:
                        print( "Error: undefined label '" + param + "'!")
                        sys.exit(4)
                else:
                    if param in dtable:
                        param = dtable[param][0]
                    else:
                        print( "Error: undefined variable '" + param + "'!")
                        sys.exit(5)
                atable[i] = inst_table[mnemo] + param
            else:
                print( "Error: unknown instruction '" + mnemo + "'!")
                sys.exit(6)

def write_file(a):
    name = filter_line(filename, op=".")
    name = name + ".bin"
    file = open(name, 'w')
    j=0
    for i in a:
        file.write('RAM['+str(j)+']= 8\'b'+i + ";\n")
        j=j+1
    file.close()       

if __name__ == "__main__":
    t0 = time.time()
    main()
    print("Time: ", time.time()-t0, "s")

