import numpy as np
import copy
import matplotlib.animation as animation
import matplotlib.pyplot as plt
import random

def right(data,mat,i,j):
    mat[:,:2] = mat[:,1:]
    mat[:,2] = np.array([data[i-1,j+1],data[i,j+1],data[i+1,j+1]])
    return mat

def left(data,mat,i,j):
    mat[:,1:] = mat[:,:2]
    mat[:,0] = np.array([data[i-1,j-1],data[i,j-1],data[i+1,j-1]])
    return mat

def down(data,mat,i,j):
    mat[:2,:] = mat[1:,:]
    mat[2,:] = np.array([data[i-1,j-1],data[i,j],data[i+1,j+1]])
    return mat

def conway(vec):
    N = len(vec)
    new_vec = vec.copy()
    sub_mat = vec[:3,:3].copy()

    j=1
    i=1
    b_right,b_down,b_left = True,False,False

    while (i!=N-1):    

        
        if sum(sum(sub_mat))-sub_mat[1,1] == 3:
            cell = 1
        elif sum(sum(sub_mat))-sub_mat[1,1] == 2:
            cell = vec[i,j]
        else:
            cell = 0
        new_vec[i,j] = cell

        if b_down:
            sub_mat = down(vec,sub_mat,i,j) #Move to next line
            b_down = False
            b_right = not b_right
            i=i+1
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
    
    return new_vec

def create_video(n):
    global vec
    fig = plt.figure()
    im = plt.imshow(vec, cmap = plt.cm.gray)

    def animate(t):
        global vec
        if t!=0:
            vec = conway(vec)
        im.set_array(vec)
        return im, 

    anim = animation.FuncAnimation(
        fig,
        animate,
        frames = 100,
        interval = 250,
        blit = True
    )
    plt.axis('off')
    plt.show()


    return anim


N = 100 #10x10 grid
init_cells = int(10*N)    
vec = np.zeros((N,N)) #Grid
for i in range(0,init_cells):
    j = random.randint(1,N-2)
    k = random.randint(1,N-2)
    vec[j,k] = 1

anim = create_video(N)