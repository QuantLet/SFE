# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
n    = 1000
a    = 1229
b    = 1
M    = 2048
seed = 12

# main computation
y    = NULL
y[1] = seed
i    = 2
while (i <= n) {
    y[i] = (a * y[i - 1] + b)%%M
    i = i + 1
}
y = y/M

# output
plot(y[1:(n - 2)], y[2:(n - 1)], col = "black", xlab = c(expression(U * bold(scriptstyle(atop(phantom(1), 
    (i - 1)))))), ylab = c(expression(U * bold(scriptstyle(atop(phantom(1), 
    i)))))) 