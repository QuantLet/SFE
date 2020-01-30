[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **var_block_max_backtesting** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: var_block_max_backtesting

Published in: Statistics of Financial Markets

Description: 'tests back VaR estimate results "var" from block_max routine in a observation window h (e.g 250) 
              for the portfolio "x" and gives VaR estimates and outliers.'

Keywords: 'VaR, GEV, backtesting, block-maxima, portfolio, returns'

See also: SFEclose, SFEportfolio, SFEtailGPareto_pp, SFEtailGPareto_qq, SFEvar_block_max_backtesting, SFEvar_block_max_params, SFEvar_pot_backtesting, SFEvar_pot_params, block_max, var_pot, var_pot_backtesting

Author: Barbara Choros, Awdesch Melzer and Piedad Castro

Submitted: Thu, December 1 2016 by Piedad Castro

Inputs: 
- x: vector of portfolio
- v: vector of VaR estimates from block_max routine
- h: integer, observation window (e.g. 250)

Outputs: 
- v: Value-at-Risk
- K: dummy vector (outlier == 1)
- outlier: vector of outliers
- yplus: furthest point in portfolio returns
- p: exceedances ratio

```

### MATLAB Code
```matlab

function [v,K,outlier,yplus,p]=var_block_max_backtesting(x,v,h)
    v         = -v;
    L         = x;
    T         = length(L);
    outlier   = NaN(1,T-h);
    exceedVaR = NaN(1,T-h);
    
    for j=1:T-h
        exceedVaR(j) = (L(j+h)<v(j));
        if exceedVaR(j)>0 
            outlier(j) = L(j+h);
        end;
    end;
    p       = sum(exceedVaR)/(T-h);
    K       = find(isfinite(outlier));
    yplus   = K.*0+min(L(h+1:end))-2;
    outlier = outlier(K);
end
  
```

automatically created on 2018-09-04