
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Parameters of the CIR model (a, b, sigma)
a     = 0.221
b     = 0.02
sigma = 0.055

tau = 0.25  # time to maturity (in years)
r   = 0.02  # risk free rate at time t

# Main computation
phi = sqrt(a^2 + 2 * sigma^2)
g   = 2 * phi + (a + phi) * (exp(phi * tau) - 1)
B   = (2 * (exp(phi * tau) - 1))/g
A   = 2 * a * b/sigma^2 * log(2 * phi * exp((a + phi) * tau/2)/g)

Bondprice = exp(A - B * r)
print(paste("Bond price = ", Bondprice))
