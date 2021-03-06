
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("stats")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
n1   = 10
n2   = 20
beta = 0.5

# Simulation of MA(1)-processes
x1 = arima.sim(n1, model = list(ar = 0, d = 0, ma = beta), rand.gen = function(n1) rnorm(n1, 
    0, 1))
x2 = arima.sim(n2, model = list(ar = 0, d = 0, ma = beta), rand.gen = function(n2) rnorm(n2, 
    0, 1))

x1 = as.matrix(x1)
x2 = as.matrix(x2)

# Plot
par(mfrow = c(2, 1))

par(mfg = c(1, 1))
plot(x1, type = "l", lwd = 2, xlab = "x", ylab = "y")
title(paste("MA(1) Process, n =", n1))

par(mfg = c(2, 1))
plot(x2, type = "l", lwd = 2, xlab = "x", ylab = "y")
title(paste("MA(1) Process, n =", n2))
