
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("copula")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

theta = 0.79  # Set theta [0,1]

# Variables uniformly distributed:
uniclayMVD = mvdc(claytonCopula(theta), margins = c("unif", "unif"), paramMargins = list(list(min = 0, 
    max = 1), list(min = 0, max = 1)))
uniclay = rMvdc(uniclayMVD, n = 10000)

# Variables standard normally distributed:
normclayMVD = mvdc(claytonCopula(theta), margins = c("norm", "norm"), paramMargins = list(list(mean = 0, 
    sd = 1), list(mean = 0, sd = 1)))
normclay = rMvdc(normclayMVD, n = 10000)

# Set up plotting grid
plot(uniclay, main="Uniform Marginal Distribution", xlab = "", ylab = "", cex = 0.7, pch = 19, cex.axis = 1.8)
dev.new()
plot(normclay, main="Normal Marginal Distribution", xlab = "", ylab = "", cex = 0.7, pch = 19, cex.axis = 1.8)