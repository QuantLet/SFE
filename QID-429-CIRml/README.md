
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **CIRml** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : CIRml

Published in : Statistics of Financial Markets

Description : Defines the log-likelihood function of the CIR model used in SFECIRmle.

Keywords : cir, interest-rate, likelihood, cir, model, estimation

See also : 'SFECIRmle, SFEcapvola, SFEcapvplot, SFEcirpricing, SFEscap, SFEsimCIR2, SFEsimVasi,
SFEustb'

Author : Li Sun

Submitted : Tue, May 17 2016 by Christoph Schult

Input: 
- Params: a, b, sigma
- Model: yield on U.S. Treasury Bills, time step

Output : Value of the log-likelihood function in CIR model

Example : An example call is included in ExampleCallCIRml.m.

```


### MATLAB Code:
```matlab
function lnL = CIRml(Params, Model)
    % define input parameters
    lData = Model.Data;
    DataF = lData(1:end - 1);
    DataL = lData(2:end);
    a     = Params(1);
    b     = Params(2);
    sigma = Params(3);
    
    % compute relevant parameters for the log-likelihood function
    c   = 2 * a / (sigma^2 * (1 - exp(-a * Model.delta)));
    u   = c * exp(-a * Model.delta) * DataF;
    v   = c * DataL;
    q   = 2 * a * b / sigma^2 - 1;
    z   = 2 * sqrt(u .* v);
    bf  = besseli(q, z, 1);
    
    % compute log-likelihood
    lnL = -(Model.n - 1) * log(c) - sum(-u - v + 0.5 * q * log(v ./ u) + log(bf) + z);
end
```
