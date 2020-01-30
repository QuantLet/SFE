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
