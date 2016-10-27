# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# main computation
n      = 10000
u      = runif(n, 0, 1)
u1     = runif(n, 0, 1)
theta  = 2 * pi * u1
rho    = sqrt(-2 * log(u))
zeta1  = rho * cos(theta)
zeta2  = rho * sin(theta)
result = cbind(zeta1, zeta2)

# output
plot(result[, 1], result[, 2], xlab = "Z_1", ylab = "Z_2")

v1 = var(result[, 1])
v2 = var(result[, 2])
m1 = mean(result[, 1])
m2 = mean(result[, 2])

print("    Normal distribution 1")
print("    Mean      Variance")
print(c(m1, v1))
print("    Normal distribution 2")
print("    Mean      Variance")
print(c(m2, v2))
