
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
para = c(100, 0.05, 0.03)
S0   = para[1]  # Initial Stock Price
r    = para[2]  # Interest Rate per Year
vol  = para[3]  # Volatility per Year
N    = 1000
t    = 1:N/N

volatility    = vol * vol
dt            = 1
randomWt1     = rnorm(N, 0, 1)
Wtsum1        = cumsum(t(randomWt1))
Path1         = exp((r - 0.5 * volatility) * dt + vol * sqrt(dt) * Wtsum1)
StockPath1    = matrix(0, N, 1)
StockPath1[1] = S0

for (i in 2:N) {
    StockPath1[i] = S0 * Path1[i]
}

s = StockPath1
y = matrix(0, N, 1)
y[i] = s[1]

for (i in 2:N) {
    if (s[i] > y[i - 1]) {
        y[i] = s[i]
    } else {
        y[i] = y[i - 1]
    }
}

# plot
plot(t, StockPath1, type = "l", col = "blue3", lwd = 2, ylab = "Asset Price", xlab = "", main = "Simulated process (St) vs Maximum process (Mt)")
lines(t, y, col = "red3", lty = "dotted", lwd = 2)
legend(0, max(y), c("St", "Mt"), lty = c(1, 1), lwd = 3, col = c("blue3", "red3"), 
    bg = "white")