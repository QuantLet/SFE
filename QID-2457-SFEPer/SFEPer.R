
# install and load packages
libraries = c("astsa")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# attach data
data(soi)

# Time domain
par(mfrow=c(1, 1))
plot(soi, type="l", col ="blue3")

par(mfrow=c(2,1))
acf(soi,  xlab = "Lag Time", lwd = 4, main = "")
pacf(soi, xlab = "Lag Time", ylab = "PACF", lwd = 4, main = "")

# Frequency domain
par(mfrow = c(1, 1))
soi.per = spec.pgram(soi, taper = 0, log = "no", col = "red3", lwd = 4, main = "", sub = "",
                     ylab = "Spectrum", xlab = "Frequency")
abline(v = 1/12, lty = "dotted")
abline(v = 1/48, lty = "dotted")
