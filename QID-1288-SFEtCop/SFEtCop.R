
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("copula")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Set up plotting grid
layout(matrix(c(1, 2, 3, 4), 2, 2, byrow = TRUE))
par(mar = c(2, 2, 2, 2))

tCop = tCopula(param = 0.2, df = 3, dim = 2)

# Create perspective plots of density and distribution
persp(tCop, dCopula, phi = 20, theta = 20, ticktype = "detailed", ylab = "", xlab = "", 
    zlab = "", shade = 0.1)
persp(tCop, pCopula, phi = 20, theta = 20, ticktype = "detailed", ylab = "", xlab = "", 
    zlab = "", shade = 0.1)

# Create contour diagrams of density and distribution
contour(tCop, dCopula)
contour(tCop, pCopula)