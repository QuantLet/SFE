import pandas as pd
import numpy as np
from statsmodels.graphics.tsaplots import plot_acf
import matplotlib.pyplot as plt
from statsmodels.tsa.arima_process import ArmaProcess

# parameter settings
lag = 30    # lag value
n1 = 10
n2 = 20
b = 0.5

# Obtain MA(1) sample by sampling from a ARMA() model with no AR coefficient
ar1 = np.array([1])
ma1 = np.array([1,b])
np.random.seed(123)
MA_object1 = ArmaProcess(ar1,ma1)
simulated_data_1 = MA_object1.generate_sample(nsample=n1)
simulated_data_2 = MA_object1.generate_sample(nsample=n2)


f, ax = plt.subplots(2,figsize=(11, 6))
ax[0].plot(simulated_data_1)#title='Sample ACF of an MA(1) Process')
ax[0].set_xlabel('t')
ax[0].set_title(r'MA(1) process with $\beta=$'+str(b)+' and $n=10$')
ax[0].set_xticks(np.arange(0, n1, step=1))

ax[1].plot(simulated_data_2)
ax[1].set_xlabel('t')
ax[1].set_title(r'MA(1) process with $\beta=$'+str(b)+' and $n=20$')
ax[1].set_xticks(np.arange(0, n2, step=1))
plt.tight_layout()
plt.savefig('SFEplotma1_py.png')
plt.show()