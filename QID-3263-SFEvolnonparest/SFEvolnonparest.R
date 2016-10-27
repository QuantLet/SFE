
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fGarch", "tseries", "pracma")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
DS  = read.table("FSE_LSE.dat")
D   = DS[, 1]                     # date
S   = DS[, 2:43]                  # S(t)
s   = log(S)                      # log(S(t))
end = nrow(s)
r   = s[-1, ] - s[1:(end - 1), ]  # r(t)
n   = nrow(r)                     # sample size
t   = 1:n                         # time index, t

rdax  = r[, 1]                    # DAX returns
rftse = r[, 22]                   # FTSE 100 returns

# Nonparametric volatility estimation, DAX
end1 = nrow(r)
y    = cbind(r[1:(end1 - 1), 1], r[-1, 1])
yy   = cbind(y[, 1], y[, 2]^2)
hm   = 0.04  # bandwidth
hs   = 0.04  # bandwidth
X    = y[, 1]
Y    = y[, 2]
p    = 1
h    = hm

# compute quadratik kernel
quadk = function(x) {
    # Usage : y = quadk(x); Returns: y = (15/16).*(x.*x.<1).*(1- x.*x).^2 ) ;
    I = as.numeric(x * x < 1)
    x = x * I
    y = (15/16) * I * (1 - x * x)^2
    return(y)
}

lpregest = function(X, Y, p, h) {
    n    = length(X)
    x    = seq(min(X), max(X), (max(X) - min(X))/(100))  # grid
    m    = length(x)
    bhat = matrix(0, p + 1, m)
    for (i in 1:m) {
        dm = matrix(1, n, 1)
        dd = NULL
        xx = X - x[i]
        if (p > 0) {
            for (j in 1:p) {
                dm = cbind(dm, (xx)^j)
            }
        }
        w  = diag(quadk(xx/h)/h)
        mh = solve(t(dm) %*% w %*% dm) %*% t(dm) %*% w
        bhat[, i] = mh %*% Y
    }
    return(list(bhat, x))
}

first   = lpregest(y[, 1], y[, 2], 1, hm)    # estimate conditional mean function
m1h     = first[[1]]
yg      = first[[2]]
second  = lpregest(yy[, 1], yy[, 2], 1, hs)  # estimate conditional second moment 
m2h     = second[[1]]
yg      = second[[2]]
sh      = rbind(yg, m2h[1, ] - m1h[1, ]^2)   # conditional variance
m1hx    = interp1(yg, m1h[1, ], y[, 1])      # interpolate mean
shx_DAX = interp1(yg, sh[2, ], y[, 1])       # interpolate variance

# plot
par(mfrow = c(2, 1))
plot(shx_DAX^0.5, type = "l", col = "blue3", lwd = 0.7, xlab = "", ylab = "", frame = T, 
    axes = F, ylim = c(0.01, 0.033))
axis(1, seq(0, 3000, 500), seq(0, 3000, 500))
axis(2, seq(0, 0.04, 0.01), seq(0, 0.04, 0.01))
title("DAX")

# Nonparametric volatility estimation, FTSE 100
y = cbind(r[1:(end1 - 1), 22], r[2:end1, 22])
yy = cbind(y[, 1], y[, 2]^2)
hm = 0.04  # bandwidth
hs = 0.04  # bandwidth
first = lpregest(y[, 1], y[, 2], 1, hm)     # estimate conditional mean function
m1h = first[[1]]
yg = first[[2]]
second = lpregest(yy[, 1], yy[, 2], 1, hs)  # estimate conditional second moment 
m2h = second[[1]]
yg = second[[2]]
sh = rbind(yg, m2h[1, ] - m1h[1, ]^2)       # conditional variance
m1hx = interp1(yg, m1h[1, ], y[, 1])        # interpolate mean
shx_FTSE = interp1(yg, sh[2, ], y[, 1])     # interpolate variance

# plot
plot(shx_FTSE^0.5, type = "l", col = "blue3", lwd = 0.7, xlab = "Time, t", ylab = "", 
    frame = T, axes = F, ylim = c(0.01, 0.033))
axis(1, seq(0, 3000, 500), seq(0, 3000, 500))
axis(2, seq(0, 0.04, 0.01), seq(0, 0.04, 0.01))
title("FTSE 100")
