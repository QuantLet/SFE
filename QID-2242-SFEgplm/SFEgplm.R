
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("gplm", "lattice")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
data = read.table("kredit.dat")
data = data[(data[, 5] >= 1), ]
data = data[(data[, 5] <= 3), ]

# purpose=car/furniture
y = data[, 1]
x = (data[, 4] > 2)            # previous loans o.k.
x = cbind(x, (data[, 8] > 2))  # employed (>=1 year)
x = cbind(x, (data[, 3]))      # duration of loan
t = (data[, 6])                # amount of loan
t = cbind(t, (data[, 14]))     # age of client
xvars = c("previous", "employed", "duration")
tvars = c("amount", "age")
t = log(t)                     # logs of amount and age
trange = matrix(apply(t, 2, max) - apply(t, 2, min), NROW(t), NCOL(t), byrow = T)
t = (t - matrix(apply(t, 2, min), NROW(t), NCOL(t), byrow = T))/trange  # transformation to [0,1]

# plot
plot(t, xlab = "amount", pch = 3, ylab = "age", main = "Amount vs. Age")

# General Partial Linear Model estimation
h = c(0.4)  # Bandwidth
grid1 = seq(min(t[, 1]), max(t[, 1]), length = 20)  # Grid of the continuous part
grid2 = seq(min(t[, 2]), max(t[, 2]), length = 25)  # Grid of the continuous part
grid = create.grid(list(grid1, grid2))  # Expand grid
# GPLM with Logit link function and quartic kernel
g = kgplm(x = x, t = t, y = y, h = h, grid = grid, family = "bernoulli", link = "logit", 
    method = "speckman", kernel = "biweight")

# preparing nonparametric part on the grid for plotting
dada = cbind(grid, g$m.grid)
dada = dada[order(dada[, c(1)]), ]
dada = data.frame(dada)

# plot
dev.new()
par.set = list(axis.line = list(col = "transparent"), clip = list(panel = "off"))
wireframe(dada[, 3] ~ dada[, 1] + dada[, 2], main = "Amount & Age -> Credit", screen = list(z = 50, 
    x = -60), drape = TRUE, colorkey = F, ticktype = "detailed", scales = list(arrows = FALSE, 
    col = "black", distance = 1, tick.number = 8, cex = 0.7, x = list(labels = round(seq(min(dada[, 
        1]), max(dada[, 1]), length = 11), 1)), y = list(labels = round(seq(min(dada[, 
        2]), max(dada[, 2]), length = 11), 1)), z = list(labels = round(seq(min(dada[, 
        3]), max(dada[, 3]), length = 11), 1))), xlab = list("amount", rot = 38, 
    cex = 1.2), ylab = list("age", rot = -35, cex = 1.2), zlab = list("", rot = 95, 
    cex = 1.1), par.settings = par.set)

# summary of estimates:
summarize = function(g, xvars) {
    table = paste(" GPLM fit, 'binomial logit', n =", length(g$m))
    for (i in 1:length(g$b)) {
        table = rbind(table, toString(paste(xvars[i], "   ", round(g$b[i], 4))))
    }
    table = rbind(table, toString(paste("number of iterations", g$it)))
    table = rbind(table, toString(paste("df          ", round(g$df.residual, 3))))
    table = rbind(table, toString(paste("Deviance    ", round(g$deviance, 3))))
    table = rbind(table, toString(paste("AIC         ", round(g$aic, 3))))
    return(table)
}

summarize(g, xvars)