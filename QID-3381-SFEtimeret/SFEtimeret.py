import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
import datetime

#read data
df = pd.read_table("FSE_LSE.dat")

#calculate log returns
dax=np.log(df.iloc[:,1].pct_change()+1)
ftse=np.log(df.iloc[:,-1].pct_change()+1)


#Prepare Plots
date=pd.DataFrame([datetime.datetime.strptime(str(x)[:4]+'-'+str(x)[4:6]+'-'+str(x)[6:8], '%Y-%m-%d') for x in df.iloc[:,0]])
data=pd.concat([date,dax,ftse],axis=1)
data.columns=['Date','DAX','FTSE']

#Create Plots
f, (ax1, ax2) = plt.subplots(2, 1, sharey=True,figsize=(11,6))
ax1.plot(data.Date,data.DAX)
ax1.set_ylabel('r(t)')
ax1.set_xlabel('t')
ax1.set_title('Dax Returns from 1998-2008')

ax2.plot(data.Date,data.FTSE)
ax2.set_ylabel('r(t)')
ax2.set_xlabel('t')
ax2.set_title('FTSE Returns from 1998-2008')
plt.tight_layout()
plt.savefig('SFE_timeret2_py.png')
plt.show()
