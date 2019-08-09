# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("gplots")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Main computation
y   = seq(1, 2, 0.1)
b   = 0.332672527
a1  = 0.17401209
a2  = -0.04793922
a3  = 0.373927817
t   = 1/(1 + b * y)
phi = 1 - (a1 * t + a2 * t^2 + a3 * t^3) * exp(-y * y/2)

# Output
print("Estimation Points")
print(y)
print("Estimated Normal CDF")
print(phi)

# Plot
par(mfrow = c(1, 2))
plot(y, phi, lwd = 2, type = "o", xlab = "x", ylab = "cdf", main = "Approximation of normal cdf a", 
    col = "blue3")
textplot(cbind(y, phi)) 