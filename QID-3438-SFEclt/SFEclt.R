# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("KernSmooth")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
p = 0.5
n = 35

# Random generation of the binomial distribution with parameters 1000*n and 0.5
bsample = rbinom(n * 1000, 1, p)  

# Create a matrix of binomial random variables
bsamplem = matrix(bsample, n, 1000) 

#Compute kernel density estimate
bden = bkde((colMeans(bsamplem) - p)/sqrt(p * (1 - p)/n))  

# Plot
plot(bden, col = "green", type = "l", lty = 1, lwd = 4, xlab = "1000 Random Samples", 
    ylab = "Estimated and Normal Density", cex.lab = 1.7, cex.axis = 2, ylim = c(0, 
        0.4))  #Plot kernel density
lines(bden$x, dnorm(bden$x), col = "red", lty = 1, lwd = 4)  
title(paste("Asymptotic Distribution, n =", n)) 
