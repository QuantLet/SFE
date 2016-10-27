
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fGarch")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

time = seq(1, 1000, 1)
x = garchSim(garchSpec(model = list(omega = 0.1, alpha = 0.15, beta = 0.8), rseed = 100), 
    n = 1000)
plot(time, x, type = "l", ylab = "Y", xlab = "Time", main = "Simulated GARCH(1,1) Process")
