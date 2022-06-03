import numpy as np
from matplotlib import pyplot as plt

# parameter settings
save_figure = True
n = 1000
a = 2
b = 0
M = 11
seed = 12

# main computation
y = [seed]
for i in range(1, n+1):
    y.append((a * y[-1] + b)%M)  # modulus

y = np.array(y)
y = y/M

# output
fig = plt.figure()
ax = fig.add_subplot()
ax.scatter(y[:-1], y[1:])
ax.set_title('Numbers generated using RANDU')
ax.set_xlabel('$U_{i-1}$')
ax.set_ylabel('$U_i$')
plt.show()

if save_figure:
    fig.savefig('SFErange1.png', transparent=True)
