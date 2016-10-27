
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fExtremes")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

data = read.table("SFEVaRbank.dat")

x = matrix(data[, 2])
v = matrix(1.96 * data[, 4])
t = matrix(1:nrow(x))

dat  = matrix(c(t, x), ncol = 2)
dat2 = matrix(c(t, v), ncol = 2)
dat3 = matrix(c(t, -v), ncol = 2)

# Plot part 1
par(c(1, 1), cex = 1.2)
plot(dat, col = "yellow", type = "p", ylab = "Y", xlab = "X", cex = 1.2, lwd = 2)
lines(dat2, col = "blue", lwd = 2)
lines(dat3, col = "blue", lwd = 2)
title("VaRs and Exceptions (1994-1995)")

dat94 = matrix(dat[1:260, 1:2], ncol = 2)
(exceed94 = matrix(dat94[(dat94[, 2] > dat2[1:260, 2]) | (dat94[, 2] < dat3[1:260, 2])], ncol = 2))
points(exceed94, col = "red", cex = 1.2, lwd = 2)

dat95 = matrix(dat[260:nrow(x), 1:2], ncol = 2)
(exceed95 = matrix(dat95[(dat95[, 2] > dat2[260:nrow(x), 2]) | (dat95[, 2] < dat3[260:nrow(x), 2])], ncol = 2))
points(exceed95, col = "black", cex = 1.2, lwd = 2)

# VaR with method: RMA rectangular moving average
VaRrma = function(y, h, alpha) {
    y    = as.matrix(y)
    w    = 1
    n    = nrow(y)
    d    = ncol(y)
    w    = w * matrix(1, 1, d)
    sigh = matrix(0, n - h, 1)
    tmp  = cumsum(y^2)
    wtr  = t(w)
    tmp  = (tmp[(h + 1):n] - tmp[1:(n - h)])/h
    tmp  = as.matrix(tmp)
    sigh = sqrt(tmp)
    qf   = qnorm(alpha)
    qf   = matrix(qf, nrow = nrow(sigh), 1)
    VaR  = qf * sigh
    VaR  = cbind(VaR, (-VaR))
    VaR  = VaR
}

# VaR with method: EMA exponential moving average
VaRema = function(y, h, alpha) {
    lam  = 0.96
    dist = 0
    y    = as.matrix(y) # w = 1
    n    = nrow(y)
    d    = ncol(y)      # w = w*matrix(1,1,d)
    grid = seq((h - 1), 0, -1)
    sigh = matrix(0, n - h, 1)
    j    = h
    while (j < n) {
        j           = j + 1
        tmp         = (lam^grid) * y[(j - h):(j - 1)]
        tmp1        = sum(tmp * tmp)
        sigh[j - h] = sqrt(sum(sum(tmp1), 2) * (1 - lam))
    }
    qf  = qnorm(alpha)
    qf  = matrix(qf, nrow = nrow(sigh), 1)
    VaR = qf * sigh
    VaR = cbind(VaR, (-VaR))
    VaR = VaR
} 

# Plot part 2
# VaR EMA (red solid lines)
y = x
h = 250
alpha = 0.01
VaRe  = VaRema(y, h, alpha)

VaR1 = matrix(c(251:nrow(x), VaRe[(1:270), 1]), ncol = 2)
VaR2 = matrix(c(251:nrow(x), VaRe[(1:270), 2]), ncol = 2)
lines(VaR1, col = "red", lwd = 2)
lines(VaR2, col = "red", lwd = 2)

# VaR RMA (green dashed lines)
y = x
h = 250
alpha = 0.01
vrma  = VaRrma(y, h, alpha)

VaR1 = matrix(c(251:nrow(x), vrma[(1:270), 1]), ncol = 2)
VaR2 = matrix(c(251:nrow(x), vrma[(1:270), 2]), ncol = 2)
points(VaR1, col = "green", type = "l", lty = "dashed", lwd = 2)
points(VaR2, col = "green", type = "l", lty = "dashed", lwd = 2) 
