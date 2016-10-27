# install and load packages
libraries = c("astsa")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# attach data
data(soi)

# Time domain
par(mfrow = c(1, 2))
plot.ts(diff(soi), col = "blue", lwd = 3, ylab = expression(S[t])) # plot 1st difference of soi data
k    = kernel("modified.daniell", 6)                               # 12 month filter
MA12 = kernapply(soi, k)
plot.ts(MA12, col = "magenta", lwd = 3, ylab = expression(S[t]))

# Frequency domain
spectrum(soi,log = "no", main = "", col = "magenta", lwd = 3)		
abline(v = 1 / 12, lty = "dotted")
abline(v = 1 / 48, lty = "dotted")

spectrum(MA12, spans = 9, log = "no", main = "", col = "blue", lwd = 3) 
abline(v = 1 / 52, lty = "dotted")
