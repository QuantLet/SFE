import numpy as np
from matplotlib import pyplot as plt

# parameter settings
save_figure = True
nn = 18
a = 1366
b = 150889
M = 714025
seed = 1234567
n = 10000

# Main computation
y = [seed]
for i in range(1, nn+1):
    y.append((a * y[i - 1] + b)%M)

y = [y_element / M for y_element in y]

for i in range(19, n+18+1):
    zeta = y[i - 17] - y[i - 5]
    if zeta < 0: zeta += 1
    y.append(zeta)

y = np.array(y)
y = y[19:n + 18]

# output
fig = plt.figure()
ax = fig.add_subplot()
ax.scatter(y[:-1], y[1:], s=3)
ax.set_title('Numbers generated using Fibonacci Algorithm')
ax.set_xlabel('$U_{i-1}$')
ax.set_ylabel('$U_i$')
plt.show()

if save_figure:
    fig.savefig('SFEfibonacci.png', transparent=True)
