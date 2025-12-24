import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

def bs_call(S, K, r, tau, sigma):
    """
    Calculates the Black-Scholes formula for a European call option price.
    """
    # To prevent division by zero or log of zero, S is treated as a small positive number if it's 0.
    S = np.maximum(S, 1e-10)
    
    d1 = (np.log(S / K) + (r + (sigma ** 2 / 2)) * tau) / (sigma * np.sqrt(tau))
    d2 = d1 - sigma * np.sqrt(tau)
    C = S * norm.cdf(d1) - K * np.exp(-r * tau) * norm.cdf(d2)
    return C

# Input parameters
lb = 0         # Lower limit of x-axis
ub = 170       # Upper limit of x-axis
S = np.arange(lb, ub + 1)  # Stock price range

K = 100       # Strike price
r = 0.1       # Risk-free interest rate
tau = 0.6       # Time to maturity (blue line)
tau2 = 0.003     # Time to maturity (red dotted line)
sigma = 0.15      # Volatility for the first plot
sigma2 = 0.3       # Volatility for the second plot

# Calculate Black-Scholes prices for the different scenarios
call1 = bs_call(S, K, r, tau, sigma)
call1_2 = bs_call(S, K, r, tau2, sigma)
call2 = bs_call(S, K, r, tau, sigma2)
call2_2 = bs_call(S, K, r, tau2, sigma2)

# Set up a figure with two subplots, similar to R's par(mfrow=c(1, 2))
fig, axs = plt.subplots(1, 2, figsize=(14, 6))

# --- Plot 1: sigma = 0.15 ---
axs[0].plot(S, call1, color="blue", linewidth=2, label=f"Time to Maturity (τ) = {tau}")
axs[0].plot(S, call1_2, color="red", linewidth=2, linestyle="--", label=f"Time to Maturity (τ) = {tau2}")
axs[0].set_title("Black-Scholes Price (σ = 0.15)")
axs[0].set_xlabel("Stock Price (S)")
axs[0].set_ylabel("Call Price C(S, τ)")
axs[0].set_xlim(lb, ub)
axs[0].set_ylim(0, max(call1) * 1.05) # Add 5% padding to y-axis
axs[0].legend()

# --- Plot 2: sigma = 0.30 ---
axs[1].plot(S, call2, color="blue", linewidth=2, label=f"Time to Maturity (τ) = {tau}")
axs[1].plot(S, call2_2, color="red", linewidth=2, linestyle="--", label=f"Time to Maturity (τ) = {tau2}")
axs[1].set_title("Black-Scholes Price (σ = 0.30)")
axs[1].set_xlabel("Stock Price (S)")
axs[1].set_ylabel("Call Price C(S, τ)")
axs[1].set_xlim(lb, ub)
axs[1].set_ylim(0, max(call2) * 1.05) # Add 5% padding to y-axis
axs[1].legend()

# Display the plots
plt.tight_layout()
plt.show()
