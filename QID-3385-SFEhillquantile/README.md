[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEhillquantile** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: SFEhillquantile

Published in: Statistics of Financial Markets

Description: Estimates the Hill-quantile value given a Hill-estimation of gamma.

Keywords: VaR, distribution, estimation, extreme-value, forecast, generalized-pareto-model,hill-estimator, pareto, quantile, risk, standard

See also: hillgp1 

Author: Joanna Tomanek, Awdesch Melzer

Submitted: Thu, July 16 2015 by quantomas
Submitted[Matlab]: Thu, December 1 2016 by Lily Medina

Usages: hillgp1

Input: q-scalar, quantile as 0.01; k-integer, excess, as 10

Output: Hill-quantile estimate

```

### R Code
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fExtremes")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Main computation
x = rgpd(100, xi = 0.1)  # generate a generalized pareto distributed variables 
x = sort(x)
n = length(x)
q = "0.01"
k = "10"

message = "      Quantile"
default = q
q = winDialogString(message, default)
q = type.convert(q, na.strings = "NA", as.is = FALSE, dec = ".")

message = "      Excess"
default = k
k = winDialogString(message, default)
k = type.convert(k, na.strings = "NA", as.is = FALSE, dec = ".")

if (k < 8 && k > (n - 1)) warning("SFEhillquantile: excess should be greater than 8 and less than the number of elements.", 
                                  call. = FALSE)
if (q < 0 && q > 1) warning("SFEhillquantile: please give a rational quantile value.", 
                            call. = FALSE)

rest = gpdFit(x, nextremes = k, type = "mle")				# ML-estimation of gamma 
rest = rest@parameter

# the Hill-quantile value
(xest = x[k] + x[k] * (((n/k) * (1 - q))^(-rest$u) - 1))	# Hill-quantil estimation
```

automatically created on 2018-05-28

### MATLAB Code
```matlab

%% clear all variables
clear all
close all
clc

disp('Please input Quantile q, and Excess k as [0.01, 10]');
disp(' ') ;
para = input('[q, k]=');
while length(para) < 2
  disp('Not enough input arguments. Please input in 1*2 vector form like [0.01, 10]');
  disp(' ') ;
  para = input('[q, k]=');
end
q = para(1);              % quantile
k = para(2);              % excess

if(k < 1 && k> n)
    error('SFEhillquantile: excess should be greater than 0 and less or equal than the number of elements.')
end
if(q < 0 && q> 1)
    error('SFEhillquantile: please give a rational quantile value.')
end

x    = gprnd(0.1,1,0,100,1); % generalized pareto random numbers
x    = sort(x);
n    = size(x,1);
rest = hillgp1(x,k);  % ML-estimation of gamma 
xest = x(k)+x(k)*(((n/k)*(1-q))^(-rest)-1) % Hill-quantil estimation

```

automatically created on 2018-05-28