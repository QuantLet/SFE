
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("copula", "fGarch", "fBasics")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
S = read.table("Representative_Data.txt", skip = 1)
date.time = read.table("Stocks_Series.txt")[, 1]

steps = 2500
n.start = 1
window = 250

S = S[, -1]
S = S[, -1]
X = S[-1, ]
for (i in 1:length(S[1, ])) X[, i] = log(S[-1, i]/S[-length(S[, i]), i])

params.cop = 0
start = 1
for (start in n.start:steps) {
    S.part = S[start:(start + window), ]
    X.part = X[start:(start + window - 1), ]
    eps = X.part
    params = matrix(0, 4, dim(S.part)[2])
    for (i in 1:length(S.part[1, ])) {
        fit = garchFit(~garch(1, 1), data = X.part[, i], trace = F)
        eps[, i] = fit@residuals/fit@sigma.t  # the residuals of a fitted Garch(1,1) are used
    }
    for (i in 1:dim(eps)[2]) eps[, i] = rank(eps[, i])/(length(eps[, i]) + 1)  # making margins uniform, based on Ranks
    params.cop = c(params.cop, cor(eps, method = "kendall")[1, 2])
}

params.cop = params.cop[-1]
write.table(params.cop, "params.cop.bi.txt", row.names = F, col.names = F)

# the following functions will be plotted, Kendall's tau is used
gumbel.tau2theta = function(tau) {
    1/(1 - tau)
}
clayton.tau2theta = function(tau) {
    2 * tau/(1 - tau)
}
normal.tau2theta = function(tau) {
    sin(tau * pi/2)
}

data.time.part = as.integer(format(as.Date(as.vector(date.time), "%d.%m.%Y"), "%Y"))
dataset.date.ind = which(c(1, diff(data.time.part)) == 1)
first.date = data.time.part[1]
dataset.date.labels = data.time.part[1]:(data.time.part[1] + length(dataset.date.ind) - 
    1)

# Normal
layout(matrix(c(1, 2, 3), 3, 1, byrow = FALSE))
par(mai = c(0.4, 0.5, 0.1, 0.1))
plot(normal.tau2theta(params.cop), type = "l", lwd = 3, xlab = "", ylab = "Y", 
    col = "black", axes = F, frame = T)
y.labels = c(round(seq(min(normal.tau2theta(params.cop)), max(normal.tau2theta(params.cop)), 
    length = 5) * 100)/100, 0)
axis(1, dataset.date.ind, dataset.date.labels, cex.axis = 2)
axis(2, y.labels, y.labels, cex.axis = 2)

# Clayton
par(mai = c(0.4, 0.5, 0.1, 0.1))
plot(clayton.tau2theta(params.cop), type = "l", lwd = 3, xlab = "", ylab = "Y", 
    col = "red3", axes = F, frame = T, cex = 3.5)
y.labels = c(round(seq(min(clayton.tau2theta(params.cop)), max(clayton.tau2theta(params.cop)), 
    length = 5) * 100)/100, 0)
axis(2, y.labels, y.labels, cex.axis = 2)
axis(1, dataset.date.ind, dataset.date.labels, cex.axis = 2)

# Gumbel
par(mai = c(0.6, 0.5, 0.1, 0.1))
plot(gumbel.tau2theta(params.cop), type = "l", lwd = 3, xlab = "X", ylab = "Y", 
    col = "blue3", axes = F, frame = T)
axis(1, dataset.date.ind, dataset.date.labels, cex.axis = 2)
y.labels = c(round(seq(min(gumbel.tau2theta(params.cop)), max(gumbel.tau2theta(params.cop)), 
    length = 5) * 100)/100, 0)
axis(2, y.labels, y.labels, cex.axis = 2)

dev.new()

# 1st plot
gum_cl_3d = read.table("params.cop.txt")
layout(matrix(c(1, 2), 2, 1, byrow = FALSE))
par(mai = c(0.5, 0.8, 0.2, 0.2))
plot(gum_cl_3d[, 1], type = "l", lwd = 3, xlab = "", ylab = "Y", col = "red3", 
    axes = F, frame = T)
y.labels = c(round(seq(min(gum_cl_3d[, 1]), max(gum_cl_3d[, 1]), length = 5) * 
    100)/100, 0)
axis(1, dataset.date.ind, dataset.date.labels, cex.axis = 1)
axis(2, y.labels, y.labels, cex.axis = 1)

# 2nd plot
par(mai = c(0.8, 0.8, 0, 0.2))
plot(gum_cl_3d[, 2], type = "l", lwd = 3, xlab = "X", ylab = "Y", col = "blue3", 
    axes = F, frame = T)
axis(1, dataset.date.ind, dataset.date.labels, cex.axis = 1)
y.labels = c(round(seq(min(gum_cl_3d[, 2]), max(gum_cl_3d[, 2]), length = 5) * 
    100)/100, 0)
axis(2, y.labels, y.labels, cex.axis = 1)

