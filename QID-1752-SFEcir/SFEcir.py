import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt


# parameter settings
r   = 1
k   = 0.1   # reversion rate
mu  = 0.1   # steady state of the short rate
s   = 0.1   # volatility coefficient
n   = 50    # time horizon in years
sr  = 0.05  # today's short rate
tau = np.array(range(1,n+1)).astype(int)   # vector of maturities in years

if (s == 0):
    print("Specify Volatility other than zero!")


if (k < 0):
    print("Mean reversion rate should be non-negative!")


gam  = np.sqrt(k**2 + 2*s**2)
ylim = 2 * k * mu/(gam + k)
g    = 2 * gam + (k + gam) * (np.exp(gam * tau) - 1)
b    = -(2 * (np.exp(gam * tau) - 1))/g
a    = 2 * k * mu/s**2 * np.log(2 * gam * np.exp((k + gam) * tau/2)/g)
p    = np.exp(a+b*sr)    # the bond prices
y    = (-np.ones(tau.shape[0])/tau)*np.log(p)  # the yields

w    = np.concatenate([tau.reshape((-1,1)), y.reshape((-1,1))],axis=1)
wlim = np.concatenate([tau.reshape((-1,1)), np.repeat(ylim,n).reshape((-1,1))],axis=1)

plt.plot(w[:,1],color='blue')
plt.plot(wlim[:,1],color='red')
plt.xlabel('Time to Maturity')
plt.ylabel('Yield')
plt.title('Yield Curve, Cox/Ingersoll/Ross Model')
plt.savefig('SFEcir.png')
plt.show()

