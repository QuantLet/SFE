# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("tfplot")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Main computation
datax = read.table("dafox.dat")
datax = as.matrix(datax)
n     = nrow(datax)
tx    = datax[(n - 1000):n, 2]
tx    = as.matrix(tx)

# Log returns
x = diff(log(tx))  

# Plot
name        = "DAFOX 1993-96"
origyear    = 1993
origperiod  = 1
periodicity = 300
tfplot(ts(x, start = c(1993, 1), frequency = periodicity), start = c(origyear, origperiod), 
    title = name)  
