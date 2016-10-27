# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

SFEWienerProcess = function(dt, c, k) {
    k 	= floor(k)             # makes sure number of path is integer
    if (dt <= 0 | k <= 0) {
        stop("Delta t and number of trajectories must be larger than 0!")
    }
    l 	= 100
    n 	= floor(l/dt)
    t 	= seq(0, n * dt, by = dt)
    set.seed(0)
    z 	= matrix(runif(n * k), n, k)
    z 	= 2 * (z > 0.5) - 1     # scale to -1 or 1
    z 	= z * c * sqrt(dt)      # to get finite and non-zero variance
    zz 	= apply(z, MARGIN = 2, FUN = cumsum)
    x 	= rbind(rep(0, k), zz)
    # Output
    matplot(x, lwd = 2, type = "l", lty = 1, ylim = c(min(x), max(x)), col = 2:(k + 
        1), main = "Wiener process", xlab = "Time t", ylab = expression(paste("Values of process ", X[t], " delta")))
}

SFEWienerProcess(dt = 0.5, c = 1, k = 5) 
