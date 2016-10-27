# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

x = read.table("yield_US3month9808.txt")  # load data
t = 1:dim(x)[1]  # time

# Plot
plot(t, t(x), type = "l", xlab = "Observation days", ylab = "Yield(%)", col = "blue3", 
    frame = TRUE)
abline(h = seq(0, 7, by = 1), lty = "dotted", lwd = 0.5, col = "grey")
abline(v = seq(0, 3000, by = 500), lty = "dotted", lwd = 0.5, col = "grey") 