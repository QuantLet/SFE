# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("lattice")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Black-Scholes Function
BS = function(S, K, Time, r, sig, type) {
    d1 = (log(S/K) + (r + sig^2/2) * Time)/(sig * sqrt(Time))
    d2 = d1 - sig * sqrt(Time)
    if (type == 1) {
        value = S * pnorm(d1) - K * exp(-r * Time) * pnorm(d2)
    }
    if (type == 0) {
        value = K * exp(-r * Time) * pnorm(-d2) - S * pnorm(-d1)
    }
    return(value)
}

# Function to find BS Implied Volatility using Bisection Method
blsimpv = function(S, K, Time, r, market, type) {
    sig      = 0.2
    sig.up   = 1
    sig.down = 0.001
    count    = 0
    err      = BS(S, K, Time, r, sig, type) - market
    
    # repeat until error is sufficiently small or counter hits 1000
    while (abs(err) > 1e-05 && count < 1000) {
        if (err < 0) {
            sig.down = sig
            sig = (sig.up + sig)/2
        } else {
            sig.up = sig
            sig = (sig.down + sig)/2
        }
        err   = BS(S, K, Time, r, sig, type) - market
        count = count + 1
    }
    
    # return NA if counter hit 1000
    if (count == 1000) {
        return(NA)
    } else {
        return(sig)
    }
}

# load data
x = read.table("volsurfdata2.dat")

# define variables
x[, 7] = x[, 1]/x[, 2]  # define moneyness
Price  = x[, 1]
Strike = x[, 2]
Rate   = x[, 3]
Time   = x[, 4]
Value  = x[, 5]
Class  = x[, 6]
mon    = x[, 7]
n      = length(x[, 1])

# calculate implied volatility
iv = rep(0, n)
for (i in 1:n) {
    iv[i] = blsimpv(S = Price[i], K = Strike[i], Time = Time[i], r = Rate[i], market = Value[i], 
        type = Class[i])
}

firstmon = 0.8
lastmon  = 1.2
firstmat = 0
lastmat  = 1

stepwidth = c(0.02, 1/52)
lengthmon = ceiling((lastmon - firstmon)/stepwidth[1])
lengthmat = ceiling((lastmat - firstmat)/stepwidth[2])

mongrid   = seq(0.8, 1.2, length = c(lengthmon + 1))
matgrid   = seq(0, 1, length = c(lengthmat + 1))

# grid function
meshgrid  = function(a, b) {
    list(x = outer(b * 0, a, FUN = "+"), y = outer(b, a * 0, FUN = "+"))
}

# compute grid
gridone = meshgrid(mongrid, matgrid)

MON  = gridone$x
MAT  = gridone$y

gmon = lengthmon + 1L
gmat = lengthmat + 1L
uu   = dim(x)
v    = uu[1]

# calculate the implied volatility surface
beta = matrix(0, gmat, gmon)
j    = 1L
while (j < gmat + 1L) {
    k = 1L
    while (k < gmon + 1L) {
        i = 1L
        X = matrix(0, v, 3)
        while (i < (v + 1L)) {
            X[i, ] = c(1, x[i, 7] - MON[j, k], x[i, 4] - MAT[j, k])
            i = i + 1
        }
        Y  = iv
        h1 = 0.1
        h2 = 0.75
        W  = matrix(0, v, v)  # Kernel matrix
        i  = 1L
        while (i < (v + 1L)) {
            u1      = (x[i, 7] - MON[j, k])/h1
            u2      = (x[i, 4] - MAT[j, k])/h2
            aa      = 15/16 * (1 - u1^2)^2 %*% (abs(u1) <= 1)/h1
            bb      = 15/16 * (1 - u2^2)^2 %*% (abs(u2) <= 1)/h2
            W[i, i] = aa %*% bb
            i = i + 1L
        }
        est         = solve(t(X) %*% W %*% X) %*% t(X) %*% W %*% Y
        beta[j, k]  = est[1]
        k = k + 1L
    }
    j = j + 1L
}
IV = beta

# select points for elimination
ex1  = which(x[, 4] > 1)  	# Time to maturity > 1
ex2  = which(x[, 7] < 0.8 | x[, 7] > 1.2)  # moneyness < 0.8 or > 1.2
ex   = c(ex1, ex2)

xnew = x
xnew = xnew[-ex, ]  			# eliminate data points

# redefine variables
Price  = xnew[, 1]
Strike = xnew[, 2]
Rate   = xnew[, 3]
Time   = xnew[, 4]
Value  = xnew[, 5]
Class  = xnew[, 6]
mon    = xnew[, 7]
n      = length(xnew[, 1])

# calculate implied volatility for original options
iv = rep(0, n)
for (i in 1:n) {
    iv[i] = blsimpv(Price[i], Strike[i], Time[i], Rate[i], Value[i], Class[i])
}

# define points
pts = cbind(mon, Time, iv)

# plot
wireframe(IV ~ MON + MAT, drape = T, ticktype = "detailed", pts = pts, main = "", 
    aspect = c(1, 1), scales = list(arrows = FALSE, y = list(labels = seq(0, 1, 0.2)), 
        x = list(labels = seq(0.8, 1.4, 0.1)), z = list(labels = seq(0.2, 0.5, 0.05))), 
    ylab = list("Time to Maturity", rot = -38), xlab = list("Moneyness", rot = 33), 
    zlab = list("Implied Volatility", rot = 94), zlim = c(0.25, 0.45), panel.3d.wireframe = function(x, 
        y, z, xlim, ylim, zlim, xlim.scaled, ylim.scaled, zlim.scaled, pts, drape = drape, 
        ...) {
        panel.3dwire(x, y, z, xlim = xlim, ylim = ylim, zlim = zlim, xlim.scaled = xlim.scaled, 
            ylim.scaled = ylim.scaled, zlim.scaled = zlim.scaled, drape = TRUE, ...)
        
        panel.3dscatter(pts[, 1], pts[, 2], pts[, 3], xlim = xlim, ylim = ylim, zlim = zlim, 
            xlim.scaled = xlim.scaled, ylim.scaled = ylim.scaled, zlim.scaled = zlim.scaled, 
            type = "p", col = c(4), lwd = 3, cex = 1, pch = c(19), .scale = TRUE, 
            ...)
    }) 