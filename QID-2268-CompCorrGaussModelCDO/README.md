<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: CompCorrGaussModelCDO

Published in: Statistics of Financial Markets

Description: Computes the implied tranche correlation by a Gauss model for credit default options.

Keywords: CDO, Credit Risk, Equity tranche, Expected loss, default

See also: BaseCorrGaussModelCDO, ETL, SFEETLGaussTr1, SFEbaseCorr, SFEbaseCorr, SFEcompCorr, SFEdefault, SFEmyfun

Author: Awdesch Melzer

Submitted: Tue, May 17 2016 by Christoph Schult

Input: 
- a: scalar, point from interval for optimization algorithm
- R: scalar, recovery rate of security
- defProb: scalar, default probability
- UAP: scalar, upper attachment point of CDO tranche
- LAP: scalar, lower attachment point of CDO tranche
- DF: scalar, discount factor
- DayCount: vector, weights
- trueSpread: scalar, true spread

Output: 
- y: implied tranche correlation

Example: An example call is included in ExampleCallCompCorrGaussModelCDO.m.

```
