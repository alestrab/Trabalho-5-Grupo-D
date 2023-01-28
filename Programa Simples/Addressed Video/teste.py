from matplotlib.animation import FuncAnimation
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams["figure.figsize"] = [7.00, 3.50]
plt.rcParams["figure.autolayout"] = True

fig, ax = plt.subplots()

def update(i):
    im_normed = np.random.rand(6, 6)
    ax.imshow(im_normed)
    ax.set_axis_off()

anim = FuncAnimation(fig, update, frames=20, interval=50)

plt.show()