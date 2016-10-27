
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# read data
x = read.table("implvola.dat")

# rescale
x = x/100

# compute first differences
z = apply(x,2,diff)
# calculate covariance
s = cov(z) * 1e+05
round(s, 2)
