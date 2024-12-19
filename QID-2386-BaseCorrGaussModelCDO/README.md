<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: BaseCorrGaussModelCDO

Published in: Statistics of Financial Markets

Description: 'Computes the base tranche correlation for a Gaussian credit default model.'

Keywords: CDO, Credit Risk, Equity tranche, Expected loss, Gauss Kronrod, Gaussian Model, bivariate, default, integration, multivariate normal, normal, numerical integration, correlation, gaussian, asset, financial, plot, graphical representation

See also: SFEbaseCorr, CompCorrGaussModelCDO, SFEPortfolioLossDensity, SFEcompCorr, SFEgaussCop, lowerTrLossGauss, SFEETLGaussTr1, ETL

Author: Awdesch Melzer

Author[Matlab]: Barbara Choros

Submitted: Wed, April 23 2014 by Awdesch Melzer

Submitted[Matlab]: Tue, May 17 2016 by Christoph Schult

Input: 

- a (scalar): point from interval for optimization algorithm

- R (scalar): recovery rate of security

- defProb (scalar): default probability

- UAP (scalar): upper attachment point of CDO tranche

- LAP (scalar): 'lower attachment point of CDO tranche (also: detachment point)'

- DF (scalar): discount factor

- DayCount (vector): weights

- trueSpread (scalar): true spread

- LowerTloss: Lower expecter tranche losses from lowerTrLossGauss routine

Output: 

- y: Base tranche correlation

Example: 'An example call is included in BaseCorrGaussModelCDO.R.'

Example[Matlab]: 'An example call for Matlab is included in ExampleCallBaseCorrGaussModelCDO.m'

```
