rm(list=ls(all=TRUE))
graphics.off()


x1 = read.table("BAYER_close_0012.dat")
x2 = read.table("BMW_close_0012.dat")
x3 = read.table("SIEMENS_close_0012.dat")
x4 = read.table("VW_close_0012.dat")

r1 = diff(as.matrix(log(x1)))
r2 = diff(as.matrix(log(x2)))
r3 = diff(as.matrix(log(x3)))
r4 = diff(as.matrix(log(x4)))

# Variance efficient portfolio
portfolio = cbind(r1,r2,r3,r4)
opti      = solve(cov(portfolio))%*%c(1,1,1,1)
opti      = opti/sum(opti)
returns2  = as.matrix(portfolio)%*%opti
x         = returns2
n         = nrow(x)
xf        = apply(x,2,sort)
t         = (1:n)/(n+1)
dat1      = cbind(pnorm((xf-mean(xf))/sd(xf)),t)
dat2      = cbind(t,t)

#PP Plot
plot(dat1,col="blue",ylab="",xlab="",main="PP Plot of Daily Return of Portfolio")
lines(dat2,col="red",lwd=2)

#QQ Plot
qqnorm(xf,col="blue",xlab="",ylab="",main="QQ Plot of Daily Return of Portfolio")
qqline(xf,col="red",lwd=2)