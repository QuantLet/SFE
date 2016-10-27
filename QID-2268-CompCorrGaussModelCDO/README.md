
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **CompCorrGaussModelCDO** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : CompCorrGaussModelCDO

Published in : Statistics of Financial Markets

Description : Computes the implied tranche correlation by a Gauss model for credit default options.

Keywords : CDO, Credit Risk, Equity tranche, Expected loss, default

See also : 'BaseCorrGaussModelCDO, ETL, SFEETLGaussTr1, SFEbaseCorr, SFEbaseCorr, SFEcompCorr,
SFEdefault, SFEmyfun'

Author : Awdesch Melzer

Submitted : Tue, May 17 2016 by Christoph Schult

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

Example : An example call is included in ExampleCallCompCorrGaussModelCDO.m.

```


### MATLAB Code:
```matlab
function y = CompCorrGaussModelCDO(a, R, defProb, UAP, LAP, DF, DayCount, trueSpread)
    C     = norminv(defProb, 0, 1);
    NinvK = norminv(UAP / (1 - R), 0, 1);
    A     = (C - sqrt(1 - a^2) * NinvK) / a;
    Sigma = [1 -a; -a 1];
    Mu    = [0 0];
    EL1   = mvncdf([C, -A], Mu, Sigma);
    EL2   = normcdf(A);
    
    if LAP == 0
        EL = EL1 / UAP * (1-R) + EL2;
    else
        NinvL    = norminv(LAP / (1 - R), 0, 1);
        B        = (C - sqrt(1 - a^2) * NinvL) / a;
        EL3      = mvncdf([C, -B], Mu, Sigma);
        EL4      = normcdf(B);
        UpperETL = EL1 + EL2 * UAP / (1 - R);
        LowerETL = EL3 + EL4 * LAP / (1 - R);
        EL       = (UpperETL - LowerETL) / (UAP - LAP) * (1 - R);
    end
    
    ProtectLeg = sum(diff([0; EL]) .* DF);
    PremiumLeg = sum((1 - EL) .* DF .* DayCount);
    spread     = ProtectLeg / PremiumLeg * 10000;
    if LAP == 0
        spread = (ProtectLeg - 0.05 * PremiumLeg) * 100;
    end
    y = abs(spread - trueSpread);
```
