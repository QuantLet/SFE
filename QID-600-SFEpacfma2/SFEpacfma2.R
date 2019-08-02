# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = 30  # lag value
b1  = 0.5  # value of beta_1
b2  = 0.4  # value of beta_2

# Plot
plot(ARMAacf(ar = numeric(0), ma = c(b1, b2), lag.max = lag, pacf = TRUE), type = "h", 
    xlab = "lag", ylab = "pacf")
title("Sample partial autocorrelation function (pacf)")
