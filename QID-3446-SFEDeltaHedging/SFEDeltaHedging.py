import numpy as np
from scipy.stats import norm
from matplotlib import pyplot as plt

# parameter settings
save_figure = True
n = 50          # periods (steps)
S0 = 98         # initial stock price
sig = 0.2       # volatility (uniform distributed on 0.1 to 0.5)
r = 0.05        # interest rate (uniform distributed on 0 to 0.1)
K = 100         # exercise price
t0 = 6/52       # current time (1 week = 1/52)
mat = 26/52     # maturity
sims = 3        # number of simulations


def generate_paths(S0, sig, maturity, K, r, n, t0):
    dt = (maturity - t0) / n  # period between steps n
    t = np.linspace(t0, maturity, n)   # maturity - t0 divided in n intervals
    tau = maturity - t  # time to maturity

    # Simulate the stock price path
    Wt = np.concatenate((np.array([0]), np.sqrt(dt) * np.cumsum(np.random.normal(size=n - 1))))
    S = S0 * np.exp((r - 0.5 * sig ** 2) * t + sig * Wt)

    # Compute delta and the associated hedging costs
    with np.errstate(divide='ignore'):
        y = (np.log(S / K) + (r - sig ** 2 / 2) * tau) / (sig * np.sqrt(tau))
    delta = norm.cdf(y + sig * np.sqrt(tau))
    delta_diff = np.concatenate((np.array([0]), np.diff(delta)))
    hedge_costs = S * delta_diff
    cum_hedge_costs = np.cumsum(hedge_costs)

    return S, cum_hedge_costs

# Plot
fig = plt.figure()
ax1 = fig.add_subplot(2,1,1)
ax1.set_title('Stock Price Paths')
ax1.set_xlabel('Steps')
ax1.set_ylabel('Stock Price')
ax2 = fig.add_subplot(2,1,2)
ax2.set_title('Cumulative Hedge Costs')
ax2.set_xlabel('Steps')
ax2.set_ylabel('Costs')

ax1.axhline(K, c='black', linestyle='dashed')

for _ in range(sims):
    S, cum_edge_costs = generate_paths(S0, sig, mat, K, r, n, t0)
    ax1.plot(S)
    ax2.plot(cum_edge_costs)

fig.tight_layout()
plt.show()

if save_figure:
    fig.savefig('SFEDeltahedging.png', transparent=True)
