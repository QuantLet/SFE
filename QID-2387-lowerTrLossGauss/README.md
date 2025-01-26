<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: lowerTrLossGauss

Published in: Statistics of Financial Markets

Description: Computes the lower expected tranche loss.

Keywords: CDO, Credit Risk, Equity tranche, Expected loss, Gauss Kronrod, Gaussian Model, bivariate, default, integration, lower tranche loss, multivariate normal, normal, numerical integration, gaussian, asset, financial, plot, graphical representation

See also: SFEbaseCorr, CompCorrGaussModelCDO, SFEPortfolioLossDensity, SFEcompCorr, SFEgaussCop, BaseCorrGaussModelCDO, SFEETLGaussTr1, ETL

Author: Awdesch Melzer

Submitted: Wed, April 23 2014 by Awdesch Melzer

Input: 
- sqrtBCbef (scalar) : square-root of base correlation
- defProb (scalar) : default probability
- LAP (scalar) : Lower attachment points
- R (scalar) : recovery rate

Output: 
- LowerETL (scalar) : Lower expected tranche loss

Example: LowerETL=lowerTrLossGauss(sqrtBCbef,R,defProb,LAP)

```
