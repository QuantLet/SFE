# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("dvfBm")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
n  = 1000
H1 = 0.2
H2 = 0.8

z1 = perturbFBM(n, H1, type = "no", SNR = NULL, plot = FALSE)
z2 = perturbFBM(n, H2, type = "no", SNR = NULL, plot = FALSE)

# Plots
par(mfrow = c(2, 1))
plot(z1, type = "l", col = "blue", xlab = "", ylab = "", cex.lab = 1.4)
plot(z2, type = "l", col = "blue", xlab = "", ylab = "", cex.lab = 1.4) 