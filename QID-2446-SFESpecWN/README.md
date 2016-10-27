
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFESpecWN** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFESpecWN

Published in : Statistics of Financial Markets

Description : Computes the spectrum (frequency domain representation) of a white noise process

Keywords : time-series, spectral, simulation, plot, spectral-decomposition, white noise

See also : SFEPer, SFEFreqFilt, SFESpecSim, SFESpecSignal, SFETsDecomp

Author : Franziska Schulz, Elisabeth Bommes, Caroline Kleist

Submitted : Mon, May 09 2016 by Christoph Schult

Output : Spectrum of white noise process.

```

![Picture1](SpectrumWN.png)


### R Code:
```r
# set graphical parameters
par(mfrow = c(2, 1), mar = c(4, 4.5, 1, 3) + 0.1, mgp = c(2.5, 1, 0))

# create sample for a random variable from normal distribution
x = rnorm(250, 0, 0.6)

# plot sample
plot(x, type = "l", xlab = "time", ylab = expression(X[t]), lwd = 2, cex.lab = 2.1, cex.axis = 2)
abline(h = 0, lty = 3)
# plot the spectral density
spec.pgram(x, log = "no", xlab = "frequency", main = "", lwd = 2,
           cex.lab = 2.1, cex.axis = 2, sub = "", ylab = "Spectrum")
abline(h = 0.6^2, col = 2, lwd = 2)

```
