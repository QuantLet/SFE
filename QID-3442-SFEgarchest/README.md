
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEgarchest** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEgarchest

Published in : Statistics of Financial Markets

Description : 'Reads the date, DAX index values, stock prices of 20 largest companies at Frankfurt
Stock Exchange (FSE), FTSE 100 index values and stock prices of 20 largest companies at London
Stock Exchange (LSE) and estimates various GARCH models for the DAX and FTSE 100 daily return
processes from 1998 to 2007.'

Keywords : 'asset, data visualization, dax, descriptive-statistics, estimation, financial, ftse100,
garch, graphical representation, index, model, parameter, plot, returns, stock-price, time-series'

See also : SFEvolgarchest

Author : Andrija Mihoci, Awdesch Melzer

Submitted : Fri, July 24 2015 by quantomas

Datafiles : FSE_LSE.dat

Output: 
- P: matrix of estimated coefficients
- E: matrix of standard errors
- T: matrix of t-statistics of estimated coefficients
- Pvalues: matrix of Pvalues

```


### R Code:
```r
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("tseries", "fGarch", "rugarch")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Read data for FSE and LSE
DS  = read.table("FSE_LSE.dat")
D   = DS[, 1]       # date
S   = DS[, 2:43]    # S(t)
s   = log(S)
end = length(D)     # log(S(t))
r   = s[2:end, ] - s[1:(end - 1), ]  # r(t)
n   = length(r)     # sample size
t   = c(1:n)        # time index, t

# Parameter estimation of various GARCH models

# (1) AR(1)-GARCH(1,1)

DAX.AR1GARCH11  = garchFit(~arma(1, 0) + garch(1, 1), r[, 1], trace = T)
FTSE.AR1GARCH11 = garchFit(~arma(1, 0) + garch(1, 1), r[, 22], trace = T)

# (2) AR(1)-TGARCH(1,1)

DAX.AR1TGARCH11  = garchFit(~arma(1, 0) + aparch(1, 1), data = r[, 1], delta = 2, 
    include.delta = FALSE, leverage = TRUE)
FTSE.AR1TGARCH11 = garchFit(~arma(1, 0) + aparch(1, 1), data = r[, 22], delta = 2, 
    include.delta = FALSE, leverage = TRUE)

# (3) AR(1)-EGARCH(1,1)

ctrl = list(RHO = 1, DELTA = 1e-08, MAJIT = 100, MINIT = 650, TOL = 1e-06)
spec = ugarchspec(variance.model = list(model = "eGARCH", garchOrder = c(1, 1)), 
    mean.model = list(armaOrder = c(1, 0), include.mean = TRUE), distribution.model = "std")
DAX.AR1EGARCH11 = ugarchfit(data = r[, 1], spec = spec, solver = "solnp", solver.control = ctrl)
FTSE.AR1EGARCH11 = ugarchfit(data = r[, 22], spec = spec, solver = "solnp", solver.control = ctrl)

# Summary of parameter estimates (P), standard errors (E), t-statistics (T) and p-values (Pvalues)

P = matrix(0, 7, 6)
P[, 1] = c(DAX.AR1GARCH11@fit$matcoef[, 1], 0, 0)
P[, 2] = c(FTSE.AR1GARCH11@fit$matcoef[, 1], 0, 0)
P[, 3] = c(DAX.AR1TGARCH11@fit$matcoef[, 1], 0)
P[, 4] = c(FTSE.AR1TGARCH11@fit$matcoef[, 1], 0)
P[, 5] = c(DAX.AR1EGARCH11@fit$matcoef[, 1])
P[, 6] = c(FTSE.AR1EGARCH11@fit$matcoef[, 1])

E = matrix(0, 7, 6)
E[, 1] = c(DAX.AR1GARCH11@fit$matcoef[, 2], 0, 0)
E[, 2] = c(FTSE.AR1GARCH11@fit$matcoef[, 2], 0, 0)
E[, 3] = c(DAX.AR1TGARCH11@fit$matcoef[, 2], 0)
E[, 4] = c(FTSE.AR1TGARCH11@fit$matcoef[, 2], 0)
E[, 5] = c(DAX.AR1EGARCH11@fit$matcoef[, 2])
E[, 6] = c(FTSE.AR1EGARCH11@fit$matcoef[, 2])

T = P/E

Pvalues = matrix(0, 7, 6)
Pvalues[, 1] = c(DAX.AR1GARCH11@fit$matcoef[, 4], 0, 0)
Pvalues[, 2] = c(FTSE.AR1GARCH11@fit$matcoef[, 4], 0, 0)
Pvalues[, 3] = c(DAX.AR1TGARCH11@fit$matcoef[, 4], 0)
Pvalues[, 4] = c(FTSE.AR1TGARCH11@fit$matcoef[, 4], 0)
Pvalues[, 5] = c(DAX.AR1EGARCH11@fit$matcoef[, 4])
Pvalues[, 6] = c(FTSE.AR1EGARCH11@fit$matcoef[, 4])

# Output
print("Parameter estimates")
print(P)

print("Standard errors")
print(E)

print("t-statistics")
print(T)

print("p-values")
print(Pvalues) 
```
