
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEpacfar2** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEpacfar2

Published in : Statistics of Financial Markets

Description : Plots the partial autocorrelation function of an AR(2) (autoregressive) process.

Keywords : 'acf, partial, PACF, autocorrelation, autoregressive, discrete, graphical
representation, linear, plot, process, simulation, stationary, stochastic, stochastic-process,
time-series'

See also : SFEacfar1, SFEacfar2, SFEacfma1, SFEacfma2, SFEpacfma2, SFEfgnacf

Author : Joanna Tomanek

Submitted : Fri, June 13 2014 by Felix Jung

Input: 
- lag: lag value
- a1: alpha_1
- a2: alpha_2

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


### R Code:
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
