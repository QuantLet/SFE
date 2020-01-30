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
           beta=rep(NaN,Obs-h), u=rep(NaN,Obs-h) )

for(i in 1:(Obs-h)){
  y = minus_x[i:(i+h-1)]
  results[i,] = var_pot(y,h,p,q)
}

# number of exceedances fo Value at Risk, p ----
v = -results$var
L = x

# preallocation
outlier   = rep(NaN,Obs-h)
exceedVaR = outlier

for(j in 1:(Obs-h)){
  exceedVaR[j] = (L[j+h]<v[j])
  if(exceedVaR[j]>0) 
    outlier[j] = L[j+h]
}

p       = sum(exceedVaR)/(Obs-h)
K       = which(is.finite(outlier))
outlier = outlier[K]

date_outlier = Data$Date[(h+2):length(Data$Date)]
date_outlier = date_outlier[K]

# plot ----
windows()
plot(Data$Date[(h+2):length(Data$Date)],L[(h+1):length(L)], xlab = "", 
     ylab = "", col = "blue", pch = 18)
points(date_outlier, outlier, pch = 18, col = "magenta")
points(Data$Date[(h+2):length(Data$Date)], v, col= "red", lwd = 5, type = "l")
yplus = K * 0 + min(L[(h + 1):length(L)]) - 2
points(date_outlier, yplus, pch = 3, col = "dark green")
legend("topleft", c("Profit/Loss", "VaR", "Exceedances"), pch = c(18, NA, 18), 
       lwd = c(NA, 5, NA), col = c("blue", "red", "magenta"))
title("Peaks Over Threshold Model")

# Print the exceedances ratio
print(paste("Exceedances ratio:", "", p))
