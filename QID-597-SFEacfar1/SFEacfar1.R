
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings, you might want to change these, check also the ACF if you enter e.g. a = -0.9
lag = 30  # lag value
a   = 0.9  # value of alpha_1

# Plot
plot(ARMAacf(ar = a, ma = numeric(0), lag.max = lag, pacf = FALSE), type = "h", 
    xlab = "lag", ylab = "acf")
title("Sample autocorrelation function (acf)")
