# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Read data for FSE and LSE
DS  = read.table("FSE_LSE.dat")
D   = DS[, 1]                       # date
S   = DS[, 2:43]                    # S(t)
s   = log(S)                        # log(S(t))
n1  = dim(s)						
end = n1[1]                         # end of sample
r   = s[-1, ] - s[1:(end - 1), ]    # r(t)
n   = dim(r)[1]                     # sample size
t   = 1:n                           # time index, t

# Labels
time      = strptime(D, format = "%Y%m%d")
labels    = as.numeric(format(as.Date(time, "%Y-%m-%d"), "%Y"))
where.put = c(1, which(diff(labels) == 1) + 1)

# Time series plot of the DAX daily returns
par(mfrow = c(2, 1))
plot(1:n, r[, 1], main = "DAX return", xlab = "Time, t", ylab = "r(t)", frame = TRUE, 
    axes = FALSE, col = "blue3", ylim = c(-0.1, 0.1), type = "l", cex.lab = 1)
axis(side = 2, at = seq(-0.1, 0.1, by = 0.05), label = seq(-0.1, 0.1, 0.05), 
    lwd = 1, cex.axis = 1)
axis(side = 1, at = where.put, label = labels[where.put], lwd = 0.5, cex.axis = 1)
abline(h = seq(-0.1, 0.1, by = 0.025), lty = "dotted", lwd = 0.5, col = "grey")
abline(v = where.put, lty = "dotted", lwd = 0.5, col = "grey")

# Time series plots of the FTSE 100 daily returns
plot(1:n, r[, 22], main = "FTSE 100 return", xlab = "Time, t", ylab = "r(t)", 
    frame = TRUE, axes = FALSE, col = "blue3", ylim = c(-0.06, 0.06), type = "l", 
    cex.lab = 1)
axis(side = 2, at = seq(-0.06, 0.06, by = 0.02), label = seq(-0.06, 0.06, by = 0.02), 
    lwd = 1, cex.axis = 1)
axis(side = 1, at = where.put, label = labels[where.put], lwd = 0.5, cex.axis = 1)
abline(h = seq(-0.1, 0.1, by = 0.025), lty = "dotted", lwd = 0.5, col = "grey")
abline(v = where.put, lty = "dotted", lwd = 0.5, col = "grey") 