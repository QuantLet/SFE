import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
import mpl_toolkits
from mpl_toolkits import mplot3d

nop = 30  # number of grid points (in the book = 31)
k   = nop
s   = 0.31/nop
q   = np.arange(0,s*k,s)
q   = np.array(q)


# computing grid
w = np.zeros((k**2, 2))
for i in range(k):
    for j in range(k):
        w[i + (j - 1) * k, 0] = q[i]
        w[i + (j - 1) * k, 1] = q[j]

a = w[:,0]
b = w[:,1]

# kurtosis, formula from the book SFE: Fourth moment of a GARCH(1,1) process
def kurtosis(a,b):
	f = 3 + 6 * a**2/(1 - b**2 - 2 * a * b - 3 * a**2)
	return(f)

df = pd.DataFrame({'x': a, 'y': b, 'z': kurtosis(a,b)}, index=range(len(a)))
ax = plt.axes(projection='3d')
c    = ((1, 1, 1),(1, 1.0, 1))
ax.plot_trisurf(df.x, df.y, df.z,linewidth=0.2,cmap='viridis',facecolors=c)
ax.grid(False)

ax.view_init(30, 225)
ax.set_xlabel(r'$\alpha$')
ax.set_ylabel(r'$\beta$')
ax.set_zlabel(r'$\kappa$')
ax.set_title('Kurtosis of GARCH(1,1) process')
ax.set_zlim(3,4.5)
plt.xticks(rotation=45)
ax.xaxis.labelpad = 20
ax.yaxis.labelpad = 20
plt.yticks(rotation=45)
ax.w_xaxis.set_pane_color((1.0, 1.0, 1.0, 1.0))
ax.w_zaxis.set_pane_color((1.0, 1.0, 1.0, 1.0))
ax.w_yaxis.set_pane_color((1.0, 1.0, 1.0, 1.0))
plt.savefig('SFEkurgarch_py.png')
plt.show()


