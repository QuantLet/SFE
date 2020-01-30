[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEacfma1** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEacfma1 

Published in: Statistics of Financial Markets

Description: Plots the autocorrelation function of an MA(1) (moving average) process.

Keywords: acf, autocorrelation, discrete, graphical representation, linear, moving-average, plot, process, simulation, stationary, stochastic, stochastic-process, time-series

See also: SFEacfar1, SFEacfar2, SFEacfma2, SFElikma1, SFEpacfar2, SFEpacfma2, SFEplotma1

Author: Joanna Tomanek
Author[Python]: Justin Hellermann

Submitted: Fri, July 24 2015 by quantomas
Submitted[Python]: Thu, August 01 2019 by Justin Hellermann

Input:
- lag : lag value
- b : beta_1

Example:
- 1: b = 0.5, lag = 30.
- 2: b = -0.5, lag = 30.

```

![Picture1](SFEacfma1_1-1.png)

![Picture2](SFEacfma1_2-1.png)

![Picture3](SFEacfma1_py.png)

### R Code
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = "30"      # lag value
b   = "0.5"     # value of beta_1

# Input beta_1
message = "      input beta"
default = b
b       = winDialogString(message, default)
b       = type.convert(b, na.strings = "NA", as.is = FALSE, dec = ".")

# Input lag value
message = "      input lag"
default = lag
lag     = winDialogString(message, default)
lag     = type.convert(lag, na.strings = "NA", as.is = FALSE, dec = ".")

# Plot
plot(ARMAacf(ar = numeric(0), ma = b, lag.max = lag, pacf = FALSE), type = "h", xlab = "lag", 
    ylab = "acf")
title("Sample autocorrelation function (acf)") 

```

automatically created on 2019-08-01

### PYTHON Code
```python

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


```

automatically created on 2019-08-01