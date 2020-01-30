# clear all variables
rm(list=ls(all=TRUE))

# set working directory
#setwd("C:/...")

# install and load packages
libraries = c("data.table", "tseries")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

install.packages("POT")
library(POT)

# load the data
dataset = fread("2004-2014_dax_ftse.csv", select =  c("Date", "BAYER", "BMW", "SIEMENS", "VOLKSWAGEN"))
dataset = as.data.frame(dataset)

# Portfolio
d    = dataset$BAYER + dataset$BMW + dataset$SIEMENS + dataset$VOLKSWAGEN

n1   = length(d) # length of portfolio
x    = log(d[1:n1-1]/d[2:n1]) #negative log-returns


gpd  = fitgpd(x,quantile(x, 0.95),est="mle") # 
n    = gpd$nat
thr  = gpd$threshold
scale= gpd$param[1]
shape= gpd$param[2]
data = gpd$data
exc  = gpd$exceed
t    = (1:n)/(n+1)
y1   = qgpd(t,scale=scale,shape=shape)                   
 
gpdt = sort(exc)-thr                           
y2   = pgpd(gpdt,scale=scale,shape=shape)          


plot(y2,t,col="blue",pch=15,bg="blue",xlab="",ylab="",main="PP plot, Generalized Pareto Distribution")
lines(y2,y2,type="l",col="red",lwd=2)