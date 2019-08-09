[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **blsprice** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: blsprice

Published in: Statistics of Financial Markets

Description: Black-Scholes price function. It is used for calculation of put and call option prices in the Quantlet SFEbsprices.

Keywords: black-scholes, call, option, option-price, put

See also: SFEbsprices

Author: Maria Osipenko

Submitted: Thu, March 05 2015 by Lukas Borke
Submitted[Matlab]: Wed, December 21 2016 by Lily Medina

Input: S, K, r, sigma, tau - typical BS parameters

Output: Call option price or Put option price.

```

### MATLAB Code
```matlab

function [Call Put] = blsprice(S,K,r,sigma,tau)

if tau == 0 
    t = 1;
else
    t = 0;
end

y = (log(S/K)+(r-sigma^2/2)*tau)/(sigma*sqrt(tau)+t);
cdfn = normcdf(y+sigma*sqrt(tau));
    
if t ==0
    t_l = 1;
else
    t_l = 0;
end

Call = S*(cdfn*t_l+t)-K*exp(-r*tau)*normcdf(y)*t_l+t;
Put = K*exp(-r*tau)*(normcdf(-y))*t_l+t-S*(normcdf(-y-sigma*sqrt(tau))*t_l+t);

```

automatically created on 2018-05-28