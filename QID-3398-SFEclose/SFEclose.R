# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

x1 = read.table("BAYER_close_0012.dat")
x2 = read.table("BMW_close_0012.dat")
x3 = read.table("SIEMENS_close_0012.dat")
x4 = read.table("VW_close_0012.dat")

x1 = as.matrix(x1)
x2 = as.matrix(x2)
x3 = as.matrix(x3)
x4 = as.matrix(x4)

t = seq(23, dim(x1)[1], by = 261)

plot(x3, type = "l", ylim = c(min(x1, x2, x3, x4), max(x1, x2, x3, x4)), col = "blue3", xlab = "", 
    ylab = "", main = "Closing Prices for German Companies", xaxt = "n")
lines(x1, lty = 2)
lines(x2, col = "red3", lty = 3)
lines(x4, col = "darkgreen", lty = 4)
axis(1, at = t, labels = seq(2000, 2012, 1)) 