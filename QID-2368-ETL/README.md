
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **ETL** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet : ETL

Published in : Statistics of Financial Markets

Description : 'Claculates expected loss of the equity tranche using the one factor Gaussian model
with one-year default probability computed from the iTraxx index Series 8 with 5 years maturity on
20071022. Package pracma for numerical integration is required.'

Keywords : 'Expected loss, default, Credit Risk, Equity tranche, multivariate normal, Gauss
Kronrod, numerical integration, integration, normal, gaussian, asset, financial, plot, graphical
representation'

See also : 'SFEbaseCorr, SFEcompCorr, ETL, lowerTrLossGauss, BaseCorrGaussModelCDO, SFEdefault,
SFEmyfun, CompCorrGaussModelCDO, SFEPortfolioLossDensity, SFEgaussCop, SFEETLGaussTr1'

Author : Awdesch Melzer

Submitted : Wed, April 23 2014 by Awdesch Melzer

Submitted[Matlab] : Tue, May 17 2016 by Christoph Schult

Input: 
- a: scalar, point from interval for optimization algorithm
- R: scalar, recovery rate of security
- defProb: scalar, default probability
- UAP: scalar, upper attachment point of CDO tranche

Output: 
- EL: expected loss

Example : An example call for R is included at the end of ETL.R.

Example[Matlab] : An example call for Matlab is included in ExampleCallETL.m.

```


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("pracma")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

bvnIntegrand = function(theta, b1, b2) {
    # Bivariate normal distribution | SUBROUNTINE of mvncdf() Integrand is 
    # exp(-(b1^2 + b2^2 - 2*b1*b2*sin(theta))/(2*cos(theta)^2) )
    sintheta = sin(theta)
    cossqtheta = cos(theta)^2  # always positive
    integrand = exp(-((b1 * sintheta - b2)^2/cossqtheta + b1^2)/2)
    return(integrand)
}

mvncdf = function(b, mu, sigma) {
    # MVNCDF Multivariate normal cumulative distribution function.  P = MVNCDF(B,
    # MU, SIGMA) returns the joint cumulative probability using numerical
    # integration. B is a vector of values, MU is the mean parameter vector, and
    # SIGMA is the covariance matrix.
    n = NROW(b)
    b = as.matrix(b)
    if (NCOL(b) != length(mu)) {
        stop("The first two inputs must be vectors of the same length.")
    }
    # Rho = sigma/(sqrt(diag(sigma))%*%t(sqrt(diag(sigma))))
    rho = sigma[2]
    if (rho > 0) {
        p1 = pnorm(apply(b, 2, min))
        p1[any(is.nan(b), 2)] = NaN
    } else {
        p1 = pnorm(b[, 1]) - pnorm(-b[, 2])
        p1[p1 < 0] = 0  # max would drop NaNs
    }
    if (abs(rho) < 1) {
        loLimit = asin(rho)
        hiLimit = sign(rho) * pi/2
        p2 = numeric()
        for (i in 1:n) {
            b1 = b[i, 1]
            b2 = b[i, 2]
            p2[i] = integral(function(x) bvnIntegrand(x, b1, b2), xmin = loLimit, 
                xmax = hiLimit, method = "Kronrod", reltol = 1e-10)
        }
    } else {
        p2 = rep(0, length(p1))
    }
    p = p1 - p2/(2 * pi)
    return(p)
    
}

ETL = function(a, R, defProb, UAP) {
    C = qnorm(defProb, 0, 1)
    NinvK = qnorm(UAP/(1 - R), 0, 1)
    A = (C - sqrt(1 - a^2) * NinvK)/a
    Sigma = matrix(c(1, -a, -a, 1), 2, 2)  # (1 -a)
    # (-a 1)
    Mu = c(0, 0)
    EL1 = mvncdf(b = cbind(C, -A), mu = Mu, sigma = Sigma)  # mvnormal
    EL2 = pnorm(A)
    EL = EL1/UAP * (1 - R) + EL2
    return(EL)
}

# Main computation
index = 37.2416
recoveryR = 0.4  # Recovery rate
UAP = c(0.03, 0.06, 0.09, 0.12, 0.22)  # Upper attachment points
lam = index/10000/(1 - recoveryR)
tr = 1
defProb = 1 - exp(-lam)  # Default probability
rho = seq(0.01, 0.99, by = 0.01)  # compound correlation
a = sqrt(rho)  # square-root of compound correlation
etl = numeric()
for (i in 1:length(a)) {
    etl[i] = ETL(a[i], recoveryR, defProb, UAP[tr])
}
etl

```

### MATLAB Code:
```matlab
function EL = ETL(a, R, defProb, UAP)
    C     = norminv(defProb, 0, 1);
    NinvK = norminv(UAP / (1 - R), 0, 1);
    A     = (C - sqrt(1 - a^2) * NinvK) / a;
    Sigma = [1 -a; -a 1];
    Mu    = [0 0];
    EL1   = mvncdf([C, -A], Mu, Sigma);
    EL2   = normcdf(A);
    EL    = EL1 / UAP * (1 - R) + EL2;
end
```
