
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fExtremes")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
a = read.table("BAYER_close_0012.dat")
b = read.table("BMW_close_0012.dat")
c = read.table("SIEMENS_close_0012.dat")
e = read.table("VW_close_0012.dat")

# Portfolio
d = a + b + c + e

n1 = NROW(d)  # length of portfolio
x  = log(d[1:(n1 - 1), ]/d[2:n1, ])  # negative log-returns

# Determine the Block Maxima data
T = length(x)
n = 20
k = T/n
z = matrix(, , , )

for (j in 1:k) {
    r = x[((j - 1) * n + 1):(j * n)]
    z[j] = max(r)
}
w = sort(z)

GEV = gevFit(w, type = "mle")  # Fit the Generalized Extreme Value Distribution

xi = attr(GEV, "fit")$par.ests[1]  # shape parameter
mu = attr(GEV, "fit")$par.ests[2]  # location parameter
sigma = attr(GEV, "fit")$par.ests[3]  # scale parameter

t = (1:k)/(k + 1)

y1 = qgev(t, xi = xi, mu = mu, beta = sigma)
y2 = pgev(w, xi = xi, mu = mu, beta = sigma)

# Plot the PP plot
dev.new()
plot(y2, t, col = "blue", pch = 23, bg = "blue", xlab = c(""), ylab = c(""))
lines(y2, y2, type = "l", col = "red", lwd = 2)
title("PP plot, Generalized Pareto Distribution")