import pandas as pd
import numpy as np
import statsmodels
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.arima_process import ArmaProcess
import matplotlib
import matplotlib.pyplot as plt

# parameter settings
lag = 30    # lag value
n = 1000
a = 0.9

np.random.seed(123)
# Obtain MA(1) sample by sampling from a ARMA() model with no AR coefficient
ar1 = np.array([1,-a])
ma1 = np.array([1])
MA_object1 = ArmaProcess(ar1,ma1)
simulated_data_1 = MA_object1.generate_sample(nsample=50000)

ar1 = np.array([1,a])
ma1 = np.array([1])
MA_object2 = ArmaProcess(ar1,ma1)
simulated_data_2 = MA_object2.generate_sample(nsample=50000)



f, axarr = plt.subplots(2, 1,figsize=(11, 6))
plot_acf(simulated_data_1,lags=lag,ax=axarr[0],zero=False,alpha=None,title='Sample ACF of an AR(1) Process with '+r'$\alpha_1=0.9$')
plot_acf(simulated_data_2,lags=lag,ax=axarr[1],zero=False,alpha=None,title='Sample ACF of an AR(1) Process with '+r'$\alpha_1=-0.9$')
plt.tight_layout()
plt.savefig('SFEacfar1_py.png')
plt.show()