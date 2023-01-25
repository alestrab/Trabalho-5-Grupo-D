import numpy as np
from tkinter import filedialog
import pathlib as pat

def gray(r,g,b):
    gr = round((r+2*g+b)/4,0)
    if gr==0:
        return 0
    elif gr==1:
        return 1
    elif gr==2:
        return 10
    else:
        return 11

file_path = filedialog.askopenfilename()
filename=(pat.Path(file_path).stem)
if file_path=='':
    exit()
else:
    data = np.loadtxt(file_path,dtype=str)
i=0
for x in data:
    data[i] = x[2:]
    i=i+1
video = np.zeros(80,dtype=int)
hexa = []
j=0 #pixel
i=0 #Line
for x in data:
    r = int(x[0:2],2)
    g = int(x[2:4],2)
    b = int(x[4:6],2)
    gr = gray(r,g,b)
    video[i] = video[i] + gr*(10**(2*j)) #Little endian
    if j==3:
        hexa.append(hex(int(str(video[i]),2))+',')
        j=0
        i=i+1
    else:
        j=j+1
hexa = np.array(hexa)
with open(filename+'-convertido.bin','wb') as f:
    np.savetxt(f, hexa,fmt = '%s')

        






    

