# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# load data
x = read.table("implvola.dat")

# rescale
x = x * 100

# number of rows
n = nrow(x)

# calculate first differences
z=apply(x,2,diff)

# calculate covariance
s = cov(z) * 1e+05

# calculate eigenvalues and eigenvectors
e = eigen(s, symmetric = TRUE)
l = e$values

# percentage of explained variance
l/sum(l) * 100

# cumulative sum of percentage of explained variance
cumsum(l/sum(l) * 100)
