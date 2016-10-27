
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEputcall** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEputcall

Published in : Statistics of Financial Markets

Description : 'Calculates the price of a European call option with the help of the
"Put-Call-Parity".'

Keywords : 'asset, black-scholes, call, put, european-option, financial, option, option-price,
put-call-parity'

Author : Alexander Ristig

Submitted : Tue, November 25 2014 by Felix Jung

Example : 'For given parameters [Strike Price, Spot Price, Interest Rate] like [800, 750, 0.1], and
[Remaining Time, Price of European Put, Value of all Earnings and Costs Related to Underlying] like
[0.8, 5.4, 2] the price of the European call option is calculated.'

```


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
K   = 800     # Strike Price
S   = 750     # Spot Price
r   = 0.1     # Interest Rate
tau = 0.8     # Remaining Time
P   = 5.4     # Price of European Put
D   = 2       # Value of all Earnings and Costs Related to Underlying

ValNames = c("Strike Price (K) =", "Spot Price (S) =", "Interest Rate (r) =", "Remaining Time (tau) =", 
    "Price of European Put (P) =", "Earnings and Costs Related to Underlying (D)=")
def = c(K, S, r, tau, P, D)
v = data.frame(def, row.names = ValNames)

K   = v[1, ]  # Alternatively K   = v['Strike Price (K) =',]
S   = v[2, ]  # Alternatively S   = v['Spot Price (S) =',]
r   = v[3, ]  # Alternatively r   = v['Interest Rate (r) =',]
tau = v[4, ]  # Alternatively tau = v['Remaining Time (tau) =',]
P   = v[5, ]  # Alternatively P   = v['Price of European Put (P) =',]
D   = v[6, ]  # Alternatively D   = v['Earnings and Costs Related to Underlying (D)=',]

C = P - K * exp((-1) * r * tau) + S - D

ifelse((P >= max(K * exp((-1) * r * tau) - S + D, 0)) & (P <= K), paste("Price of the European Call =", 
    round(C, digits = 2)), paste("SFEPutCall: General arbitrage inequality is not satisfied!"))
```
