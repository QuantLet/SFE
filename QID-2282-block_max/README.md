[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **block_max** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: block_max

Published in: Statistics of Financial Markets

Description: 'Provides Value at Risk estimates computed with Block Maxima Model 
              with generalized extreme value.'

Keywords: 'VaR, backtesting, block-maxima, portfolio, returns'

See also: SFEclose, SFEportfolio, SFEtailGPareto_pp, SFEtailGPareto_qq, block_max, var_block_max_backtesting

Author: Barbara Choros, Awdesch Melzer and Piedad Castro

Submitted: Thu, December 1 2016 by Piedad Castro

Inputs: 
- y: vector of returns
- p: quantile for VaR estimation (e.g. 0.95)
- n: scalar, number of points included (e.g. 16)

Outputs: 
- var: Value-at-Risk
- tau: -1/kappa
- alpha: scale parameter
- beta: location parameter
- kappa: shape parameter

```

### MATLAB Code
```matlab

function [var,tau,alpha,beta,kappa] = block_max(y,n,p)
    T = length(y);
    k = floor(T/n);
    
    z = NaN(1,k-1);
    for j=1:k-1
        r    = y((j-1)*n+1:j*n);
        z(j) = max(r);
    end

    r     = y((k-1)*n+1:end);
    z(k)  = max(r);
    warning off
    
    parmhat = gevfit(z);
    kappa   = parmhat(1);
    tau     = -1/kappa;
    alpha   = parmhat(2);
    beta    = parmhat(3);
    pext    = p^n;
    var     = beta+alpha/kappa*((-log(1-pext))^(-kappa)-1);
end
```

automatically created on 2018-09-04