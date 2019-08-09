# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Main computation
x  = seq(0, 1, by = 0.01)
y1 = pnorm((qnorm(x) - sqrt(0.2) * (-3))/(sqrt(0.8)))
y2 = pnorm((qnorm(x) - sqrt(0.2) * (0))/(sqrt(0.8)))
y3 = pnorm((qnorm(x) - sqrt(0.2) * (3))/(sqrt(0.8)))

# Plot
plot(x, y1, col = "blue", type = "l", xlab = "Probability Default", ylab = "p(y)", lwd = 2.5)
lines(x, y2, col = "black", lty = 2, lwd = 2.5)
lines(x, y3, col = "red", lty = 4, lwd = 2.5)
legend(0.8, 0.2, c("y=-3", "y=0", "y=3"), col = c("blue", "black", "red"), lty = c(1, 2, 4)) 