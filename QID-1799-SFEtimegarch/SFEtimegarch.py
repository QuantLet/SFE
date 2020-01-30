import numpy as np
import matplotlib.pyplot as plt
#
np.random.seed(1234)


#omega = 0.1, alpha = 0.15, beta = 0.8
n=1000          # number of observations
n1=100          # drop first observations 

alpha=(0.1,0.3)    # GARCH (1,1) coefficients alpha0 and alpha1
beta=0.8 
errors=np.random.normal(0,1,n+n1) 
t=np.zeros(n+n1)
t[0]=np.random.normal(0,np.sqrt(alpha[0]/(1-alpha[1])),1)
#iterate over the oberservations
for i in range(1,n+n1-1): 
    t[i]=errors[i]*np.sqrt(alpha[0]+alpha[1]*errors[i-1]**2+beta*t[i-1]**2)
#
y=t[n1-1:-1]    # drop n1 observations 
plt.title('GARCH (1,1) process')
x=range(n) 
plt.plot(x,y)
plt.xlabel('time')
plt.ylabel('y')

plt.savefig('SFEtimegarch_py.png')
plt.show()