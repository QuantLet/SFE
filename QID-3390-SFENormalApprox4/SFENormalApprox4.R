rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("gplots")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# main computation
y   = seq(1, 2, 0.1)   # estimation points
k   = 10               # order number 
n   = 0
sum	= 0
while (n < (k + 1)) {
    sum = sum + ((-1)^n) * y^(2 * n + 1)/(factorial(n) * 2^n * (2 * n + 1))
    n	= n + 1
}
phi = 0.5 + sum/sqrt(2 * pi)

# output
print("Estimation Points")
print(y)
print("Estimated Normal CDF")
print(phi)

# plot
par(mfrow = c(1, 2))
plot(y, phi, lwd = 2, xlab = "x", type = "o", ylab = "cdf", main = "Approximation to normal cdf d", col = "blue3")
textplot(cbind(y, phi)) 