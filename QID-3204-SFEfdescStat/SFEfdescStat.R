
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("moments")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# FTSE
x  = as.matrix(read.table("FTSElevel(03.01.00-30.10.06).txt"))
# returns
x1 = 100 * diff(log(x))
# Box-Pierce
QStats = Box.test(x1^2, lag = 24, type = "Ljung")
Q1 = QStats[[1]]
y1 = c(sd(c(x1)), min(x1), max(x1), skewness(x1), kurtosis(x1) - 3, Q1)	# Descriptive Statistics

# Bayer
x2 = as.matrix(read.table("BAYERlevel(03.01.00-30.10.06).txt"))
# returns
x2 = 100 * diff(log(x2))
# Box-Pierce
QStats = Box.test(x2^2, lag = 24, type = "Ljung")
Q2 = QStats[[1]]
y2 = c(sd(c(x2)), min(x2), max(x2), skewness(x2), kurtosis(x2) - 3, Q2)	# Descriptive Statistics

# Siemens
x3 = as.matrix(read.table("SIEMENSlevel(03.01.00-30.10.06).txt"))
# returns
x3 = 100 * diff(log(x3))
# Box-Pierce
QStats = Box.test(x3^2, lag = 24, type = "Ljung")
Q3 = QStats[[1]]
y3 = c(sd(c(x3)), min(x3), max(x3), skewness(x3), kurtosis(x3) - 3, Q3)	# Descriptive Statistics

# VW
x4 = as.matrix(read.table("VWlevel(03.01.00-30.10.06).txt"))
# returns
x4 = 100 * diff(log(x4))
# Box-Pierce
QStats = Box.test(x4^2, lag = 24, type = "Ljung")
Q4 = QStats[[1]]
y4 = c(sd(c(x4)), min(x4), max(x4), skewness(x4), kurtosis(x4) - 3, Q4)	# Descriptive Statistics

# Summary statistics
d = cbind(y1, y2, y3, y4)
rownames(d) = c("Std. Dev.", "Min", "Max", "S", "K", paste(expression(Q^2(24))))
# display rounded table values
round(d, 2)
