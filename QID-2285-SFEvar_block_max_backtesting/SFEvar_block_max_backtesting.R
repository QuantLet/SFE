# clear all variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# set working directory
# setwd("C:/...")

# install and load packages
libraries = c("evd")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# data import
Data = read.csv("2004-2014_dax_ftse.csv")

# date variable as variable of class Date
Data$Date = as.Date(Data$Date, "%Y-%m-%d")

# Create portfolio
x       = Data$BAYER + Data$BMW + Data$SIEMENS + Data$VOLKSWAGEN
x       = diff(x)     # returns
minus_x = -x          # negative returns
Obs     = length(x)   # number of observations 
h       = 250         # size of moving window
p       = 0.95        # quantile for the Value at Risk
n       = 16          # observation window for estimating quantile in VaR

# function ----
block_max = function(y,n,p){
  N = length(y)
  k = floor(N/n)
  z = rep(NaN, k)
  for(j in 1:(k-1)){
    r    = y[((j-1)*n+1):(j*n)]
    z[j] = max(r)
  }
  r     = y[((k-1)*n+1):length(y)]
  z[k]  = max(r)
  
  parmhat = fgev(z, std.err = FALSE)$param
  kappa   = parmhat["shape"]
  tau     = -1/kappa
  alpha   = parmhat["scale"]
  beta    = parmhat["loc"]
  
  pext    = p^n
  var     = beta+alpha/kappa*((-log(1-pext))^(-kappa)-1)
  out    = c(var=var,tau=tau,alpha=alpha,beta=beta,kappa=kappa) 
}

# Value at Risk ----
# preallocation
results = data.frame(var=rep(NaN,Obs-h), tau=rep(NaN,Obs-h), alpha=rep(NaN,Obs-h),
                     beta=rep(NaN,Obs-h), kappa=rep(NaN,Obs-h) )

for(i in 1:(Obs-h)){
  y = minus_x[i:(i+h-1)]
  results[i,] = block_max(y,n,p)
}

v = -results$var
L = x

# preallocation
outlier   = rep(NaN,Obs-h)
exceedVaR = outlier

for(j in 1:(Obs-h)){
  exceedVaR[j] = (L[j+h]<v[j])
  if(exceedVaR[j]>0){
    outlier[j] = L[j+h]
  }
}

p       = sum(exceedVaR)/(Obs-h)
K       = which(is.finite(outlier))
outlier = outlier[K]
yplus   = K * 0 + min(L[(h + 1):length(L)]) - 2

date_outlier = Data$Date[(h+2):length(Data$Date)]
date_outlier = date_outlier[K]

# plot ----
windows()
plot(Data$Date[(h+2):length(Data$Date)],x[(h+1):Obs], xlab = "", 
     ylab = "", col = "blue", pch = 18)
points(date_outlier, outlier, pch = 18, col = "magenta")
lines(Data$Date[(h+2):length(Data$Date)], v, col= "red", lwd = 3)
points(date_outlier, yplus, pch = 3, col = "dark green")
legend("topleft", c("Profit/Loss", "VaR", "Exceedances"), pch = c(18, NA, 18), 
       lwd = c(NA, 3, NA), col = c("blue", "red", "magenta"))
title("Block Maxima Model")

# Print the exceedances ratio
print(paste("Exceedances ratio:", "", p))
