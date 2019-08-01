import pandas as pd
import numpy as np
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.arima_process import arma_generate_sample
import matplotlib.pyplot as plt


# parameter settings
lags = 30    # lag value
n = 1000
alphas = np.array([0.])

# add zero-lag and negate alphas
ar = np.r_[1, -alphas]
ma1 = np.r_[1, np.array([0.5,0.4])]
ma2 = np.r_[1, np.array([-0.5,0.4])]
ma3 = np.r_[1, np.array([-0.5,-0.4])]
ma4 = np.r_[1, np.array([0.5,-0.4])]


f, axarr = plt.subplots(2, 2,figsize=(11, 6))
simulated_data_1 = arma_generate_sample(ar=ar, ma=ma1, nsample=n) 
plot_acf(simulated_data_1,lags=lags,alpha=None,zero=False, ax=axarr[0, 0],title='Sample ACF Plot with '+r'$\beta_1$='+str(ma1[1])+' and '+r'$\beta_2$='+str(ma1[2]))
axarr[0, 0].set_xlabel('lags')
simulated_data_2 = arma_generate_sample(ar=ar, ma=ma2, nsample=n) 
plot_acf(simulated_data_2,lags=lags,alpha=None,zero=False, ax=axarr[0, 1],title='Sample ACF Plot with '+r'$\beta_1$='+str(ma2[1])+' and '+r'$\beta_2$='+str(ma2[2]))
axarr[0, 1].set_xlabel('lags')
simulated_data_3 = arma_generate_sample(ar=ar, ma=ma3, nsample=n) 
plot_acf(simulated_data_3,lags=lags,alpha=None,zero=False, ax=axarr[1, 0],title='Sample ACF Plot with '+r'$\beta_1$='+str(ma3[1])+' and '+r'$\beta_2$='+str(ma3[2]))
axarr[1, 0].set_xlabel('lags')
simulated_data_4 = arma_generate_sample(ar=ar, ma=ma4, nsample=n) 
plot_acf(simulated_data_4,lags=lags,alpha=None,zero=False, ax=axarr[1,1],title='Sample ACF Plot with '+r'$\beta_1$='+str(ma4[1])+' and '+r'$\beta_2$='+str(ma4[2]))
axarr[1, 1].set_xlabel('lags')
plt.tight_layout()

plt.savefig('SFEacfma2_py.png')
plt.show()