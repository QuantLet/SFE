# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

USY  = read.table("USY.txt")		# load data
time = c(seq(1/12, 1/2, by = 1/12), seq(4/6, 1, by = 1/6), seq(1.25, 2, by = 1/4), 
    seq(2.5, 4, by = 1/2), seq(5, 10, by = 1))
yc   = USY[NROW(USY), 1:23]

# Plot
plot(time, t(yc), type = "l", lty = 3, lwd = 2.5, col = "blue3", xlab = "Time to Maturity", 
    ylab = "Yield")
points(time, t(yc), col = "blue3", pch = 19, cex = 1.3) 