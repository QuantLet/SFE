import pandas as pd
import numpy as np
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.tsa.arima_process import ArmaProcess
import matplotlib.pyplot as plt


# parameter settings
lag = 30    # lag value
n = 1000    #sampled values
b = 0.5    


np.random.seed(123)
# Obtain MA(1) sample by sampling from a ARMA() model with no AR coefficient
ar1 = np.array([1])
ma1 = np.array([1,b])
MA_object1 = ArmaProcess(ar1,ma1)
simulated_data_1 = MA_object1.generate_sample(nsample=1000)

ma1 = np.array([1,-b])
MA_object1 = ArmaProcess(ar1,ma1)
simulated_data_2 = MA_object1.generate_sample(nsample=1000)

f, axarr = plt.subplots(2, 1,figsize=(11, 6))
plot_acf(simulated_data_1,lags=lag,ax=axarr[0],title='Sample ACF of the Simulated MA(1) Process with '+r'$\beta=0.5$',zero=False,alpha=None)
plot_acf(simulated_data_2,lags=lag,ax=axarr[1],title='Sample ACF of the Simulated MA(1) Process with '+r'$\beta=-0.5$',zero=False,alpha=None)
plt.tight_layout()

plt.show()
plt.savefig('SFEacfma1_py.png')

