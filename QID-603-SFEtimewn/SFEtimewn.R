
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

x = rnorm(1000)  # Generate random normal distributed variable
plot(x, main = "Gaussian White Noise", type = "l")  # Plot