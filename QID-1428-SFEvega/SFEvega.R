
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("lattice")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
S_min   = 50          # lower bound of Asset Price
S_max   = 150         # upper bound of Asset Price 
tau_min = 0.01        # lower bound of Time to Maturity
tau_max = 1           # upper bound of Time to Maturity
K       = 100         # exercise price 
r       = 0           # interest rate
sig     = 0.25        # volatility
d       = 0           # dividend rate
b       = r - d       # cost of carry
steps   = 60          # steps

meshgrid = function(a, b) {
    list(x = outer(b * 0, a, FUN = "+"), y = outer(b, a * 0, FUN = "+"))
}
first = meshgrid(seq(tau_min, tau_max, (tau_max - tau_min)/(steps - 1)), seq(tau_min, 
    tau_max, (tau_max - tau_min)/(steps - 1)))

tau    = first$x
dump   = first$y
second = meshgrid(seq(S_max, S_min, -(S_max - S_min)/(steps - 1)), seq(S_max, S_min, 
    -(S_max - S_min)/(steps - 1)))

dump2 = second$x
S     = second$y

d1   = (log(S/K) + (r - d - sig^2/2) * tau)/(sig * sqrt(tau))
Vega = S * exp(-d * tau) * dnorm(d1) * sqrt(tau)

# Plot
title = bquote(expression(paste("Strike price is ", .(K), ", interest rate is ", 
    .(r), ", dividend rate is ", .(d), ", annual volatility is ", .(sig))))
wireframe(Vega ~ tau * S, drape = T, ticktype = "detailed", main = expression(paste("Vega as function of the time to maturity ", 
    tau, " and the asset price S")), sub = title, scales = list(arrows = FALSE, 
    col = "black", distance = 1, tick.number = 8, cex = 0.7, x = list(labels = round(seq(tau_min, 
        tau_max, length = 11), 1)), y = list(labels = round(seq(S_min, S_max, length = 11), 
        1))), xlab = list(expression(paste("Time to Maturity  ", tau)), rot = 30, 
    cex = 1.2), ylab = list("Asset Price S", rot = -40, cex = 1.2), zlab = list("Vega", 
    cex = 1.1))
