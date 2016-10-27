
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEdefaproba** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEdefaproba

Published in : Statistics of Financial Markets

Description : 'Plots the default probability for KMV model as a function of the state of the
economy for 3 different states of the economy: bad (y=-3), typical (y=0) and good(y=3).'

Keywords : 'default, economy, factor-model, financial, graphical representation,
one-factor-gaussian-model, plot, probability'

Author : Song Song, Yafei Xu

Submitted : Sat, July 18 2015 by quantomas

```

![Picture1](SFEdefaproba-1.png)


### R Code:
```r
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Main computation
x  = seq(0, 1, by = 0.01)
y1 = pnorm((qnorm(x) - sqrt(0.2) * (-3))/(sqrt(0.8)))
y2 = pnorm((qnorm(x) - sqrt(0.2) * (0))/(sqrt(0.8)))
y3 = pnorm((qnorm(x) - sqrt(0.2) * (3))/(sqrt(0.8)))

# Plot
plot(x, y1, col = "blue", type = "l", xlab = "Probability Default", ylab = "p(y)", lwd = 2.5)
lines(x, y2, col = "black", lty = 2, lwd = 2.5)
lines(x, y3, col = "red", lty = 4, lwd = 2.5)
legend(0.8, 0.2, c("y=-3", "y=0", "y=3"), col = c("blue", "black", "red"), lty = c(1, 2, 4)) 
```
