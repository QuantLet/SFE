import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
from arch import arch_model
from arch.univariate import GARCH
from statsmodels.tsa.arima_model import ARMA
import datetime

np.set_printoptions(suppress=True)

ds = pd.read_table("FSE_LSE.dat",header=None)

def log_returns(df):
	logs=np.log((df.pct_change()+1).dropna())
	logs=pd.DataFrame(logs)
	return(logs)

S = ds.iloc[:,1:42]	#stocks
r = log_returns(S) #log returns
D = ds.iloc[:,0] #date

n   = r.shape[0] #observations
t   = np.arange(0,n) #time steps
rdax  = r.iloc[:,1] #dax returns 
rftse = r.iloc[:,22] #ftse returns



y1 = r.iloc[np.arange(r.shape[0]-1),0].values.reshape((-1,1))
y2 = r.iloc[1:,0].values.reshape((-1,1))
y = np.concatenate([y1,y2],axis=1)
yy = np.concatenate([y[:,0].reshape((-1,1)),(y[:,1]**2).reshape((-1,1))],axis=1)

hm   = 0.04  # bandwidth
hs   = 0.04  # bandwidth
X    = y[:,0]
Y    = y[:,1]
p    = 1
h    = hm

def quadk(x):#compute quadratic kernel
	I =np.array([(x*x)<1]).astype(int)#true:1, false:0
	x=x*I
	y=I*((1-x*x)**2)*(15)/(16)
	return(y)


def lpregest(X,Y,p,h):
	
	n = X.shape[0]
	x = np.arange(np.min(X),np.max(X),(np.max(X)-np.min(X))/(100))
	m = x.shape[0]
	bhat = []
	for i in range(m):
		dm = np.ones((n,1))
		xx = X-x[i]
		
		if p>0:
			for j in range(1,p+1):
				dm=np.concatenate([dm,np.array((xx)**j).reshape((-1,1))],axis=1).astype(float)
				
	
		val =  np.array([quadk(arg)/h for arg in xx/h])
		w = np.zeros((val.shape[0],val.shape[0]))
		np.fill_diagonal(w,val)
		
		mh = np.linalg.solve(np.transpose(dm).dot(w).dot(dm),np.identity(np.transpose(dm).shape[0])).dot(np.transpose(dm)).dot(w)
		bhat.append(mh.dot(Y))
	return(np.array(bhat),np.array(x))


#estimate conditional first moment
m1h,yg = lpregest(y[:,0],y[:,1],1,hm)

#estimate conditional second moment
m2h,yg = lpregest(yy[:,0], yy[:,1], 1, hs)

#conditional variance
sh = np.concatenate([np.transpose(yg).reshape((1,-1)),np.transpose(m2h[:,0]-m1h[:,0]**2).reshape((1,-1))],axis=0)

#interpolation
m1hx = np.interp(y[:,1],yg,m1h[:,0])
shx_DAX = np.interp(y[:,1],yg,sh[1,:])



############################# FTSE ########################

y1 = r.iloc[np.arange(r.shape[0]-1),21].values.reshape((-1,1))
y2 = r.iloc[1:,21].values.reshape((-1,1))
y = np.concatenate([y1,y2],axis=1)
yy = np.concatenate([y[:,0].reshape((-1,1)),(y[:,1]**2).reshape((-1,1))],axis=1)

m1h,yg = lpregest(y[:,0],y[:,1],1,hm)

#estimate conditional second moment
m2h,yg = lpregest(yy[:,0], yy[:,1], 1, hs)

#conditional variance
sh = np.concatenate([np.transpose(yg).reshape((1,-1)),np.transpose(m2h[:,0]-m1h[:,0]**2).reshape((1,-1))],axis=0)

#interpolation
m1hx = np.interp(y[:,1],yg,m1h[:,0])
shx_FTSE = np.interp(y[:,1],yg,sh[1,:])

fig = plt.figure(figsize=(14,6))
ax = fig.add_subplot(2, 1, 1)
ax.plot(shx_DAX**.5,label='DAX 30')
ax.set_xlabel('t')
ax.title
plt.legend()

ax = fig.add_subplot(2, 1, 2)
ax.plot(shx_FTSE**.5,label='FTSE 100')
ax.set_xlabel('t')
plt.legend()
plt.suptitle('Nonparametric volatility estimation - DAX 30 and FTSE 100')


plt.savefig('SFEvolnoparest_py.png')
plt.show()