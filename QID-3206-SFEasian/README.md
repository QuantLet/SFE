
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEasian** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEasian

Published in : Statistics of Financial Markets

Description : 'Computes Asian call option prices (asian option) using a binomial tree for assets
without dividends.'

Keywords : 'asset, binomial, binomial-tree, black-scholes, call, discrete, european-option,
exotic-option, financial, option, option-price, price, simulation, stock-price'

See also : SFEcompound, SFElookback

Author : Awdesch Melzer

Submitted : Wed, June 10 2015 by Lukas Borke

```


### R Code:
```r

rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
S.ave = 245             # Exercise price compound
St1   = 230             # Price of underlying asset
r     = 0.04545         # dom. interest rate
sigma = 0.25            # volatility per year
T1    = 1               # time to maturity option
b     = r               # cost of carry out
dt    = 0.2             # Interval of step
n     = floor(T1/dt)    # number of steps

# parameters from equation (7.2)
u  = exp(sigma * sqrt(dt))   # upward proportion: approx 1.1183  
d  = 1/u                     # downward proportion approx. 0.89422
p  = 0.5 + 0.5 * (b - 0.5 * sigma^2) * sqrt(dt)/sigma  # Pseudo probability of up movement approx 0.5127  
un = matrix(0, n + 1, 1)
un[n + 1, 1] = 1
dm = t(un)                   # down movement
um = dm                      # up movement

j = 1
while (j < n + 1) {
    # Down movement dynamics
    d1 = c(matrix(0, 1, n - j), (matrix(1, 1, j + 1) * d)^(seq(0:j) - 1))
    dm = rbind(dm, d1)
    # Up movement dynamics
    u1 = c(matrix(0, 1, n - j), matrix(1, 1, j + 1) * u^seq(j, 0, -1))
    um = rbind(um, u1)
    j = j + 1
}
um = t(um)
dm = t(dm)

# Stock price development
s = St1 * um * dm
colnames(s) = c()

print("Stock price development")
print(s)

# Rearrangement
s = s[ncol(s):1, ]
opt = matrix(0, ncol(s), ncol(s))
# Determine option values from prices
opt[, n + 1] = apply(cbind(as.matrix(s[, ncol(s)] - S.ave), matrix(0, nrow(as.matrix(s[,ncol(s)] - S.ave)), 1)), 1, max)

for (j in n:1) {
    l = 1:j
    # Probable option values discounted back one time step
    discopt = ((1 - p) * opt[l, j + 1] + p * opt[l + 1, j + 1]) * exp(-b * dt)
    # Option value is max of current stock price - strike or discopt
    opt[, j] = c(discopt, matrix(0, n + 1 - j, 1))
}

Asian_Price = opt[ncol(opt):1, ]

# final output
print("Option price development")
print(Asian_Price)

print("The price of the European call option at time t_0 is")
print(Asian_Price[n + 1, 1]) 

```
