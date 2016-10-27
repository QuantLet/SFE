
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("tseries", "fGarch")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
DS  = read.table("FSE_LSE.dat")
D   = DS[, 1]                       # date
S   = DS[, 2:43]                    # S(t)
s   = log(S)                        # log(S(t))
n1  = dim(s)
end = n1[1]                         # end of sample
r   = s[-1, ] - s[1:(end - 1), ]    # r(t)
n   = dim(r)[1]                     # sample size
t   = 1:n                           # time index, t

# DAX and FTSE 100 returns
rdax  = r[, 1]     # DAX returns
rftse = r[, 22]    # FTSE 100 returns

# ARCH(q) models for the volatility process of DAX returns
for (i in 1:15) {
    assign(paste("dax.garch", i, sep = ""), garchFit(substitute(~garch(i, 1), list(i = i, 
        0)), rdax, trace = FALSE))
    assign(paste("ftse.garch", i, sep = ""), garchFit(substitute(~garch(i, 1), 
        list(i = i, 0)), rftse, trace = FALSE))
}

# Read the optimized log-likelihood value for q=1:15
dax.LLF = c(dax.garch1@fit$llh, dax.garch2@fit$llh, dax.garch3@fit$llh, dax.garch4@fit$llh, 
    dax.garch5@fit$llh, dax.garch6@fit$llh, dax.garch7@fit$llh, dax.garch8@fit$llh, 
    dax.garch9@fit$llh, dax.garch10@fit$llh, dax.garch11@fit$llh, dax.garch12@fit$llh, 
    dax.garch13@fit$llh, dax.garch14@fit$llh, dax.garch15@fit$llh) * (-1)

ftse.LLF = c(ftse.garch1@fit$llh, ftse.garch2@fit$llh, ftse.garch3@fit$llh, ftse.garch4@fit$llh, 
    ftse.garch5@fit$llh, ftse.garch6@fit$llh, ftse.garch7@fit$llh, ftse.garch8@fit$llh, 
    ftse.garch9@fit$llh, ftse.garch10@fit$llh, ftse.garch11@fit$llh, ftse.garch12@fit$llh, 
    ftse.garch13@fit$llh, ftse.garch14@fit$llh, ftse.garch15@fit$llh) * (-1)

# AR(1)-GARCH(1,1) volatility estimation for DAX and FTSE 100 data
dax.arch1  = garchFit(~arma(1, 0) + garch(1, 1), rdax, trace = FALSE)
ftse.arch1 = garchFit(~arma(1, 0) + garch(1, 1), rftse, trace = FALSE)

# Labels
time      = strptime(D, format = "%Y%m%d")
labels    = as.numeric(format(as.Date(time, "%Y-%m-%d"), "%Y"))
where.put = c(1, which(diff(labels) == 1) + 1)

title = bquote(paste("Volatility estimation for DAX and FTSE 100 data"))

# Plot of the DAX volatility
par(mfrow = c(2, 1))
plot(dax.arch1@sigma.t, main = "DAX", col = "blue3", type = "l", axes = FALSE, 
    frame = TRUE, ylab = "", xlab = "", ylim = c(0, 0.045), )
axis(side = 2, at = seq(0, 0.05, 0.01), label = seq(0, 0.05, 0.01), lwd = 1, cex.axis = 1)
axis(side = 1, at = where.put, label = labels[where.put], lwd = 0.5, cex.axis = 1)
abline(h = seq(0, 0.05, 0.01), lty = "dotted", lwd = 0.5, col = "grey")
abline(v = where.put, lty = "dotted", lwd = 0.5, col = "grey")

# Plot of the FTSE 100 volatility
plot(ftse.arch1@sigma.t, main = "FTSE 100", col = "blue3", axes = FALSE, frame = TRUE, 
    type = "l", ylab = "", xlab = "Time, t", ylim = c(0, 0.035), sub = title)
axis(side = 2, at = seq(0, 0.05, 0.01), label = seq(0, 0.05, 0.01), lwd = 1, cex.axis = 1)
axis(side = 1, at = where.put, label = labels[where.put], lwd = 0.5, cex.axis = 1)
abline(h = seq(0, 0.05, 0.01), lty = "dotted", lwd = 0.5, col = "grey")
abline(v = where.put, lty = "dotted", lwd = 0.5, col = "grey")
