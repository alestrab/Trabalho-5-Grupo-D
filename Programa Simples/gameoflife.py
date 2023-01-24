import numpy as np
import copy
def right(data,mat,i,j):
    mat[:,:2] = mat[:,1:]
    mat[:,2] = np.array([data[i,j+1],data[i+1,j+1],data[i+2,j+1]])
    return mat

def left(data,mat,i,j):
    mat[:,1:] = mat[:,:2]
    mat[:,0] = np.array([data[i,j-1],data[i+1,j-1],data[i+2,j-1]])
    return mat

def down(data,mat,i,j):
    mat[:2,:] = mat[1:,:]
    mat[2,:] = np.array([data[i+2,j-1],data[i+2,j],data[i+2,j+1]])
    return mat


N = 10 #100x100 Grid
vec = np.zeros((N,N)) #Grid
for x in range(0,N):
    vec[x,:] = np.array(np.arange(x*N,(x+1)*N,1))
#sub_mat =np.zeros((3,3)) #Matrix to analise each cell
sub_mat = vec[:3,:3].copy()
j=1
i=0
b_right,b_down,b_left = True,False,False

while (i!=N-3):    
    print(sub_mat)
    print('')
        
    if b_down:
        i=i+1
        sub_mat = down(vec,sub_mat,i,j) #Move to next line
        b_down = False
        b_right = not b_right
    else: 
        if b_right:
            j=j+1
            sub_mat = right(vec,sub_mat,i,j) #Move to right untill reach the end
        else:
            j=j-1
            sub_mat = left(vec,sub_mat,i,j) #Move to left untill reach the start
                     
    if (j==1)&(not b_right):
        b_down=True
        
    if (j==(N-2))&b_right:
        b_down = True
        
    
    
        