
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="887" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEVasiml** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEVasiml

Published in : Statistics of Financial Markets

Description : 'SFEVasiml shows the estimation of Vasicek model using 2600 observations of the
yields of the US 3 month treasury bill from 19980102 to 20080522.'

Keywords : interest-rate, likelihood, vasicek, yield, estimation, model

See also : 'SFEcap, SFEcapvola, SFEcir, SFEcapvplot, SFECIRmle, SFEcirpricing, SFEcomCIR,
SFEsimCIR, SFEsimVasi, SFEustb'

Author : Li Sun, Awdesch Melzer

Author[Matlab] : Li Sun

Submitted : Thu, September 27 2012 by Dedy Dwi Prastyo

Submitted[Matlab] : Mon, May 02 2016 by Meng Jou Lu

Datafiles : yield_US3month9808.txt

Input[Matlab] : The yields of the US 3 month treasury bill from 1998 to 2008

Output[Matlab] : MLE results of the Vasicek model

Code problems[R] : 'Error in -yhat$fval : invalid argument to unary operator'

Code problems[Matlab] : 'Error: File: Vasimle.m Line: 11 Column: 22 Unexpected MATLAB operator.'

```


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("neldermead")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

Vasimle = function(Params) {
    end = length(x)
    s1 = x[2:end]
    s2 = x[1:(end - 1)]
    delta = 1/252
    a = Params[1]
    b = Params[2]
    sigma = Params[3]
    n = length(s1)
    v = (sigma^2 * (1 - exp(-2 * a * delta)))/(2 * a)
    f = s1 - s2 * exp(-a * delta) - b * (1 - exp(-a * delta))
    lnL = (n/2) * log(2 * pi) + n * log(sqrt(v)) + sum((f/sqrt(v))^2)/2
    return(lnL)
}

# load data
x = read.table("yield_US3month9808.txt")
x = x[1:2600, 1]/100

n = length(x) - 1
end = length(x)
delt = 1/252

# Least square innitial estimation
X1 = sum(x[1:(end - 1)])
X2 = sum(x[2:end])
X3 = sum(x[1:(end - 1)]^2)
X4 = sum(x[1:(end - 1)] * x[2:end])
X5 = sum(x[2:end]^2)

c = (n * X4 - X1 * X2)/(n * X3 - X1^2)
d = (X2 - c * X1)/n
sd = sqrt((n * X5 - X2^2 - c * (n * X4 - X1 * X2))/n/(n - 2))

lambda = -log(c)/delt
mu = d/(1 - c)
sigma = sd * sqrt(-2 * log(c)/delt/(1 - c^2))

InitialParams = c(lambda, mu, sigma)

# optimize the Likelihood function
options = optimset(method = "fminsearch", MaxIter = 300, MaxFunEvals = 300, Display = "iter", 
    TolFun = c(1e-04), TolX = c(1e-04))

yhat = fminsearch(Vasimle, x0 = InitialParams, options)

Results = NULL
Results$Params = yhat$x
Results$Fval = -yhat$fval/n
Results$Exitflag = yhat$Exitflag

a = yhat$x[1]
b = yhat$x[2]
sigma = yhat$x[3]

# Estimates
rbind(a, b, sigma)
print(paste("log-likelihood = ", Results$Fval))

```

### MATLAB Code:
```matlab


clear all
close all
clc

load yield_US3month9808.txt;

X             = yield_US3month9808(1:2600)/100;
n             = length(X)-1;
delt          = 1/252;

% Least square innitial estimation
X1            = sum( X(1:end-1) );
X2            = sum( X(2:end) );
X3            = sum( X(1:end-1).^2 );
X4            = sum( X(1:end-1).*X(2:end) );
X5            = sum( X(2:end).^2 );

c             = ( n*X4 - X1*X2 ) / ( n*X3 -X1^2 );
d             = ( X2 - c*X1 ) / n;
sd            = sqrt( (n*X5 - X2^2 - c*(n*X4 - X1*X2) )/n/(n-2) );

lambda        = -log(c)/delt;
mu            = d/(1-c);
sigma         = sd * sqrt( -2*log(c)/delt/(1-c^2) ) ;
InitialParams = [lambda mu sigma];

%optimize the Likelihood function
options                  = optimset('LargeScale', 'off', 'MaxIter', 300, 'MaxFunEvals', 300, 'Display', 'iter', 'TolFun', 1e-4, 'TolX', 1e-4, 'TolCon', 1e-4);
[Params, Fval, Exitflag] = fminsearch(@(Params) Vasimle(Params,X), InitialParams,options);

Results.Params           = Params;
Results.Fval             = -Fval/n;
Results.Exitflag         = Exitflag;

fprintf('\n a = %+3.6f\n b    = %+3.6f\n sigma = %+3.6f\n', Params(1), Params(2), Params(3));
fprintf(' log-likelihood = %+3.6f\n', -Fval/n);
```
