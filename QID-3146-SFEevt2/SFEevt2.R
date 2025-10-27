# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages, install 'fExtremes' package for the Gumbel distribution
libraries = c("fExtremes", "evd")

set.seed(1234)

# global parameter settings
n = 100
y = (1:n) / (n + 1)

# choose EVT cdf for the plot header only
sel = "Weibull"
# sel = "Frechet"
# sel = "Gumbel"

if (sel == "Weibull") {
  # For Weibull in extreme value context, use negative shape in GEV representation
  # Using evd package for GEV with negative shape (Weibull type)
  x = rgev(n, loc = 0, scale = 2, shape = -4)  # Negative shape for Weibull type
} else if (sel == "Frechet") {
  # Frechet distribution (positive shape)
  x = rfrechet(n, loc = 0, scale = 1, shape = 2)
} else {
  # Gumbel distribution (zero shape)
  x = rgumbel(n, loc = 0, scale = 1)
}

# Remove any NA, NaN, or infinite values
x = x[is.finite(x)]
# Adjust y to match the length of x after removing invalid values
y = (1:length(x)) / (length(x) + 1)

# now calc the order statistics of the generated rv's
x = sort(x) 
px = pnorm(x)  # calc the probas on the standard normal scale

# First: Display the plot on screen
par(pty = "s", bg = "transparent")
plot(y, y, col = "red", type = "line", lwd = 2.5, 
     main = paste("PP Plot of Extreme Value -", sel),
     xlab = "X", ylab = "Y", xaxt = "n", yaxt = "n", 
     asp = 1, xlim = c(0, 1), ylim = c(0, 1))
axis(1, at = seq(0, 1, 0.2))
axis(2, at = seq(0, 1, 0.2))
points(px, y, col = "blue", pch = 19, cex = 0.8)

# Then: Save the plot with transparent background
png(paste0("SFEevt", sel, ".png"), 
    width = 800, height = 800, 
    bg = "transparent")  # Set background to transparent

par(pty = "s", bg = "transparent")
plot(y, y, col = "red", type = "line", lwd = 2.5, 
     main = paste("PP Plot of Extreme Value -", sel),
     xlab = "X", ylab = "Y", xaxt = "n", yaxt = "n", 
     asp = 1, xlim = c(0, 1), ylim = c(0, 1))
axis(1, at = seq(0, 1, 0.2))
axis(2, at = seq(0, 1, 0.2))
points(px, y, col = "blue", pch = 19, cex = 0.8)

dev.off()

# Message to confirm save
#cat("Plot saved as SFEevt", sel, ".png with transparent background\n", sep = "")