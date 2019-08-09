# clear all variables anc close windows
rm(list=ls(all=TRUE))
graphics.off()

set.seed(1) # set pseudo random numbers

n       = 100   # number of observations
beta    = 0.1   # beta parameter
gamma   = 0.01  # gamma parameter
m       = 1     # mean

# simulates a mean reverting square root process around m
i     = 0
delta = 0.1
x     = m     # start value

while (i<(n*10)){
    i   = i+1
	d   = beta*(m - x[length(x)])*delta + gamma*sqrt(delta)*rnorm(1,0,1)
	x   = rbind(x, x[length(x)]+d)
}

x     = x[2:length(x)]
ind   = 10*(1:n)
x     = x[ind]

#plot
plot(x,type="l",col="blue3", lwd=2,xlab="x",ylab="")
title(paste("Simulated OU process for beta = ", beta,"& gamma = ", gamma," around mean= ", m))
