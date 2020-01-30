[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEpacfar2** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: SFEpacfar2

Published in: Statistics of Financial Markets

Description: 'Plots the partial autocorrelation function of an AR(2) (autoregressive) process.'

Keywords: acf, partial, PACF, autocorrelation, autoregressive, discrete, graphical representation, linear, plot, process, simulation, stationary, stochastic, stochastic-process, time-series

See also: SFEacfar1, SFEacfar2, SFEacfma1, SFEacfma2, SFEpacfma2, SFEfgnacf

Author: Joanna Tomanek
Author[Python]: Justin Hellermann

Submitted: Fri, June 13 2014 by Felix Jung
Submitted[Python]: Thu, Aug 01 2019 by Justin Hellermann

Input: 
- lag : lag value
- a1 : alpha_1
- a2 : alpha_2

Example: 
- 1: a1=0.5, a2=0.4 and lag=30
- 2: a1=0.5, a2=-0.4 and lag=30
- 3: a1=-0.5, a2=0.4 and lag=30
- 4: a1=-0.5, a2=-0.4 and lag=30

```

![Picture1](SFEpacfar2_1-1.png)

![Picture2](SFEpacfar2_2-1.png)

![Picture3](SFEpacfar2_3-1.png)

![Picture4](SFEpacfar2_4-1.png)

![Picture5](SFEpacfar2_py.png)

### R Code
```r


# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = "30"  # lag value
a1  = "0.5"  # value of alpha_1
a2  = "0.4"  # value of alpha_2

# Input alpha1
message = "      give alpha1"
default = a1
a1 = winDialogString(message, default)
a1 = type.convert(a1, na.strings = "NA", as.is = FALSE, dec = ".")

# Input alpha2
message = "      give alpha2"
default = a2
a2 = winDialogString(message, default)
a2 = type.convert(a2, na.strings = "NA", as.is = FALSE, dec = ".")

# Input lag
message = "      give lag"
default = lag
lag = winDialogString(message, default)
lag = type.convert(lag, na.strings = "NA", as.is = FALSE, dec = ".")

# Plot
plot(ARMAacf(ar = c(a1, a2), ma = numeric(0), lag.max = lag, pacf = TRUE), type = "h", 
    xlab = "lag", ylab = "pacf")
title("Sample partial autocorrelation function (pacf)")
```

automatically created on 2019-08-02

### PYTHON Code
```python

import pandas as pd
import numpy as np
from statsmodels.graphics.tsaplots import plot_pacf
from statsmodels.tsa.arima_process import arma_generate_sample
import matplotlib.pyplot as plt

# parameter settings
lags = 30    # lag value
n = 100000
alphas = np.array([0.5,0.4])
betas = np.array([0])
# add zero-lag and negate alphas
ar1 = np.r_[1,[-0.5,-0.4]]
ar2 = np.r_[1,[-0.5,0.4]]
ar3 = np.r_[1,[0.5,0.4]]
ar4 = np.r_[1,[0.5,-0.4]]
ma = np.r_[1, betas]


f, axarr = plt.subplots(2, 2,figsize=(11, 6))
simulated_data_1 = arma_generate_sample(ar=ar1, ma=ma, nsample=n) 
plot_pacf(simulated_data_1,lags=lags, ax=axarr[0, 0],zero=False,alpha=None,title='Sample PACF of AR(2) with '+r'$\alpha_1$='+str(-ar1[1])+' and '+r'$\alpha_2$='+str(-ar1[2]))
axarr[0, 0].set_xlabel('lags')
simulated_data_2 = arma_generate_sample(ar=ar2, ma=ma, nsample=n) 
plot_pacf(simulated_data_2,lags=lags, ax=axarr[0, 1],zero=False,alpha=None,title='Sample PACF of AR(2) with '+r'$\alpha_1$='+str(-ar2[1])+' and '+r'$\alpha_2$='+str(-ar2[2]))
axarr[0, 1].set_xlabel('lags')
simulated_data_3 = arma_generate_sample(ar=ar3, ma=ma, nsample=n) 
plot_pacf(simulated_data_3,lags=lags, ax=axarr[1, 0],zero=False,alpha=None,title='Sample PACF of AR(2) with '+r'$\alpha_1$='+str(-ar3[1])+' and '+r'$\alpha_2$='+str(-ar3[2]))
axarr[1, 0].set_xlabel('lags')
simulated_data_4 = arma_generate_sample(ar=ar4, ma=ma, nsample=n) 
plot_pacf(simulated_data_4,lags=lags, ax=axarr[1,1],zero=False,alpha=None,title='Sample PACF of AR(2) with '+r'$\alpha_1$='+str(-ar4[1])+' and '+r'$\alpha_2$='+str(-ar4[2]))
axarr[1, 1].set_xlabel('lags')
plt.tight_layout()
plt.savefig('SFEpacfar2_py.png')
plt.show()
```

automatically created on 2019-08-02