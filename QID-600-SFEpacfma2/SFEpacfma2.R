
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = "30"  # lag value
b1  = "0.5"  # value of beta_1
b2  = "0.4"  # value of beta_2

# Input beta_1
message = "      give beta1"
default = b1
b1 = winDialogString(message, default)
b1 = type.convert(b1, na.strings = "NA", as.is = FALSE, dec = ".")

# Input beta_2
message = "      give beta2"
default = b2
b2 = winDialogString(message, default)
b2 = type.convert(b2, na.strings = "NA", as.is = FALSE, dec = ".")

# Input lag
message = "      give lag"
default = lag
lag = winDialogString(message, default)
lag = type.convert(lag, na.strings = "NA", as.is = FALSE, dec = ".")

# Plot
plot(ARMAacf(ar = numeric(0), ma = c(b1, b2), lag.max = lag, pacf = TRUE), type = "h", 
    xlab = "lag", ylab = "pacf")
title("Sample partial autocorrelation function (pacf)")

