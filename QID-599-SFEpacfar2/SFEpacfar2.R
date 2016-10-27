
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = "30"  # lag value
a1  = "0.5"  # value of alpha_1
a2  = "0.4"  # value of alpha_2

# Input alpha1
message = "      give alpha1"
default = a1
a1 = winDialogString(message, default)
a1 = type.convert(a1, na.strings = "NA", as.is = FALSE, dec = ".")

# Input alpha2
message = "      give alpha2"
default = a2
a2 = winDialogString(message, default)
a2 = type.convert(a2, na.strings = "NA", as.is = FALSE, dec = ".")

# Input lag
message = "      give lag"
default = lag
lag = winDialogString(message, default)
lag = type.convert(lag, na.strings = "NA", as.is = FALSE, dec = ".")

# Plot
plot(ARMAacf(ar = c(a1, a2), ma = numeric(0), lag.max = lag, pacf = TRUE), type = "h", 
    xlab = "lag", ylab = "pacf")
title("Sample partial autocorrelation function (pacf)")