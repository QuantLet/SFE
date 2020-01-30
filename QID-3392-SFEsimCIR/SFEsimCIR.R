# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# set parameters for the simulation
Tobs = 360
alpha = 5
mu    = 1
sigma = 0.2

dt = 1/Tobs

# initial value of X (X_0):
X = mu

# set a seed if you want this simmulation to be reproducible
# set.seed(123) 

# simulates a mean reverting square root process around mu
for (i in 1:Tobs) {
  dW = rnorm(1) * sqrt(dt)
  dX = alpha * (mu - X[i]) * dt + sigma * sqrt(abs(X[i])) * dW
  X  = c(X, X[i] + dX)
}
  
X = X[-1]

# plot
t = (1:Tobs)/Tobs
plot(t, X, main = 'Simulated CIR process', xlab = 't', ylab = expression(X[t]), type = "l", col = "blue3", lwd = 2)
