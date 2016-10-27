# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag = "30"      # lag value
b   = "0.5"     # value of beta_1

# Input beta_1
message = "      input beta"
default = b
b       = winDialogString(message, default)
b       = type.convert(b, na.strings = "NA", as.is = FALSE, dec = ".")

# Input lag value
message = "      input lag"
default = lag
lag     = winDialogString(message, default)
lag     = type.convert(lag, na.strings = "NA", as.is = FALSE, dec = ".")

# Plot
plot(ARMAacf(ar = numeric(0), ma = b, lag.max = lag, pacf = FALSE), type = "h", xlab = "lag", 
    ylab = "acf")
title("Sample autocorrelation function (acf)") 
