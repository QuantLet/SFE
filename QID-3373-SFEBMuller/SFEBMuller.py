import numpy as np
from matplotlib import pyplot as plt

# main computation
save_figure = True
n = 10000
u1 = np.random.uniform(size=n)
u2 = np.random.uniform(size=n)
theta = 2 * np.pi * u2
rho = np.sqrt(-2 * np.log(u1))
zeta1 = rho * np.cos(theta)
zeta2 = rho * np.sin(theta)

#First Moments of the generated distributions
v1 = np.var(zeta1)
v2 = np.var(zeta2)
m1 = np.mean(zeta1)
m2 = np.mean(zeta1)
print("Normal distribution 1:")
print("Mean: {} \tVariance {}".format(m1,v1))
print("Normal distribution 2:")
print("Mean: {} \tVariance {}".format(m2,v2))

# output
fig = plt.figure()
ax = fig.add_subplot()
ax.scatter(zeta1, zeta2, s=3)
ax.set_title('Numbers generated using Box-Muller Algorithm')
ax.set_xlabel('$Z_1$')
ax.set_ylabel('$Z_2$')
plt.show()

if save_figure:
    fig.savefig('SFEBMuller.png', transparent=True)
