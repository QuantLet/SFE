<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: var_pot

Published in: Statistics of Financial Markets

Description: Provides Value at Risk estimates computed with Peaks Over

Keywords: POT, VaR, pareto, portfolio, returns, backtesting

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
