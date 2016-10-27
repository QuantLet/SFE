
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **Vasimle** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : Vasimle

Published in : Statistics of Financial Markets

Description : Log-likelihood function used in SFEVasiml.

Keywords : interest-rate, likelihood, function, model, estimation

See also : SFEVasiml, VaR

Author[Matlab] : Li Sun

Submitted[Matlab] : Mon, May 03 2016 by Meng Jou Lu

Input[Matlab]: 
- Params: a, b, sigma
- X: yields of the US 3 month treasury bill

Output[Matlab] : Value of the log-likelihood function in Vasicek model.

```


### MATLAB Code:
```matlab

function lnL = Vasimle(Params, X)
    s1    = X(2:end);
    s2    = X(1:end - 1);
    delta = 1 / 252;
    a     = Params(1);
    b     = Params(2);
    sigma = Params(3);
    n     = length(s1);
    v     = (sigma^2 * (1 - exp(-2 * a * delta))) / (2 * a);
    f     = s1 - s2. * exp(-a * delta) - b * (1 - exp(-a * delta));
    lnL   = (n / 2) * log(2 * pi) + n * log(sqrt(v))+sum((f / sqrt(v)).^2) / 2;
end
```
