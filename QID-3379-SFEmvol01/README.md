
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEmvol01** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEmvol01

Published in : Statistics of Financial Markets

Description : 'Reads the date, DAX index values, stock prices of 20 largest companies at Frankfurt
Stock Exchange (FSE), FTSE 100 index values and stock prices of 20 largest companies at London
Stock Exchange (LSE) and computes descriptive statistics of the DAX and FTSE 100 daily return
processes from 1998 to 2007.'

Keywords : 'asset, data visualization, dax, descriptive-statistics, financial, ftse100, graphical
representation, index, plot, returns, stock-price, time-series, visualization'

See also : 'SFElshill, SFEmvol03, SFEmvol03, SFEtail, SFEtail, SFEtimeret, SFEtimeret,
SFEvolgarchest, SFEvolnonparest'

Author : Andrija Mihoci, Awdesch Melzer

Submitted : Thu, July 16 2015 by quantomas

Datafiles : FSE_LSE.dat

Output: 
- y: matrix of descriptive statistics

```


### R Code:
```r
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Read data for FSE and LSE
DS  = read.table("FSE_LSE.dat")
D   = DS[, 1]                           # date
S   = DS[, 2:43]                        # S(t)
s   = log(S)                            # log(S(t))
end = dim(s)[1]                         # last observation
r   = s[2:end, ] - s[1:(end - 1), ]     # r(t)
n   = dim(r)[1]                         # sample size
t   = 1:n                               # time index, t

# Descriptive statistics for the DAX and FTSE 100 daily return processes
Y = rbind(cbind(min(r[, 1]), max(r[, 1]), mean(r[, 1]), median(r[, 1]), sd(r[, 1]/sqrt(n))), 
    cbind(min(r[, 22]), max(r[, 22]), mean(r[, 22]), median(r[, 22]), sd(r[, 22]/sqrt(n))))
colnames(Y) = c("Min", "Max", "Mean", "Median", "Std.Error")
rownames(Y) = c("DAX", "FTSE 100")
Y
```
