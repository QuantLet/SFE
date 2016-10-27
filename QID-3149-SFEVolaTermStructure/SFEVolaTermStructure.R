
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
x = read.table("implvola.dat")

# rescale
x = x/100

dat1 = cbind(c(1:8), t(x[11, ]))
dat2 = cbind(c(1:8), t(x[31, ]))
dat3 = cbind(c(1:8), t(x[111, ]))
dat4 = cbind(c(1:8), t(x[231, ]))

a = seq(0.12, to = 0.19, length.out = 8)
plot(a, type = "n", main = "Term Structure", xlab = "Time", ylab = "Percentage [%]", ylim = c(0.1, 0.2))
lines(dat1, col = 4, type = "l", lwd = 2)
lines(dat2, col = 3, type = "l", lwd = 2)
lines(dat3, col = 5, type = "l", lwd = 2)
lines(dat4, col = 2, type = "l", lwd = 2) 
