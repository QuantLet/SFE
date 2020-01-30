[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFESignal** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: SFESignal

Published in: Statistics of Financial Markets

Description: 'Simulates signal S_t = 2 * cos {2 * pi * (t / 50) + 0.6 * pi}, 
with epsilon_1 ~ N(0,1) and epsilon_2 ~ N(0,25) and plots the results'

Keywords: time-series, spectral, simulation, plot, spectral-decomposition

See also: SFEPer, SFEFreqFilt, SFESpecSim, SFESpecWN, SFETsDecomp

Author: Dedy D. Prastyo, Elisabeth Bommes, Caroline Kleist

Submitted: Mon, May 09 2016 by Christoph Schult

Output: Line plots for the simulated processes.

```

![Picture1](SignalSim.png)

### R Code
```r

# create simulated time series processes
t        = 1:500
S        = 2 * cos(2 * pi * t / 50 + .6 * pi)
epsilon1 = rnorm(500, 0, 1)
epsilon2 = 5 * epsilon1

# plot the simulated time series processes
par(mfrow = c(3, 1), mex = 1, lheight = 1.5)
plot.ts(S, xlab = "", col = "blue3", ylab = bquote(S[t]))
plot.ts(S + epsilon1, xlab = "", col = "blue3", ylab = bquote(S[t] +  εt1))
plot.ts(S + epsilon2, xlab = "Time t", col = "blue3", ylab = bquote(S[t] +  εt1))

```

automatically created on 2018-05-28