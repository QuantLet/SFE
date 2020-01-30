rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("TeachingDemos", "lattice")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
n       = 10000     # sample size
a       = 2^16 + 3
M       = 2^31
seed    = 1298324   # makes sure that the same numbers are generated each time the quantlet is executed
y       = NULL

# main computation
y[1] = seed
i = 2
while (i <= n) {
  y[i] = (a * y[i - 1])%%M
  i = i + 1
}
y = y/M

# output
rotate.cloud(y[3:n] ~ y[1:(n - 2)] + y[2:(n - 1)], xlab = "", ylab = "", zlab = "", 
             type = "p", scales = list(arrows = FALSE, col = "black", distance = 1, 
             tick.number = 8, cex = 0.7, x = list(labels = round(seq(0, 1, length = 10), 
             1)), y = list(labels = round(seq(0, 1, length = 10), 1)), z = list(labels = 
             round(seq(0, 1, length = 10), 1))), col = "black", pch = 20, cex = 0.1)