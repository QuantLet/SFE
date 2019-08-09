# ---------------------------------------------------------------------
# Book:         SFE
# ---------------------------------------------------------------------
# Quantlet:     SFEtailGPareto_qq
# ---------------------------------------------------------------------
# Description:  SFEtailGPareto_qq estimates the parameters of Generalized 
#               Pareto Distribution for the negative log-returns of 
#               portfolio (Bayer, BMW, Siemens, VW), time period: from 
#               2000-01-01 to 2012-12-31, and produces QQ-plot.
# ---------------------------------------------------------------------
# Usage:        -
# ---------------------------------------------------------------------
# Inputs:       None
# ---------------------------------------------------------------------
# Output:       QQ-plot with Generalized Pareto Distribution.
# ---------------------------------------------------------------------
# Example:     
# ---------------------------------------------------------------------
# Author:       Awdesch Melzer 20131126
# ---------------------------------------------------------------------

rm(list=ls(all=TRUE))
#setwd("C:/...")

install.packages("POT")
library(POT)

# Load data sets
a    = read.table('BAYER_close_0012.dat')
b    = read.table('BMW_close_0012.dat')
c    = read.table('SIEMENS_close_0012.dat')
e    = read.table('VW_close_0012.dat')
# Portfolio
d    = a+b+c+e

n1   = dim(d)[1] # length of portfolio
x    = log(d[1:n1-1,]/d[2:n1,]) #negative log-returns


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
                                                    
plot(gpdt,y1,col="blue",pch=15,bg="blue",xlab="",ylab="",main="QQ plot, Generalized Pareto Distribution")
lines(y1,y1,type="l",col="red",lwd=2)  
