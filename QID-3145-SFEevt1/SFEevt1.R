
rm(list = ls(all = TRUE))

# install and load packages
libraries = c("evd")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
n     = 100
sp    = 5
xpos  = sp * (1:n)/n
xneg  = -sp + xpos
x     = c(xneg, xpos)
alpha = 1/2

# Creating 3 types of densities via function "dgev" from package "evd"
gumb = cbind(x, dgev(x))
frec = cbind(x, dgev(x, 1, 0.5, alpha))
weib = cbind(x, dgev(x, -1, 0.5, -alpha))

# Plot
plot(weib, type = "l", col = "blue", lwd = 3, lty = 4, xlab = "X", ylab = "Y", main = "Extreme Value Densities")
lines(frec, type = "l", col = "red", lwd = 3, lty = 3)
lines(gumb, type = "l", col = "black", lwd = 3) 
