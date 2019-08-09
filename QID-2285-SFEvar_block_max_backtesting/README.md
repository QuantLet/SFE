[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEvar_block_max_backtesting** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEvar_block_max_backtesting

Published in : Statistics of Financial Markets

Description : 'Plots the Value-at-Risk estimation at 0.05 level for the portfolio composed 
               by Bayer, BMW, siemens and Volkswagen. The Value at Risk is computed by means
               of the Block Maxima Model.'

Keywords : 'VaR, backtesting, block-maxima, portfolio, plot'

See also : 'SFEvar_block_max_params, SFEvar_pot_backtesting, SFEvar_pot_params, block_max,
var_block_max_backtesting, var_pot, var_pot_backtesting'

Author : Awdesch Melzer and Piedad Castro
Author[Matlab]: Barbara Choros, Awdesch Melzer and Piedad Castro

Submitted : Thu, December 1 2016 by Piedad Castro

Datafiles : '2004-2014_dax_ftse.csv'

Input: 'The datafile contains daily price data from 07.05.2004 to 07.05.2014 for 
selected companies which are part of DAX30 and FTSE100 as well as the 
corresponding index data. This code makes use of the daily prices for the 
companies Bayer, BMW, Siemens and Volkswagen.'

Output: 
- p: exceedances ratio

```

![Picture1](SFEvar_block_max_backtesting_R.png)

![Picture2](SFEvar_block_max_backtesting_matlab.png)

### R Code
```r

# clear all variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# set working directory
# setwd("C:/...")

# install and load packages
libraries = c("evd")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# data import
Data = read.csv("2004-2014_dax_ftse.csv")

# date variable as variable of class Date
Data$Date = as.Date(Data$Date, "%Y-%m-%d")

# Create portfolio
x       = Data$BAYER + Data$BMW + Data$SIEMENS + Data$VOLKSWAGEN
x       = diff(x)     # returns
minus_x = -x          # negative returns
Obs     = length(x)   # number of observations 
h       = 250         # size of moving window
p       = 0.95        # quantile for the Value at Risk
n       = 16          # observation window for estimating quantile in VaR

# function ----
block_max = function(y,n,p){
  N = length(y)
  k = floor(N/n)
  z = rep(NaN, k)
  for(j in 1:(k-1)){
    r    = y[((j-1)*n+1):(j*n)]
    z[j] = max(r)
  }
  r     = y[((k-1)*n+1):length(y)]
  z[k]  = max(r)
  
  parmhat = fgev(z, std.err = FALSE)$param
  kappa   = parmhat["shape"]
  tau     = -1/kappa
  alpha   = parmhat["scale"]
  beta    = parmhat["loc"]
  
  pext    = p^n
  var     = beta+alpha/kappa*((-log(1-pext))^(-kappa)-1)
  out    = c(var=var,tau=tau,alpha=alpha,beta=beta,kappa=kappa) 
}

# Value at Risk ----
# preallocation
results = data.frame(var=rep(NaN,Obs-h), tau=rep(NaN,Obs-h), alpha=rep(NaN,Obs-h),
                     beta=rep(NaN,Obs-h), kappa=rep(NaN,Obs-h) )

for(i in 1:(Obs-h)){
  y = minus_x[i:(i+h-1)]
  results[i,] = block_max(y,n,p)
}

v = -results$var
L = x

# preallocation
outlier   = rep(NaN,Obs-h)
exceedVaR = outlier

for(j in 1:(Obs-h)){
  exceedVaR[j] = (L[j+h]<v[j])
  if(exceedVaR[j]>0){
    outlier[j] = L[j+h]
  }
}

p       = sum(exceedVaR)/(Obs-h)
K       = which(is.finite(outlier))
outlier = outlier[K]
yplus   = K * 0 + min(L[(h + 1):length(L)]) - 2

date_outlier = Data$Date[(h+2):length(Data$Date)]
date_outlier = date_outlier[K]

# plot ----
windows()
plot(Data$Date[(h+2):length(Data$Date)],x[(h+1):Obs], xlab = "", 
     ylab = "", col = "blue", pch = 18)
points(date_outlier, outlier, pch = 18, col = "magenta")
lines(Data$Date[(h+2):length(Data$Date)], v, col= "red", lwd = 3)
points(date_outlier, yplus, pch = 3, col = "dark green")
legend("topleft", c("Profit/Loss", "VaR", "Exceedances"), pch = c(18, NA, 18), 
       lwd = c(NA, 3, NA), col = c("blue", "red", "magenta"))
title("Block Maxima Model")

# Print the exceedances ratio
print(paste("Exceedances ratio:", "", p))

```

automatically created on 2018-09-04

### MATLAB Code
```matlab

%% clear all variables and console 
clear
clc

%% close windows
close all

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
Data       = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);        
Data     = Data(:,{'Date','BAYER','BMW', 'SIEMENS', 'VOLKSWAGEN'});

%% create portfolio
x       = Data.BAYER + Data.BMW + Data.SIEMENS + Data.VOLKSWAGEN;
x       = diff(x);    % returns
minus_x = -x;         % negative returns
Obs     = length(x);  % number of observations
p       = 0.95;       % quantile for the Value at Risk
h       = 250;        % size of moving window
n       = 16;         % size of moving window for estimating quantile in VaR

%% Value at Risk
% preallocation
var   = NaN(1,Obs-h);
tau   = var;
alpha = var;
beta  = var;
kappa = var;

for i = 1:Obs-h
    y = minus_x(i:i+h-1);
    [var(i),tau(i),alpha(i),beta(i),kappa(i)] = block_max(y,n,p);
end;

[v,K,outlier,yplus,p] = var_block_max_backtesting(x,var,h);

date_outlier = Data.Date(h+2:end);
date_outlier = date_outlier(K);

%% plot
plot(Data.Date(h+2:end),x(h+1:end), '.')
hold on
plot(Data.Date(h+2:end), v,'Color','red','LineWidth',2)
plot(date_outlier,outlier,'.','Color','m')
plot(date_outlier,yplus,'+','Color',[0,0.25098,0])
legend('Profit/Loss','VaR','Exceedances', 'Location', 'northwest')
title('Block Maxima Model','FontSize',16,'FontWeight','Bold')

```

automatically created on 2018-09-04