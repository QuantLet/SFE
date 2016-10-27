
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEtimewn** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEtimewn

Published in : Statistics of Financial Markets

Description : Plots the time series of a Gaussian white noise.

Keywords : 'distribution, normal, normal-distribution, simulation, stochastic-process, stochastic,
process, white noise, gaussian, time-series, plot, graphical representation'

See also : SFEtimegarch, SFEtimedax

Author : Joanna Tomanek

Submitted : Fri, June 13 2014 by Felix Jung

```

![Picture1](SFEtimewn-1.png)


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

x = rnorm(1000)  # Generate random normal distributed variable
plot(x, main = "Gaussian White Noise", type = "l")  # Plot
```
