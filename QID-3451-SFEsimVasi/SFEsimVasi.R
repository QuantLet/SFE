# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
a     = 0.161   # adjustment factor
b     = 0.014   # long term average interest rate    
sigma = 0.009   # instantaneous standard deviation
r0    = 0.01    # instantaneous forward rate
T     = 250     # time period
dt    = 1       # time intervals
N     = T/dt    # number of time intervals of length dt in long time period T
set.seed(100)

# The initial short rate
R = NULL
R[1] = r0

# Simulation of the short rates
for (i in 1:N) {
    R[i + 1] = R[i] + a * (b - R[i]) * (1/N) + sigma * sqrt(1/N) * rnorm(1, mean = 0, 
        sd = 1)
}

# Plot for the Short Rates vs Time
x = seq(0, T, dt)
plot(x, R, col = "blue", type = "l", lwd = 2, xlab = "Time", ylab = "Instantaneous Short Rates", 
    main = "Vasicek Model") 
