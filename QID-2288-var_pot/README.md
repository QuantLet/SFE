[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **var_pot** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: var_pot

Published in: Statistics of Financial Markets

Description: 'Provides Value at Risk estimates computed with Peaks Over 
              Treshold model with generalized Pareto distribution.'

Keywords: 'POT, VaR, pareto, portfolio, returns, backtesting'

See also: SFEclose, SFEportfolio, SFEtailGPareto_pp, SFEtailGPareto_qq, SFEvar_pot_backtesting, SFEvar_pot_params, block_max, var_block_max_backtesting, var_pot_backtesting

Author: Barbara Choros, Awdesch Melzer

Submitted: Thu, November 24 2016 by Piedad Castro

Inputs: 
- y: vector of returns
- p: quantile for at which Value at Risk should be estimated
- h: size of the window
- q: scalar, e.g. 0.1

Outputs: 
- ksi, beta: parameters from POT model         
- var: VaR estimates at 0.95 quantile


```

### MATLAB Code
```matlab

function [var,ksi,beta,u] = var_pot(y,h,p,q)
    N  = floor(h*q);
    ys = sort(y,'descend');
    u  = ys(N+1);
    z  = y(y>u)-u;
    
    params = gpfit(z);
    warning off

    ksi  = params(1);
    beta = params(2);
    var  = u + beta/ksi*((h/N*(1-p))^(-ksi)-1);
end

```

automatically created on 2018-09-04