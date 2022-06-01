# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages, install 'fExtremes' package for the Gumbel distribution
libraries = c("fExtremes", "evd")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

set.seed(1234)
  
# global parameter settings
n = 100
y = (1:n) / (n + 1)

# choose EVT cdf for the plot header only
# sel = "Weibull"
# sel = "Frechet"
  sel = "Gumbel"

# sel "Weibull"       
# x = rweibull(n, shape=2, scale = 1) # you may change these params
  
# sel "Frechet"
# x = rfrechet(n, loc = 0, scale = 1, shape = 1)  # you may change these params
  
# sel "Gumbel"
x =  rgumbel(n, loc=0, scale=1)  # you may change these params
  
# now calc the order statistics of the generated rv's
x = sort(x) 
px= pnorm(x)  # calc the probas on the standard normal scale
  
# png( paste0("SFEevt", sel, ".png") )
par(pty="s")
plot(y, y, col = "red", type = "line", lwd = 2.5, main = paste( "PP Plot of Extreme Value - ", sel),
       xlab = "X", ylab = "Y", xaxt = "n", yaxt = "n", asp=1, xlim=c(0,1), ylim=c(0,1))
axis(1, at = seq(0, 1, 0.2))
axis(2, at = seq(0, 1, 0.2))
points(px, y, col = "blue", pch = 19, cex = 0.8)
#  dev.off()


