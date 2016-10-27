
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEtimedax** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEtimedax

Published in : Statistics of Financial Markets

Description : Plots the time series of daily DAFOX returns with a window from 1993 to 1996.

Keywords : 'dafox, data visualization, dax, financial, graphical representation, log-returns, plot,
returns, time-series, visualization'

Author : Joanna Tomanek

Submitted : Wed, July 22 2015 by quantomas

Datafiles : dafox.dat

```

![Picture1](SFEtimedax-1.png)


### R Code:
```r
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("tfplot")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Main computation
datax = read.table("dafox.dat")
datax = as.matrix(datax)
n     = nrow(datax)
tx    = datax[(n - 1000):n, 2]
tx    = as.matrix(tx)

# Log returns
x = diff(log(tx))  

# Plot
name        = "DAFOX 1993-96"
origyear    = 1993
origperiod  = 1
periodicity = 300
tfplot(ts(x, start = c(1993, 1), frequency = periodicity), start = c(origyear, origperiod), 
    title = name)  

```
