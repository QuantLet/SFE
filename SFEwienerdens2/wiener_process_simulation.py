
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Parameters
dt = 0.01
c = 2
s = 150
a = 90
b = 110
x0 = 50

# Main calculation
l = 200
n = int(np.floor(l / dt))
t = np.arange(0, (n + 1) * dt, dt)

np.random.seed(80)
z1 = np.random.uniform(0, 1, n)
z = np.where(z1 < 0.5, 1, -1)
z = z * c * np.sqrt(dt)
x = np.concatenate(([x0], x0 + np.cumsum(z)))

# Computing the normal distribution
max1 = np.max(x)
min1 = np.min(x)
sigma = np.sqrt(max(t) - s) * c
mu_index = int(s / dt)
mu = x[mu_index]
ndata = np.arange(min1 - sigma ** 2, sigma ** 2 * (max1 - min1), 0.2)
f = 750 * 1 / np.sqrt(2 * np.pi * sigma ** 2) * np.exp(-(ndata - mu) ** 2 / (2 * sigma ** 2)) + max(t)
fndata = np.column_stack((f, ndata))

# Plot
plt.figure(figsize=(8, 8))
plt.plot(x, color="blue", linewidth=0.8)
plt.ylim(min1 - sigma, max1 + sigma)
plt.xlim(0, (max(f) + 0.5) * 100)
plt.xlabel("Iteration Number")
plt.ylabel("Wiener Process Value")
plt.title("Wiener Process Simulation", fontweight='bold')

# Vertical lines
plt.axvline(x=s * 100, color="black", linewidth=1.2)
plt.axvline(x=max(t) * 100, color="black", linewidth=1.2)

# Normal distribution curve
plt.plot(f * 100, ndata, color="red", linewidth=2)

# Horizontal line for mean
plt.hlines(mu, s * 100, max(f) * 100, color="black", linewidth=1, linestyle="--")

# Shaded area for ±1 std deviation
a_fill = mu - sigma
b_fill = mu + sigma
i = a_fill
while i < b_fill:
    height = 750 * 1 / np.sqrt(2 * np.pi * sigma ** 2) * np.exp(-(i - mu) ** 2 / (2 * sigma ** 2)) + max(t)
    plt.plot([100 * (max(t) + 0.4), 100 * height], [i, i], color="red", linewidth=2)
    i += 0.1

# Ticks and grid
plt.xticks(np.arange(0, (max(f) + 0.5) * 100, 5000))
plt.yticks(np.arange(-10, 80, 10))
plt.grid(which='both', linestyle='dotted', linewidth=0.6, color='grey')

plt.tight_layout()
plt.show()
