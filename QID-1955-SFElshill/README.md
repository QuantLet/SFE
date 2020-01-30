[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFElshill** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: SFElshill

Published in: Statistics of Financial Markets

Description: 'Reads the date, DAX index values, stock prices of 20 largest companies at Frankfurt Stock Exchange (FSE), FTSE 100 index values and stock prices of 20 largest companies at London Stock Exchange (LSE) and computes the Least Square (LS) and the Hill estimators of the tail index for all 42 analysed return processes.'

Keywords: data visualization, graphical representation, plot, financial, asset, stock-price, returns, time-series, dax, ftse100, index, descriptive-statistics, hill-estimator, least-squares, tail, index

See also: SFEtimeret, SFEvolnonparest, SFEvolgarchest, SFEmvol01, SFEmvol03, SFEtail

Author: Andrija Mihoci, Awdesch Melzer
Author[Python]: Justin Hellermann

Submitted: Thu, October 11 2012 by Dedy Dwi Prastyo
Submitted[Python]: Thu, Aug 01 2019 by Justin Hellermann

Datafiles: FSE_LSE_2014.dat

Output: 
- Y : matrix of tail index estimations


```

### R Code
```r


# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("matlab", "pracma")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data for FSE and LSE
DS = read.csv("FSE_LSE_2014.dat")
D  = DS[, 1]                           # date
S  = DS[, 2:43]                        # S(t)
r  = diff(as.matrix(log(S)))           # r(t) = log(S(t)) - log(S(t-1)) 
n  = length(r)                         # sample size
d  = NCOL(r)                           # columns or r

# Right tail index regression and Hill estimator
m1 = 10  # m1 largest observations
m2 = 25  # m2 largest observations

rsorted = apply(r, 2, sort, decreasing = TRUE)

x1 = log(rsorted[1:m1, ])
y1 = matrix(rep(log(c(1:m1)/n), d), ncol = d)

x2 = log(rsorted[1:m2, ]) 
y2 = matrix(rep(log(c(1:m2)/n), d), ncol = d)

ls1 = ls2 = hill1 = hill2 = numeric(d)

for (i in 1:d){
  ls1[i]   = lm(y1[, i] ~ x1[, i])$coef[2]
  ls2[i]   = lm(y2[, i] ~ x2[, i])$coef[2]
  hill1[i] = 1/(mean(x1[1:(m1-1), i]) - x1[m1, i])
  hill2[i] = 1/(mean(x2[1:(m2-1), i]) - x2[m2, i])
}

Y = cbind(-ls1, -ls2, hill1, hill2)
colnames(Y) = c("LS_m1", "LS_m2", "Hill_m1", "Hill_m2")
round(Y, 2)
```

automatically created on 2019-08-02

### PYTHON Code
```python

import numpy as np 
import pandas as pd
import sklearn
from sklearn.linear_model import LinearRegression

df = pd.read_csv("FSE_LSE_2014.dat",header=None)


D  = df.iloc[:,0]                           # date
S  = df.iloc[:,1:43]                        # S(t)
r  = np.log(S).diff(1).dropna()                      # r(t) = log(S(t)) - log(S(t-1)) 
n  = r.shape[0]*r.shape[1]                  # sample size
d  = r.shape[1]                             # columns or r

# Right tail index regression and Hill estimator
m1 = 10  # m1 largest observations
m2 = 25  # m2 largest observations

#Sort each column
r_sorted=[]
for col in r.columns:
	r_sorted.append(r[col].sort_values(ascending=False).values)
r_sorted = pd.DataFrame(r_sorted).T

x1 = np.log(r_sorted.head(m1))
y1 = pd.DataFrame(np.repeat(np.log((np.arange(m1).astype(float)+1)/n),d).reshape((-1,d)))

x2 = np.log(r_sorted.head(m2))
y2 = pd.DataFrame(np.repeat(np.log((np.arange(m2).astype(float)+1)/n),d).reshape((-1,d)))

ls1=[]
ls2=[]
hill1=[]
hill2=[]

#loop over the columns of the return data frame and fit regression
for i in range(d):
	lr=LinearRegression()
	#reshape data, fit the regression model, append coefficients to list
	ls1.append(-lr.fit(x1.iloc[:,i].values.reshape((-1,1)),y1.iloc[:,i].values.reshape((-1,1))).coef_.flatten())
	ls2.append(-lr.fit(x2.iloc[:,i].values.reshape((-1,1)),y2.iloc[:,i].values.reshape((-1,1))).coef_.flatten())
	
	hill1.append(1/(np.mean(x1.iloc[:m1-1, i]) - x1.iloc[m1-1, i]))
	hill2.append(1/(np.mean(x2.iloc[:m2-1, i]) - x2.iloc[m2-1, i]))

#assemble coefficients to a data frame
Y = pd.DataFrame([ls1,ls2,hill1,hill2]).T.astype(float).round(2)
Y.columns=["LS_m1", "LS_m2", "Hill_m1", "Hill_m2"]
print(Y)

```

automatically created on 2019-08-02