
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
para = c(0.5, 15)
p = para[1] # Probability
n = para[2] # Number n
x = 1:n

# plot
par(mfrow = c(2, 1))
y = dbinom(x, n, p)
plot(x, y, col = "blue3", lwd = 5, type = "h", main = "Binomial distribution", 
    ylab = "f(x)")
z = pbinom(x, n, p)
plot(x, z, col = "red3", lwd = 3, type = "s", ylab = "F(x)")

# parameter settings
para = c(5, 0.5, 15)
x1   = para[1] # Value of x
p1   = para[2] # Probability
n1   = para[3] # Number n

print("Binomial distribution for the specified x, p, n")
print("P(X=x) = f(x) =")
dbinom(x1, n1, p1)
print("P(X<=x) = F(x) =")
pbinom(x1, n1, p1)
print("P(X>=x) = 1-F(x-1) =")
1 - pbinom(x1 - 1, n1, p1)
print("P(X<x) = P(X<=x) - P(X=x) = P(X<=x-1) = F(x-1) =")
pbinom(x1 - 1, n1, p1)
print("P(X>x) = P(X>=x) - P(X=x) = P(X>=x+1) = 1 - F(x) =")
1 - pbinom(x1, n1, p1)
