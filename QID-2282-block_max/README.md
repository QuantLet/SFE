<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: block_max

Published in: Statistics of Financial Markets

Description: Provides Value at Risk estimates computed with Block Maxima Model

Keywords: VaR, backtesting, block-maxima, portfolio, returns

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
