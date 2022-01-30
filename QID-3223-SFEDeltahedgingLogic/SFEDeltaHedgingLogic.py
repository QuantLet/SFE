import numpy as np
from scipy.stats import norm
from matplotlib import pyplot as plt

# parameter settings
save_figure = True
n = 50                          # periods (steps)
K = 100                         # exercise price
S0 = 98                         # initial stock price
sig = 0.2                       # volatility
r = 0.05                        # interest rate
t0 = 6/52                       # current time (1 week = 1/52)
T = 26/52                       # maturity
dt = (T - t0)/n                 # period between steps n
t = np.linspace(t0, T, n)       # T-t0 divided in n intervals
tau = T - t                     # time to maturity

# Standard Wiener Process for path of the stock price S
Wt1 = np.concatenate((np.array([0]), np.sqrt(dt)*np.cumsum(np.random.normal(size=n-1))))
S1 = S0 * np.exp((r - 0.5 * sig**2) * t + sig * Wt1)

# 1st path
with np.errstate(divide='ignore'):
    y1 = (np.log(S1/K) + (r - sig**2/2) * tau)/(sig * np.sqrt(tau))
delta1 = norm.cdf(y1 + sig * np.sqrt(tau))

# 2nd path
Wt2 = np.concatenate((np.zeros(1), np.sqrt(dt)*np.cumsum(np.random.normal(size=n-1))))
S2 = S0 * np.exp((r - 0.5 * sig**2) * t + sig * Wt2)
with np.errstate(divide='ignore'):
    y1 = (np.log(S2/K) + (r - sig**2/2) * tau)/(sig * np.sqrt(tau))
delta2 = norm.cdf(y1 + sig * np.sqrt(tau))

# 3 Plots
fig = plt.figure()

# Plot S(t) vs. tau
ax = fig.add_subplot(3,1,1)
ax.plot(S1, c='r')
ax.plot(S2, c='b')
ax.axhline(K, c='black', linestyle='dashed')
ax.set_title('Stock Price Paths')
ax.set_xlabel('Steps')
ax.set_ylabel('Stock price')
ax.legend(('S1', 'S2', 'K'))

# Plot Delta vs. tau
ax = fig.add_subplot(3,1,2)
ax.plot(delta1, c='r')
ax.plot(delta2, c='b')
ax.set_title('Dependence of Delta on Steps')
ax.set_xlabel('Steps')
ax.set_ylabel('Delta')
ax.legend(('Delta 1', 'Delta 2'))

# Plot Delta vs. S(t)
ax = fig.add_subplot(3,1,3)
ax.scatter(S1, delta1, c='r', marker='x')
ax.scatter(S2, delta2, c='b', marker='x')

# Linear regression
b, m = np.polynomial.polynomial.polyfit(S1, delta1, 1)
ax.plot(S1, b + m * S1, '-', c='r', linewidth=0.5)
b, m = np.polynomial.polynomial.polyfit(S2, delta2, 1)
ax.plot(S2, b + m * S2, '-', c='b', linewidth=0.5)

ax.set_title('Dependence of Delta on Stock Price')
ax.set_xlabel('Stock Price')
ax.set_ylabel('Delta')
ax.legend(('Delta 1', 'Delta 2'))

fig.tight_layout()
plt.show()

if save_figure:
    fig.savefig('SFEDeltaHedgingLogic.png', transparent=True)
