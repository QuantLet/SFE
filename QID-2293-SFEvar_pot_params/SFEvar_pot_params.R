
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
beta = t(read.table("beta0012_pot_Portf.dat"))
ksi  = t(read.table("ksi0012_pot_Portf.dat"))
u    = t(read.table("u0012_pot_Portf.dat"))

# Plot the shape, scale and treshold parameter.
plot(beta, type = "l", lwd = 2, col = "blue", ylim = c(-1, 17), ylab = c(""), xlab = c(""), 
    axes = FALSE)
lines(ksi, col = "red", lwd = 2)
lines(u, col = "magenta", lwd = 2)
title("Parameters in Peaks Over Threshold Model")
box()
axis(1, seq(0, length = 8, by = 500), seq(2000, 2014, by = 2))
axis(2)
legend("topleft", c("Scale Parameter", "Shape Parameter", "Threshold"), pch = c(15, 
    15, 15), col = c("blue", "red", "magenta"))