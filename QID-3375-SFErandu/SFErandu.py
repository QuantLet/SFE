import numpy as np
from matplotlib import pyplot as plt
import matplotlib.animation as animation

# parameter settings
save_figure = True         # Generate a gif of the 3D plot?
n = 1000
a = 1229
b = 1
M = 2048
seed = 12

# main computation
y = [seed]
for i in range(1, n+1):
    y.append((a * y[-1] + b)%M)  # modulus

y = np.array(y)
y = y/M

#output
fig = plt.figure()
ax = fig.add_subplot(projection='3d')
ax.scatter(y[:-2], y[1:-1], y[2:])
ax.set_title('Numbers generated using RANDU')
ax.set_xlabel('$U_{i-2}$')
ax.set_ylabel('$U_{i-1}$')
ax.set_zlabel('$U_i$')
plt.show()

# Generate gif
if save_figure:
    def rotate(angle):
        ax.view_init(azim=angle)

    rot_animation = animation.FuncAnimation(fig, rotate, frames=np.arange(0, 362, 2), interval=100)
    rot_animation.save('SFErandu.gif', dpi=80)

