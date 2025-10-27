rm(list = ls(all = TRUE))

# install and load packages
libraries = c("evd")

# parameter settings
n     = 100
sp    = 5
xpos  = sp * (1:n)/n
xneg  = -sp + xpos
x     = c(xneg, xpos)
alpha = 1/2

# Creating 3 types of densities via function "dgev" from package "evd"

gumb = cbind(x, evd::dgev(x, 0, 1, 0)) # x, location (mu), scale (sigma), shape (alpha)
frec = cbind(x, evd::dgev(x, 1, 0.5, alpha))
weib = cbind(x, evd::dgev(x, -1, 0.5, -alpha))

# First: Display the plot on screen
par(bg = "transparent")
plot(weib, type = "l", col = "blue", lwd = 3, lty = 4, xlab = "X", ylab = "Y", 
     main = "Extreme Value Densities", panel.first = rect(par("usr")[1], par("usr")[3], 
                                                          par("usr")[2], par("usr")[4], 
                                                          col = "transparent"))
lines(frec, type = "l", col = "red", lwd = 3, lty = 3)
lines(gumb, type = "l", col = "black", lwd = 3)


# Then: Save the plot with transparent background
png("ExtremeValueDensities.png", 
    width = 800, height = 600, 
    bg = "transparent")  # Set background to transparent

par(bg = "transparent")
plot(weib, type = "l", col = "blue", lwd = 3, lty = 4, xlab = "X", ylab = "Y", 
     main = "Extreme Value Densities", panel.first = rect(par("usr")[1], par("usr")[3], 
                                                          par("usr")[2], par("usr")[4], 
                                                          col = "transparent"))
lines(frec, type = "l", col = "red", lwd = 3, lty = 3)
lines(gumb, type = "l", col = "black", lwd = 3)

dev.off()

# Message to confirm save
cat("Plot saved as ExtremeValueDensities.png with transparent background\n")