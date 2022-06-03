import numpy as np
from scipy.stats import norm

# input variables
K = 100
S = 98
r = 1/20
b = 1/20
tau = 20/52
sig = 1/5

# main computation
y = (np.log(S/K) + (b - (sig**2)/2) * tau)/(sig * np.sqrt(tau))
c = np.exp(-(r - b) * tau) * S * norm.cdf(y + sig * np.sqrt(tau)) - np.exp(-r * tau) * K * norm.cdf(y)

# output
print("The call price is {}".format(c))