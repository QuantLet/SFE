import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
import arch
from arch import arch_model
from arch.univariate import GARCH
from statsmodels.tsa.arima_model import ARMA
import datetime

ds = pd.read_table("FSE_LSE.dat",header=None)
date = ds.iloc[:,0]

def log_returns(df):
	logs=np.log((df.pct_change()+1).dropna())
	logs=pd.DataFrame(logs)
	return(logs)

class index_data():
	def __init__(self):
		pass

	def feed_data(self,data):
		self.raw_ts=data

	def fit_ARCH(self,data):#fit ARCH(q)models
		llhs=[]
		for q in np.arange(0,15):
			#return is scaled in order to facilitate convergence
			self.arch = arch_model(data*100,vol='ARCH',p=1,q=q)
			self.arch_fit=self.arch.fit(disp='off')
			llh=self.arch_fit.loglikelihood
			llhs.append(llh)
		self.llh=llh

	def fit_ARMA_GARCH(self,data):

		#fit the GARCH with AR term
		self.garch = arch_model(data*100,vol='GARCH',p=1,q=1,mean='ARX')
		self.garch_fit = self.garch.fit(disp='off')
		self.arma_garch_vola=self.garch_fit._volatility
		

r = log_returns(ds.iloc[:,np.arange(1,42)])
rdax = r.iloc[:,0]
rftse = r.iloc[:,21]
n = ds.shape[0]
t = np.arange(n)

dax = index_data()
dax.feed_data(ds.iloc[:,1])
dax.fit_ARCH(rdax)
dax.fit_ARMA_GARCH(rdax)

ftse = index_data()
ftse.feed_data(ds.iloc[:,21])
ftse.fit_ARCH(rftse)
ftse.fit_ARMA_GARCH(rftse)

n=ftse.arma_garch_vola.shape[0]
date_str=[str(d) for d in date]

date_str=[d[:4]+'-'+d[4:6]+'-'+d[6:] for d in date_str]
dt=[datetime.datetime.strptime(d,'%Y-%m-%d') for d in date_str]


fig, ax = plt.subplots(2,1,figsize=(13, 6))
fig.suptitle('Volatility estimation for DAX and FTSE 100 data')
ax[0].plot(dt[-n:],dax.arma_garch_vola,label='DAX 30',color='blue')
ax[0].set_xlabel('t')

ax[0].legend()

ax[1].plot(dt[-n:],ftse.arma_garch_vola,color='blue',label='FTSE 100')
ax[1].set_xlabel('t')
ax[1].legend()

fig.suptitle('Volatility estimation for DAX and FTSE 100 data')
plt.savefig('SFEvolgarchest_py.png')
plt.show()


