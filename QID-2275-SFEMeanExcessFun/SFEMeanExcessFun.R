
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
a = read.table("BAYER_close_0012.dat")
b = read.table("BMW_close_0012.dat")
c = read.table("SIEMENS_close_0012.dat")
d = read.table("VW_close_0012.dat")

e = a + b + c + d
e = as.matrix(e)
end = NROW(e)
x = log(e[1:(end - 1)]) - log(e[2:end])  # negative log-returns
n = length(x)
x = sort(x, decreasing = TRUE)
m = 100
x1 = x[1:m]

# empirical mean excess function
t = x[1:(m + 1)]  # t must be >0
MEF = numeric()

for (i in 1:length(t)) {
    y = x[which(x > t[i])]
    MEF[i] = mean(y - t[i])
}

# plot
plot(t, MEF, type = "l", col = "blue", lwd = 3, xlab = "u", ylab = "e(u)", xlim = c(0.04, 
    0.2))
title("Mean Excess Functions")

# mean excess function of generalized Pareto distribution
k = 100
GPD = gpdFit(x, type = "mle", information = "observed")
K = attr(GPD, "fit")$par.ests[1]
sigma = attr(GPD, "fit")$par.ests[2]
gpme = (sigma + K * (t - mean(t)))/(1 - K)
lines(t, gpme, lwd = 3)

# Hill estimator, mean excess function of Pareto distribution
alphaH = (mean(log(x1)) - log(x1[k]))^(-1)
sigmaH = x1[k] * (k/n)^(1/alphaH)
gp1me = t/(alphaH - 1)
lines(t, gp1me, col = "red", lwd = 3, lty = 5)