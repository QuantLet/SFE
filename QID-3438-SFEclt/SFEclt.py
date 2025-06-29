import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde, norm

def gen_sample(n:int,p:float)->np.array:
    bsample = np.random.binomial(1, p, n * 1000)
    
    # Create a matrix of binomial random variables
    # The matrix has n rows and 1000 columns, where each column is a sample.
    bsamplem = bsample.reshape((n, 1000))
    return bsamplem

def get_kde(sample:np.array,p:float,n:int)->dict[str,np.array]:
    # Calculate the mean of each sample (column)
    sample_means = np.mean(sample, axis=0)

    # Standardize the sample means
    standardized_means = (sample_means - p) / np.sqrt(p * (1 - p) / n)

    # Compute kernel density estimate
    kde = gaussian_kde(standardized_means)
    x_vals = np.linspace(standardized_means.min(), standardized_means.max(), 500)
    bden_y = kde(x_vals)
    return {'x_values':x_vals, 'kde':bden_y}

def make_plots(x,y,n)->plt.figure:
    # Plot
    fig = plt.figure(figsize=(10, 6))

    # Plot kernel density
    plt.plot(x, y, color="green", linestyle="-", linewidth=2, label="Estimated Density")

    # Plot standard normal density
    plt.plot(x, norm.pdf(x), color="red", linestyle="-", linewidth=2, label="Normal Density")

    # Add labels and title
    plt.xlabel("1000 Random Samples", fontsize=14)
    plt.ylabel("Estimated and Normal Density", fontsize=14)
    plt.title(f"Asymptotic Distribution, n = {n}", fontsize=16)
    plt.ylim(0, 0.45)
    plt.legend()
    plt.grid(True)
    return fig 

if __name__ == "__main__":
    # Example usage

    ns = [35,350,3500,35000]
    p=0.5

    figs=[]
    for i in ns:
        sample = gen_sample(i,p)
        d_kde = get_kde(sample,p,i)
        figs.append(make_plots(d_kde['x_values'],d_kde['kde'],i))
    plt.show()