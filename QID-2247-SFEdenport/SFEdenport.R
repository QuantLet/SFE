
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
x1 = read.table("BAYER_close_0012.dat")
x2 = read.table("BMW_close_0012.dat")
x3 = read.table("SIEMENS_close_0012.dat")
x4 = read.table("VW_close_0012.dat")

r1 = diff(as.matrix(log(x1)))
r2 = diff(as.matrix(log(x2)))
r3 = diff(as.matrix(log(x3)))
r4 = diff(as.matrix(log(x4)))

# Variance efficient portfolio
portfolio = cbind(r1, r2, r3, r4)
opti = solve(cov(portfolio)) %*% c(1, 1, 1, 1)
opti = opti/sum(opti)
lrplport = as.matrix(portfolio) %*% opti

# plot
par(mfrow = c(2, 1))
plot(density(lrplport, kernel = "biweight", bw = 0.003), xlim = c(-0.1, 0.1), main = "Density Estimate of the Positive Log-Returns of the Portfolio", 
    lwd = 2, col = "blue3", xlab = "Loss(-)/Profit(+)", ylab = "Frequency", ylim = c(0, 
        40))
plot(density(-lrplport, kernel = "biweight", bw = 0.003), xlim = c(-0.1, 0.1), 
    main = "Density Estimate of the Negative Log-Returns of the Portfolio", lwd = 2, 
    col = "blue3", xlab = "Loss(+)/Profit(-)", ylab = "Frequency", ylim = c(0, 
        40))
