
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEVolaCov** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEVolaCov

Published in : Statistics of Financial Markets

Description : Calculates the covariance matrix of the first differences of the VDAX data.

Keywords : 'covariance, covariance-matrix, dax, financial, implied-volatility, index, time-series,
vdax, volatility'

See also : SFEVolSurfPlot, SFEVolSurfPlot, SFEVolaPCA, SFEVolaPCA, SFEVolaTermStructure

Author : Joanna Tomanek

Author[Matlab] : Wolfgang K. Härdle

Submitted : Fri, June 12 2015 by Lukas Borke

Submitted[Matlab] : Fri, February 19 2010 by Lasse Groth

Datafiles : implvola.dat

```


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# read data
x = read.table("implvola.dat")

# rescale
x = x/100

# compute first differences
z = apply(x,2,diff)
# calculate covariance
s = cov(z) * 1e+05
round(s, 2)

```

### MATLAB Code:
```matlab
clear
clc
close all

%Load data
x = load('implvola.dat');

x = x / 100;
n = length(x);

%Calculate first differences and calculate the covariance matrix.
z = x(2:n, :) - x(1:(n - 1), :);
s = cov(z) * 100000;

disp('Empirical Covariance Matrix')
disp('      Sub 1    Sub 2     Sub 3     Sub 4     Sub 5     Sub 6     Sub 7     Sub 8')
disp(s)
```
