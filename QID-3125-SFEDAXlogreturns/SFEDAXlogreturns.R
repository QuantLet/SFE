# clear variables and close windows
rm(list=ls(all=TRUE))
graphics.off()

# set working directory
# setwd("C:/...")

# install and load packages
libraries = c("data.table", "tseries")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load the data
dataset = fread("2004-2014_dax_ftse.csv", select =  c("Date", "DAX 30", "DEUTSCHE TELEKOM"))
dataset = as.data.frame(dataset)

# log-returns
X = diff(log(dataset$`DAX 30`))

# limits for the y-axis in the plot
yLimUp = max(abs(c(min(X), max(X))) - 0)
yLims  = c(-yLimUp, yLimUp)

# Date variable
date.X       = as.Date(dataset$Date)[-1]
date.X.Years = as.numeric(format(date.X, "%Y"))
where.put    = c(1, which(diff(date.X.Years) == 1)+1)

# for the density we take the log-returns of the last four years available in the dataset
# i.e from 10.05.2010 to 10.05.2014
start      = which(date.X == "2010-05-10")
end        = length(X) 
X.lastfour = X[start:end]

# these objects will be later required to plot the density
mu.X      = mean(X.lastfour)
sigma2.X  = var(X.lastfour)
sigma.X   = sd(X.lastfour)
ndata     = seq(-yLimUp, yLimUp, length.out = 100000)

density    = function(x, mu, sigma2){
  (sqrt(2*pi*sigma2))^(-1)*exp(-(x - mu)^2/(2*sigma2))
}

# plot of the DAX log-returns with the normal density for the observations 
# of the last four years available
par(las = 1)
plot(1:end, X, type="l", col="blue3", frame = TRUE, axes = FALSE, 
     ylim = yLims, xlim = c(0, end + 250), 
     xlab = "Date", ylab = "DAX log-returns")
lines(c(start, start), yLims, col = 'black', lwd=2) 
lines(c(end, end), yLims, col = 'black', lwd = 2)    

# the density is here mulplied by 10 because otherwise the scale of the plot 
# would not alloud us to see it
lines(end + density(ndata, mu.X, sigma2.X)*10, ndata, col='red3', lwd=2.5) 
lines(c(start, end), c(mu.X, mu.X), col='black', lwd=2, lty='dashed')

# fill the area betwenn the area under the density curve between (mu - sigma) and (mu + sigma)
a = mu.X - sigma.X
b = mu.X + sigma.X
i = a
while (i<b){
  lines(c(end,end + density(i, mu.X, sigma2.X)*10), c(i, i), col = 'red3', lwd = 2)
  i=i+((b-a)/100)
}

# names of the axes
axis(side=2, at = seq(-1, 1, by = 0.02), label = round(seq(-1, 1, by = 0.02), 2), lwd=1)
axis(side=1, at = where.put, label = date.X.Years[where.put], lwd=0.5)
