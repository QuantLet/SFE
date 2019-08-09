# clear variables and close windows
rm(list=ls(all=TRUE))
graphics.off()

# set working directory
# setwd("C:/...")

# install and load packages
libraries = c("data.table", "tseries")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

#load the data
dataset = fread("2004-2014_dax_ftse.csv", select =  c("Date", "BAYER", "BMW", "SIEMENS", "VOLKSWAGEN"))
dataset = as.data.frame(dataset)

x1 = dataset$BAYER
x2 = dataset$BMW
x3 = dataset$SIEMENS
x4 = dataset$VOLKSWAGEN

x1 = as.matrix(x1)
x2 = as.matrix(x2)
x3 = as.matrix(x3)
x4 = as.matrix(x4)

# date variable
date.X       = as.Date(dataset$Date)[-1]
date.X.Years = as.numeric(format(date.X, "%Y"))
where.put    = c(1, which(diff(date.X.Years) == 1)+1)

t  = seq(23,dim(x1)[1],by=261)

# plot 
plot(x3,type="l",ylim=c(min(x1,x2,x3,x4),max(x1,x2,x3,x4)),col="blue3",xlab="Date",ylab="",main='Closing Prices for German Companies',xaxt="n")
lines(x1,lty=2)
lines(x2,col="red3",lty=3)
lines(x4,col="darkgreen",lty=4)

axis(side=1, at = where.put, label = date.X.Years[where.put], lwd=0.5)
