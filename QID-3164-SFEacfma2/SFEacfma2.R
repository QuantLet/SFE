
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag	= 30	# lag value
b1	= 0.5	# value of beta_1
b2	= 0.4	# value of beta_2

par(mfrow = c(2, 2))

plot(ARMAacf(ar = numeric(0), ma = c(b1, b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF")

plot(ARMAacf(ar = numeric(0), ma = c(b1, -b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF")

plot(ARMAacf(ar = numeric(0), ma = c(-b1, b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF")

plot(ARMAacf(ar = numeric(0), ma = c(-b1, -b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF") 
