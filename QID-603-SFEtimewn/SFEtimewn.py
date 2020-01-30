import numpy as np
import matplotlib.pyplot as plt 

#set seed to have reproducible results
np.random.seed(10)
#sample 1000 normally distributed noise terms
wn=np.random.normal(0,1,1000)

#create a plot
plt.plot(wn)
plt.title('Gaussian White Noise')
plt.xlabel('Index')
plt.ylabel('x')
plt.savefig('TimeWN_py.png')
plt.show()


