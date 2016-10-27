
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEVolaPCA** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEVolaPCA

Published in : Statistics of Financial Markets

Description : 'Calculates the explained sample variance and the cumulative variance using principal
components (in percentages).'

Keywords : dax, financial, implied-volatility, pca, variance, vdax, volatility

See also : SFEVolSurfPlot, SFEVolSurfPlot, SFEVolaCov, SFEVolaTermStructure

Author : Joanna Tomanek

Author[Matlab] : Wolfgang K. Härdle, Lasse Groth

Submitted : Fri, July 17 2015 by quantomas

Submitted[Matlab] : Fri, February 19 2010 by Lasse Groth

Datafiles : implvola.dat

```


### R Code:
```r
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
x = read.table("implvola.dat")

# rescale
x = x * 100

# number of rows
n = nrow(x)

# calculate first differences
z=apply(x,2,diff)

# calculate covariance
s = cov(z) * 1e+05

# calculate eigenvalues and eigenvectors
e = eigen(s, symmetric = TRUE)
l = e$values

# percentage of explained variance
l/sum(l) * 100

# cumulative sum of percentage of explained variance
cumsum(l/sum(l) * 100)

```

### MATLAB Code:
```matlab

clear
clc
close all

%Load data
x = load('implvola.dat');
x = x * 100;

%Calculate first differences and determine the eigenvectors.
n     = length(x);
z     = x(2:n, :) - x(1:(n - 1), :);
s     = cov(z) * 100000;
[v e] = eig(s);

%Arranging eigenvalues
e1 = flipud(diag(e))';

%Explained sample variance by each principle component and cumulative
values = (e1 / (ones(8, 1)' * e1') * 100)'; 
cumulative_sum = (cumsum(e1 / (ones(8,1)' * e1') * 100))';

disp('Explained sample variance using principal components in percentage')
disp('      PC   Percentage Cumulative Percentage')
disp([(1:8)' values cumulative_sum])

```
