# clear all variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# set working directory
# setwd("C:/...")

# install and load packages
libraries = c("ismev")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# data import
Data = read.csv("2004-2014_dax_ftse.csv")

# Date variable as variable of class Date
Data$Date = as.Date(Data$Date, "%Y-%m-%d")

h       = 250         # size of moving window
x       = Data$BAYER + Data$BMW + Data$SIEMENS + Data$VOLKSWAGEN
x       = diff(x)     # returns
minus_x = -x
p       = 0.95        # quantile for the Value at Risk
q       = 0.1 
Obs     = length(x)

# function ----
var_pot = function(y,h,p,q){
  # Inputs:       
  # y - vector of returns
  # p - quantile for at which Value at Risk should be estimated
  # h - size of the window
  # q - scalar, e.g. 0.1
  N  = floor(h*q)
  ys = sort(y,decreasing = TRUE)
  u  = ys[N+1]
  z  = y[y>u]-u
  params = gpd.fit(z, threshold = 1 - p)
  ksi    = params$mle[2]
  beta   = params$mle[1]
  var    = u + beta/ksi*((h/N*(1-p))^(-ksi)-1)
  out    = c(var=var,ksi=ksi,beta=beta,u=u) 
}

# Value at Risk ----
# preallocation
results = data.frame(var=rep(NaN,Obs-h), ksi=rep(NaN,Obs-h),
                     beta=rep(NaN,Obs-h), u=rep(NaN,Obs-h))

for(i in 1:(Obs-h)){
  y = minus_x[i:(i+h-1)]
  results[i,] = var_pot(y,h,p,q)
}

# Plot the shape, scale and treshold parameter.
ylim = c(min(min(results[, -1]))-1, max(max(results[, -1]))+1)
windows()
plot(Data$Date[(h+2):length(Data$Date)],results$beta, xlab = "", 
     ylab = "", col = "blue", type = "l", lwd = 2, ylim = ylim)
lines(Data$Date[(h+2):length(Data$Date)],results$ksi, col = "red", lwd = 2)
lines(Data$Date[(h+2):length(Data$Date)],results$u, col = "magenta", lwd = 2)
legend("topleft", c("Scale Parameter", "Shape Parameter", "Threshold"), 
       lwd = c(2, 2, 2), col = c("blue", "red", "magenta"))
title("Parameters in Peaks Over Threshold Model")
