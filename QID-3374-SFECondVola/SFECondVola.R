# setwd("C:/...")

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# FTSE 
x = read.table("ConVola(FIAPARCH)ftse.txt")
n = length(as.matrix(x))

# 2 x 2 plot matrix
par(mfrow = c(2, 2))

plot(as.matrix(x), type = "l", ylab = "", xlab = "", col = "blue3")
title("FTSE")
x1 = read.table("ConVola(HYGARCH)ftse.txt")
lines(as.matrix(x1), col = "red3")

# Bayer
x = read.table("ConVola(FIAPARCH)bayer.txt")
n = length(as.matrix(x))
plot(as.matrix(x), type = "l", ylab = "", xlab = "", col = "blue3", ylim = c(0, 70))
title("Bayer")
x1 = read.table("ConVola(HYGARCH)bayer.txt")
x1 = as.matrix(x1)
lines(x1, col = "red3")

# Siemens
x = read.table("ConVola(FIAPARCH)siemens.txt")
x = as.matrix(x)
plot(x, type = "l", ylab = "", xlab = "Time", col = "blue3")
n = length(x)
title("Siemens")
x1 = read.table("ConVola(HYGARCH)siemens.txt")
x1 = as.matrix(x1)
lines(x1, col = "red3")

# VW
x = read.table("ConVola(FIAPARCH)vw.txt")
x = as.matrix(x)
plot(x, type = "l", ylab = "", xlab = "Time", col = "blue3")
n = length(x)
title("Volkswagen")
x1 = read.table("ConVola(HYGARCH)VW.txt")
lines(x1, col = "red3")
