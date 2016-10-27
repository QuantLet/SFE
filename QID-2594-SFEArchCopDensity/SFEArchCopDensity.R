
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

# Initialize copulas
frank.cop   = frankCopula(param = 8, dim = 2)
gumbel.cop  = gumbelCopula(param = 1.5, dim = 2)
amh.cop     = amhCopula(param = 0.9, dim = 2)
clayton.cop = claytonCopula(param = 0.9, dim = 2)

# Create perspective plots of densities
persp(frank.cop, dCopula, phi = 20, theta = 20, ticktype = "detailed", ylab = "", 
    xlab = "", zlab = "", shade = 0.1)
persp(gumbel.cop, dCopula, phi = 20, theta = 20, ticktype = "detailed", ylab = "", 
    xlab = "", zlab = "", shade = 0.1)
persp(amh.cop, dCopula, phi = 20, theta = 20, ticktype = "detailed", ylab = "", 
    xlab = "", zlab = "", shade = 0.1)
persp(clayton.cop, dCopula, phi = 20, theta = 20, ticktype = "detailed", ylab = "", 
    xlab = "", zlab = "", shade = 0.1)