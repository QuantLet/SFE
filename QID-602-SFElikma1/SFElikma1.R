
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
n    = "10"
beta = "0.5"

# Input n
message = "Please specify n"
default = n
n = winDialogString(message, default)
n = type.convert(n, na.strings = "NA", as.is = FALSE)

# Input moving average coefficient
message = "Please specify MA-component"
default = beta
beta = winDialogString(message, default)
beta = type.convert(beta, na.strings = "NA", as.is = FALSE, dec = ".")

# Simulation of MA(1)-processes as the true values
x = arima.sim(n, model = list(ar = 0, d = 0, ma = beta), rand.gen = function(n) rnorm(n, 
    0, 1))
x = as.matrix(x)

# Estimated values for beta
k = 19
theta = seq(-0.9, by = 0.1, 0.9)

l1 = matrix(1, k, 1)
l2 = l1

for (i in 1:k) {
    b = theta[i]  # beta estimate [i]
    g = diag((b^2 + 1), n, n)
    h1 = diag(b, n - 1, n - 1)
    h = cbind(rbind(0, h1), 0)
    g = g + h + t(h)  # Covariance matrix
    l1[i] = -(n/2) * log(2 * pi) - 0.5 * log(det(g)) - 0.5 * t(x) %*% solve(g) %*% 
        x  # exact Log likelihood 
    arcoeff = (-b)^(1:(n - 1))  # coefficients of AR(1) process for lag=2:10
    e = matrix(1, n, 1)
    
    # Approximation of errors
    e[1] = x[1]
    for (t in 2:10) {
        e[t] = x[t] + sum(t(arcoeff[1:(t - 1)]) * x[(t - 1):1])
    }
    l2[i] = -(n/2) * log(2 * pi) - 0.5 * sum(e^2)  # Conditional log likelihood
}

# Plots
dat1 = cbind(theta, l1)
plot(dat1, col = 4, xlab = "Beta", ylab = "log-Likelihood", main = "likelihood function of an MA(1) Process", 
    type = "l", lwd = 2)
dat2 = cbind(theta, l2)
points(dat2, type = "l", col = 2, lty = 2, lwd = 2)