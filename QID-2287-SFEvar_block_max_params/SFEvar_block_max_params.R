
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
k = t(read.table("kappa0012_bMax_Portf.dat"))
a = t(read.table("alpha0012_bMax_Portf.dat"))
b = t(read.table("beta0012_bMax_Portf.dat"))

# Plot the shape, scale and location parameter.
plot(k, type = "l", col = "blue", ylim = c(-1, 20), ylab = c(""), xlab = c(""), 
    axes = FALSE)
lines(a, col = "red")
lines(b, col = "magenta")
title("Parameters in Block Maxima Model")
box()
axis(1, seq(0, length = 8, by = 500), seq(2000, 2014, by = 2))
axis(2)
legend("topleft", c("Shape Parameter", "Scale Parameter", "Location Parameter"), 
    pch = c(15, 15, 15), col = c("blue", "red", "magenta"))