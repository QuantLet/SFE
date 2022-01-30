import numpy as np
from matplotlib import pyplot as plt
from matplotlib import cm
import pandas as pd
from py_vollib.black_scholes.implied_volatility import implied_volatility
from statsmodels.nonparametric.kernel_regression import KernelReg
from scipy.stats import iqr

save_figure = True
use_silverman_bw = False     # Use Silverman's rule of thumb for kernel regression bandwith or cross-validation

# Read the csv file
df = pd.read_csv('surf_1412.csv', names=['Price', 'Strike', 'Rate', 'Time', 'Value', 'Class'])
df.drop_duplicates(inplace=True)

# Calculate moneyness
df['Moneyness'] = df['Price']/df['Strike']

# Drop data points that have extreme moneyness or too far away from maturity
df.drop(df[df['Time']>1].index, inplace=True)
df.drop(df[(df['Moneyness']<0.7) | (df['Moneyness']>1.2)].index, inplace=True)

# Indicate if the row corresponds to a call or a put
df['Class'] = df['Class'].map({0: 'p', 1: 'c'})

# Computes implied volatility
def iv(row):
    return implied_volatility(row['Value'], row['Price'], row['Strike'], row['Time'], row['Rate'], row['Class'])


df['Implied Volatility'] = df.apply(iv, axis=1)

# Drop rows with Nan values
df.dropna(inplace=True)

if use_silverman_bw:

    def compute_silverman_bw(column):
        a = np.unique(column)
        return 0.9 * np.min([np.std(a), iqr(a) / 1.34]) * len(a) ** (-1 / 5)

    bw = [compute_silverman_bw(column) for column in [df['Implied Volatility'], df['Time']]]

else:
    bw = 'cv_ls'

# Do a kernel regression with gaussian kernel and bandwidth determined by cross-validation
kr = KernelReg(df['Implied Volatility'], [df['Time'], df['Moneyness']], 'cc', bw=bw)

# Create a grid for the plot and predict the volatility surface on it
steps = 60
tau = np.linspace(df['Time'].min(), df['Time'].max(), steps)
moneyness = np.linspace(df['Moneyness'].min(), df['Moneyness'].max(), steps)
mg = np.array(np.meshgrid(tau, moneyness)).reshape(2,-1)
estimate, _ = kr.fit(mg)

# Plot
X, Y = np.meshgrid(tau, moneyness)
fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
ax.plot_surface(X, Y, estimate.reshape(-1, steps), cmap=cm.viridis)
ax.scatter(df['Time'], df['Moneyness'], df['Implied Volatility'], c='r', marker='x')
plt.show()

if save_figure:
    fig.savefig('SFEVolSurfPlot.png', transparent=True)
