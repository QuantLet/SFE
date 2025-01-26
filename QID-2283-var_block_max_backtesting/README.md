<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: var_block_max_backtesting

Published in: Statistics of Financial Markets

Description: tests back VaR estimate results "var" from block_max routine in a observation window h (e.g 250)

Keywords: VaR, GEV, backtesting, block-maxima, portfolio, returns

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
