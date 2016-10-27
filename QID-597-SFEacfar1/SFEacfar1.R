
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = "30"  # lag value
a   = "0.9"  # value of alpha_1

# Input alpha_1
message = "      give alpha"
default = a
a = winDialogString(message, default)
a = type.convert(a, na.strings = "NA", as.is = FALSE, dec = ".")

# Input lag value
message = "      give lag"
default = lag
lag = winDialogString(message, default)
lag = type.convert(lag, na.strings = "NA", as.is = FALSE, dec = ".")

# Plot
plot(ARMAacf(ar = a, ma = numeric(0), lag.max = lag, pacf = FALSE), type = "h", 
    xlab = "lag", ylab = "acf")
title("Sample autocorrelation function (acf)")