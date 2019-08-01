import pandas as pd
import numpy as np
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.arima_process import arma_generate_sample
import matplotlib.pyplot as plt

# parameter settings
lags = 30    # lag value
n = 100000
alphas = np.array([0.5,0.4])
betas = np.array([0])
# add zero-lag and negate alphas
ar = np.r_[1, -alphas]
ma = np.r_[1, betas]

np.random.seed(123)
simulated_data_1 = arma_generate_sample(ar=ar, ma=ma, nsample=n)
# depending on cpu, plotting may take some time 
ar1 = np.r_[1,[-0.5,-0.4]]
ar2 = np.r_[1,[-0.5,0.4]]
ar3 = np.r_[1,[0.5,0.4]]
ar4 = np.r_[1,[0.5,-0.4]]
ma = np.r_[1, betas]


f, axarr = plt.subplots(2, 2,figsize=(11, 6))
simulated_data_1 = arma_generate_sample(ar=ar1, ma=ma, nsample=n) 
plot_acf(simulated_data_1,lags=lags,zero=False,alpha=None, ax=axarr[0, 0],title='Sample ACF of AR(2) with '+r'$\alpha_1$='+str(-ar1[1])+' and '+r'$\alpha_2$='+str(-ar1[2]))
axarr[0, 0].set_xlabel('lags')
simulated_data_2 = arma_generate_sample(ar=ar2, ma=ma, nsample=n) 
plot_acf(simulated_data_2,lags=lags,zero=False,alpha=None, ax=axarr[0, 1],title='Sample ACF of AR(2) with '+r'$\alpha_1$='+str(-ar2[1])+' and '+r'$\alpha_2$='+str(-ar2[2]))
axarr[0, 1].set_xlabel('lags')
simulated_data_3 = arma_generate_sample(ar=ar3, ma=ma, nsample=n) 
plot_acf(simulated_data_3,lags=lags,zero=False,alpha=None, ax=axarr[1, 0],title='Sample ACF of AR(2) with '+r'$\alpha_1$='+str(-ar3[1])+' and '+r'$\alpha_2$='+str(-ar3[2]))
axarr[1, 0].set_xlabel('lags')
simulated_data_4 = arma_generate_sample(ar=ar4, ma=ma, nsample=n) 
plot_acf(simulated_data_4,lags=lags,zero=False,alpha=None, ax=axarr[1,1],title='Sample ACFof AR(2) with '+r'$\alpha_1$='+str(-ar4[1])+' and '+r'$\alpha_2$='+str(-ar4[2]))
axarr[1, 1].set_xlabel('lags')

plt.tight_layout()
plt.savefig('SFEacfar2_py.png')

plt.show()