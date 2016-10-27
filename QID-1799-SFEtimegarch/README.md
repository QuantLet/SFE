
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="884" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFETimegarch** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFETimegarch

Published in : Statistics of Financial Markets

Description : Plots the time series of a GARCH(1,1) process.

Keywords : 'simulation, stochastic-process, process, time-series, plot, graphical representation,
estimation, garch, autoregressive, process, stochastic, stochastic-process, volatility'

See also : SFEtimewn, SFEtimedax

Author : Joanna Tomanek

Submitted : Tue, June 17 2014 by Thijs Benschop

```

![Picture1](SFETimegarch-1.png)


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fGarch")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

time = seq(1, 1000, 1)
x = garchSim(garchSpec(model = list(omega = 0.1, alpha = 0.15, beta = 0.8), rseed = 100), 
    n = 1000)
plot(time, x, type = "l", ylab = "Y", xlab = "Time", main = "Simulated GARCH(1,1) Process")

```
