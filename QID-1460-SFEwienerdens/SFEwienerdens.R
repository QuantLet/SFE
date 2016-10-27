
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# inputs parameters
print("Please input Delta t, Constant c, Time moment s  as: 0.01 2 150")
print("then press enter two times")
para = scan()

while (length(para) < 3) {
    print("Not enough input arguments. Please input in 1*3 vector form like 0.01 2 150")
    print(" ")
    print("[dt c s]=")
    para = scan()
}

dt = para[1]  # Delta t
c  = para[2]  # Constant c
s  = para[3]  # Time moment s

# Check conditions
if (dt <= 0) {
    print("SFEwienerdens: Delta t should be positive! Please input again. dt=")
    s0 = scan()
}
if (s < 0) {
    print("SFEwienerdens: Time moment s should be positive! Please input again. s=")
    s = scan()
}

print(" ")
print("Please input Left limit a, Right limit b, The initial value of the process x0  as: 90 110 50")
print("then press enter two times")
para2 = scan()

while (length(para2) < 3) {
    print("Not enough input arguments. Please input in 1*3 vector form like 90 110 50")
    print("[a b x0]=")
    para2 = scan()
}

a  = para2[1]  # 1 is call/0 is put
b  = para2[2]  # Contionous dividend in percentage
x0 = para2[3]

# Main calculation
l = 200
n = floor(l/dt)
t = seq(0, n * dt, dt)

set.seed(80)
z1 = runif(n * 1, 0, 1)
z  = z1
z[z1 < 0.5] = 1
z[z1 > 0.5] = -1
z  = z * c * sqrt(dt)  # to get finite and non-zero varinace
x  = c(x0, x0 + cumsum(z))

# Computing the normal distribution
max1   = max(x)
min1   = min(x)
sigma  = sqrt(max(t) - s) * c
mu     = x[s/dt]
ndata  = seq(min1 - sigma^2, sigma^2 * (max1 - min1), 0.2)
f      = 750 * 1/sqrt(2 * pi * sigma * sigma) * exp(-(ndata - mu)^2/(2 * sigma^2)) + 
    max(t)
fndata = cbind(f, ndata)
y      = dnorm(x, mu, sigma)

# Plot
plot(x, type = "l", col = "blue3", frame = TRUE, axes = FALSE, ylim = c(min1 - 
    sigma, max1 + sigma), xlim = c(0, max(f) * 100 + 1000), xlab = "Iteration Number", 
    ylab = "Wiener Process Value", main = "Wiener Process Simulation")

# Drawing the vertical lines
line1 = rbind(cbind(s, max1 + sigma), cbind(s, min1 - sigma))
lines(c(line1[1, 1] * 100, line1[2, 1] * 100), c(line1[1, 2], line1[2, 2]), col = "black", 
    lwd = 2)
line2 = rbind(cbind(max(t), max1 + sigma), cbind(max(t), min1 - sigma))
lines(c(line2[1, 1] * 100, line2[2, 1] * 100), c(line2[1, 2], line2[2, 2]), col = "black", 
    lwd = 2)

# Drawing the normal distribution
lines(100 * fndata[, 1], fndata[, 2], col = "red3", lwd = 2)

# Drawing one more line
line3 = rbind(cbind(s, mu), cbind(max(f), mu))
lines(c(line3[1, 1] * 100, line3[2, 1] * 100), c(line3[1, 2], line3[2, 2]), col = "black", 
    lwd = 1, lty = "dashed")

# Drawing the red area
a = mu - sigma
b = mu + sigma
i = a
while (i < b) {
    line8 = cbind(c(max(t) + 0.4, 750 * 1/sqrt(2 * pi * sigma * sigma) * exp(-(i - 
        mu)^2/(2 * sigma^2)) + max(t)), c(i, i))
    # rbind(cbind(max(t)+0.4,i),cbind(750*1/sqrt(2*pi*sigma*sigma)*exp(
    # -(i-mu)^2/(2*sigma^2) )+max(t),i))
    lines(c(line8[1, 1] * 100, line8[2, 1] * 100), c(line8[1, 2], line8[2, 2]), 
        col = "red3", lwd = 2)
    i = i + 0.1
}
axis(side = 2, at = seq(-200, 200, by = 10), label = seq(-200, 200, by = 10), lwd = 1)
axis(side = 1, at = seq(0, max(f) * 100, 5000), label = seq(0, max(f) * 100, 5000), 
    lwd = 0.5)
abline(h = seq(-200, 200, by = 10), lty = "dotted", lwd = 0.5, col = "grey")
abline(v = seq(0, max(f) * 100, 2500), lty = "dotted", lwd = 0.5, col = "grey")
