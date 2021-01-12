import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.stats.stattools import jarque_bera


data=pd.read_table('sfm_pri.dat',header=None,sep='|').round(2)
cols=["adidas", "allianz", "basf", "bayer", "beiersdorf", "bmw", "continental", "daimler", "dax",  
    "deutsche bank", "deutsche post", "deutsche telekom", "national grid", "prudential", "reckitt benckiser", 
    "royal dutch shell", "rio tinto", "standard chartered", "unilever UK", "vodafone"]
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
