[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEacfar1** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: SFEacfar1

Published in: Statistics of Financial Markets

Description: 'Plots the autocorrelation function of an AR(1) (autoregressive) process.'

Keywords: acf, autocorrelation, autoregressive, discrete, graphical representation, linear, plot, process, simulation, stationary, stochastic, stochastic-process, time-series

See also: SFEacfar2, SFEacfma1, SFEacfma2, SFEpacfar2, SFEpacfma2, SFEfgnacf

Author: Joanna Tomanek, WK Härdle

Submitted: Fri, June 13 2014 by Felix Jung, 20190704 changes by WKH

Input: 
- a : alpha value
- lag : lag value

Example: 
- 1: a=0.9, lag=30
- 2: a=-0.9, lag=30

```

![Picture1](SFEacfar1_1-1.png)

![Picture2](SFEacfar1_2-1.png)

### R Code
```r


# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings, you might want to change these, check also the ACF if you enter e.g. a = -0.9
lag = 30  # lag value
a   = 0.9  # value of alpha_1

# Plot
plot(ARMAacf(ar = a, ma = numeric(0), lag.max = lag, pacf = FALSE), type = "h", 
    xlab = "lag", ylab = "acf")
title("Sample autocorrelation function (acf)")

```

automatically created on 2019-07-04