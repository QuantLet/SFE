rm(list = ls(all = TRUE))
graphics.off()

# specify parameter values:
n     = 100  # no. of observations
beta  = 0.1  # beta parameter
gamma = 0.01 # gamma parameter
m     = 1    # mean

# simulates a mean reverting square root process around  mean m
i     = 0
delta = 0.1
x     = m  #start value

while (i < (n * 10)) {
    i = i + 1
    d = beta * (m - x[length(x)]) * delta + gamma * sqrt(delta * abs(x[length(x)])) * rnorm(1, mean = 0, sd = 1)
    x = rbind(x, x[length(x)] + d)
}
x = x[2:length(x)]
x = x[10 * seq(1, n)]

# plot
plot(x, main = "Simulated CIR process", xlab = "x", ylab = "", type = "l", col = "blue", lwd = 2)