
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# fix pseudo random numbers for reproducibility
set.seed(-1)

# interactive user input, e.g. (100, 0.05, 0.03, 25)
print("Please input Stock's Initial Price S0, Interest Rate per Year r,")
print("Volatility per year vol and Value of the barrier b")
print("For instance: s0 = 100 0.05 0.03 25")
print("Then press enter 2 times")
para = scan()

while (length(para) < 4 | length(para) > 4 | any(para <= 0)) {
    print("Not enough input arguments. Please input in 1*4 vector form like 100 0.05 0.03 25")
    print("[# of observations, beta, gamma, barrier]=")
    para = scan()
}

S0  = para[1]  # Initial Stock Price
r   = para[2]  # Interest Rate per Year
vol = para[3]  # Volatility per Year
b   = para[4]  # Barrier

N = 1000
t = (1:N)/N
volatility = vol * vol
dt = 1

# Random walk simulation
randomWt1 = rnorm(N, 0, 1)
randomWt2 = rnorm(N, 0, 1)
Wtsum1 = cumsum(randomWt1)
Wtsum2 = cumsum(randomWt2)

# geometric brownian motion
Path1 = exp((r - 0.5 * volatility) * dt + vol * sqrt(dt) * Wtsum1)
Path2 = exp((r - 0.5 * volatility) * dt + vol * sqrt(dt) * Wtsum2)
StockPath1 = matrix(0, N, 1)
StockPath2 = matrix(0, N, 1)
StockPath1[1] = S0
StockPath2[1] = S0

for (i in 2:N) {
    StockPath1[i] = S0 * Path1[i]
    StockPath2[i] = S0 * Path2[i]
}

# plot
plot(t, rep(b, length(t)), col = "black", lwd = 2, ylab = "Asset Price", type = "l", ylim = c(min(c(StockPath1, StockPath2, b)), max(c(StockPath1, StockPath2, b))))

lines(t, StockPath1, col = "blue", lwd = 2)
lines(t, StockPath2, col = "blue", lwd = 2)
end = length(t)

h = which(StockPath1 < b)[1]
if (is.na(h) == F) {
    lines(t[h:end], StockPath1[h:end], col = "red", lwd = 2)
}

hh = which(StockPath2 < b)[1]
if (is.na(hh) == F) {
    lines(t[hh:end], StockPath2[hh:end], col = "red", lwd = 2)
}
