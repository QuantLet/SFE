
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEevt1** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEevt1

Published in : Statistics of Financial Markets

Description : 'Computes and displays extreme value distributions using the pdf (probability density
functions) with adjusted parameter alpha: Frechet, Gumbel and Weibull.'

Keywords : Frechet, GEV, Weibull, density, distribution, extreme-value, gumbel

See also : SFEevt2, SFEevt2, SFEevt3

Author : Zografia Anastasiadou

Submitted : Thu, June 04 2015 by Lukas Borke

Example : 'Gumbel distribution (solid line), Frechet distribution with parameter alpha=1/2 (dotted
line) and Weibull distribution with parameter alpha=-1/2 (dash-dot line).'

```

![Picture1](SFEevt1-1.png)


### R Code:
```r

rm(list = ls(all = TRUE))

# install and load packages
libraries = c("evd")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
n     = 100
sp    = 5
xpos  = sp * (1:n)/n
xneg  = -sp + xpos
x     = c(xneg, xpos)
alpha = 1/2

# Creating 3 types of densities via function "dgev" from package "evd"
gumb = cbind(x, dgev(x))
frec = cbind(x, dgev(x, 1, 0.5, alpha))
weib = cbind(x, dgev(x, -1, 0.5, -alpha))

# Plot
plot(weib, type = "l", col = "blue", lwd = 3, lty = 4, xlab = "X", ylab = "Y", main = "Extreme Value Densities")
lines(frec, type = "l", col = "red", lwd = 3, lty = 3)
lines(gumb, type = "l", col = "black", lwd = 3) 

```
