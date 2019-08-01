[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEReturns** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEReturns
Published in: Statistics of Financial Markets
Description: 'Computes the first order auto correlation of the returns, squared returns and absolute returns as well as the skewness, kurtosis and Jarque-Bera test statistic for German blue chips, 1974 - 1996.'
Keywords:
- autocorrelation
- blue chips
- correlation
- dax
- descriptive-statistics
- financial
- jarque-bera-test
- kurtosis
- log-returns
- returns
- skewness
- statistics
- test
Author: Joanna Tomanek
Author[m]: Andrija Mihoci
Author[py]: Justin Hellermann
Submitted: Fri, June 05 2015 by Lukas Borke
Submitted[m]: Mon, May 02 2016 by Meng Jou Lu
Submitted[py]: Thu, Aug 01 2019 by Justin Hellermann
Input[m]:
- Params: a, b, sigma
- X: yields of the US 3 month treasury bill
Output[Matlab]: Value of the log-likelihood function in Vasicek model.
Datafiles: sfm_pri.dat
Datafiles[m]: FTSE_DAX.dat
Datafiles[py]: sfm_pri.dat

```

### R Code
```r


# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fBasics", "tseries")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
datax = read.table("sfm_pri.dat", header = FALSE)

msg1 = "This program calculates the first order auto correlation of returns, squared returns and absolute returns and skewness, kurtosis and the Bera Jarque statistic for german blue chips, 1974 - 1996"
print(msg1)

datax = as.matrix(datax)
stocks = as.matrix(c("all", "allianz", "basf", "bayer", "bmw", "cobank", "daimler", 
    "deutsche bank", "degussa", "dresdner bank", "hoechst", "karstadt", "linde", 
    "man", "mannesmann", "preussag", "rwe", "schering", "siemens", "thyssen", 
    "volkswagen"))
s = menu(stocks, graphics = TRUE, title = "Select one")
n = nrow(datax)
x = (datax[, s])
st = stocks[s]

# select all companies, if the first menu entry was selected
if (s == 1) {
    x = (datax[, 2:ncol(datax)])
    st = c(stocks[2:21])
}

x = as.matrix(x)
result = matrix(1, ncol = 7, nrow = ncol(x), dimnames = list(st, c("rho(ret):", 
    "rho n(ret^2):", "rho(|ret|):", "S:", "K:", "JB:", "JB p-value:")))
	
for (i in 1:ncol(x)) {
    # start calculation
    ret1 = log(x[2:n, i]) - log(x[1:(n - 1), i])
    skew = skewness(ret1)
    kurt = kurtosis(ret1)
    ret1 = as.matrix(ret1)
    ret2 = matrix(c(ret1^2))
    ret3 = matrix(c(abs(ret1)))
    n = nrow(ret1)
    rho1 = cor(ret1[2:n], ret1[1:(n - 1)])
    rho2 = cor(ret2[2:n], ret2[1:(n - 1)])
    rho3 = cor(ret3[2:n], ret3[1:(n - 1)])
    jb = jarque.bera.test(ret1)
    
    # end calculation
    result[i, 1] = rho1
    result[i, 2] = rho2
    result[i, 3] = rho3
    result[i, 4] = skew[1]
    result[i, 5] = kurt[1]
    result[i, 6] = jb[[1]]
    result[i, 7] = jb[[3]]
}

# Output
msg2 = "first order auto correlation of returns, squared returns and absolute returns and skewness, kurtosis and Bera Jarque statistic for german blue chips, 1974 - 1996"
print(msg2)
print("")
result 

```

automatically created on 2019-08-01

### MATLAB Code
```matlab


clear
clc 
close all

% Read data for FTSE and DAX

DS = load('FTSE_DAX.dat');
D  = [DS(:,1)];                            % date
S  = [DS(:,2:43)];                         % S(t)
s  = [log(S)];                             % log(S(t))
r  = [s(2:end,:) - s(1:(end-1),:)];        % r(t)
n  = length(r);                            % sample size
t  = [1:n];                                % time index, t
format short;

% Estimation of the first order autocorrelation

for i = 1:42;
  yp    = corrcoef(r(1:(length(r)-1),i), r(2:(length(r)),i));
  ys    = corrcoef(r(1:(length(r)-1),i).*r(1:(length(r)-1),i), r(2:(length(r)),i).*r(2:(length(r)),i));
  ya    = corrcoef(abs(r(1:(length(r)-1),i)), abs(r(2:(length(r)),i)));
  zp(i) = [yp(2,1,:)];
  zs(i) = [ys(2,1,:)];
  za(i) = [ya(2,1,:)];
end

% Estimation of skewness

skew = (skewness(r))';

% Estimation of kurtosis

kurt = (kurtosis(r))';

% Estimation of the BJ test statistic for returns

BJ = n * ( skew .* skew / 6 + ( ( kurt - 3 ) .* ( kurt - 3 ) ) / 24 );

% Estimated parameters

Y = [ zp' zs' za' skew kurt BJ ];

disp('First order autocorrelation of the returns,')
disp('First order autocorrelation of the squared returns,')
disp('First order autocorrelation of the absolute returns,')
disp('Skewness & ')
disp('Kurtosis')
disp(Y(:,1:5))

disp(' ')
disp('Bera-Jarque test statistic')
disp(Y(:,6))
```

automatically created on 2019-08-01

### PYTHON Code
```python

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.stats.stattools import jarque_bera


data=pd.read_table('sfm_pri.dat',header=None,sep=' ').round(2)
cols=["all", "allianz", "basf", "bayer", "bmw", "cobank", "daimler", 
    "deutsche bank", "degussa", "dresdner bank", "hoechst", "karstadt", "linde", 
    "man", "mannesmann", "preussag", "rwe", "schering", "siemens", "thyssen", 
    "volkswagen"]
data.columns=cols
#msg1 = "This program calculates the first order auto correlation of returns, squared returns and absolute returns and skewness, kurtosis and the Bera Jarque statistic for german blue chips, 1974 - 1996"
#print(msg1)

selection='rwe'

def log_returns(series):
	rets=np.log(series.pct_change()+1).dropna()
	return(rets)

def corr_coeff(df):
	res=[]
	for col in df.columns:
		corr=np.corrcoef(df[col].iloc[1:],df[col].shift(1).dropna())
		res.append([col,corr[1,0]])
	return(pd.DataFrame(res,columns=['Stock','Coefficient']))

def distr_properties(df):
	#calculate skewness, kurtosis, value of JB, JB p-value
	skew = df.skew(axis=0)
	kurt = df.kurtosis(axis=0)

	jbs = df.apply(jarque_bera,axis=0).values.flatten()
	pd.set_option('display.float_format', lambda x: '%.4f' % x)
	jb_dataframe = pd.DataFrame([list(elem) for elem in jbs],columns=['JB','JBpv','skewness','kurtosis']).reset_index(drop=True).astype(float)
	jb_dataframe['Stock']=cols
	jb_dataframe=jb_dataframe[['Stock','JB','JBpv','skewness','kurtosis']]
	return(jb_dataframe)
	
	

data_ret = data.apply(log_returns,axis=0)
data_ret_sq = data_ret.apply(np.square)
data_ret_abs = data_ret.apply(np.abs)

#Calculate Correlation Coefficients
corr_ret = corr_coeff(data_ret)
corr_ret_sq = corr_coeff(data_ret_sq)
corr_ret_abs = corr_coeff(data_ret_abs)

jb_stats = distr_properties(data_ret)
res=pd.concat([corr_ret,corr_ret_sq.iloc[:,1:],corr_ret_abs.iloc[:,1:],jb_stats.iloc[:,1:]],axis=1)
res.columns=['Stock','rho(ret)','rho(ret^2)','rho(|ret|)','JB','JBpv','S','K']
pd.set_option('display.max_columns', 10)
print(res)

```

automatically created on 2019-08-01