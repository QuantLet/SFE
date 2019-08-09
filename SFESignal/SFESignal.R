# create simulated time series processes
t        = 1:500
S        = 2 * cos(2 * pi * t / 50 + .6 * pi)
epsilon1 = rnorm(500, 0, 1)
epsilon2 = 5 * epsilon1

# plot the simulated time series processes
par(mfrow = c(3, 1), mex = 1, lheight = 1.5)
plot.ts(S, xlab = "", col = "blue3", ylab = bquote(S[t]))
plot.ts(S + epsilon1, xlab = "", col = "blue3", ylab = bquote(S[t] +  εt1))
plot.ts(S + epsilon2, xlab = "Time t", col = "blue3", ylab = bquote(S[t] +  εt1))
