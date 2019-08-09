# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# set working directory
# setwd("C:/...")

# install and load packages
libraries = c("data.table", "dplyr", "moments")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# data import
DAX = read.csv("2004-2014_dax_ftse.csv")

# Date variable as variable of class Date
DAX$Date = as.Date(DAX$Date, "%Y-%m-%d")

# firt business day of each month
day           = format(DAX$Date, format = "%d")
DAX$monthYear = format(DAX$Date,format="%Y-%m")
firstDay      = tapply(day, DAX$monthYear, min)
firstDay      = paste(row.names(firstDay), firstDay, sep="-")

# monthly DAX
row.names(DAX) = DAX$Date
monthlyDAX     = DAX[firstDay[-1], ]
monthlyDAX     = select(monthlyDAX, DAX.30, Date, monthYear)

# monthly log-returns
returns = diff(log(monthlyDAX$DAX.30))

# summary statistics of the monthly log-returns
annVol          = sd(returns)*sqrt(12)
(returnsSummary = c(Minimum           = min(returns), 
                    Maximum           = max(returns), 
                    Mean              = mean(returns), 
                    Median            = median(returns), 
                    Std.Error         = sd(returns), 
                    Annual_volatility = annVol,
                    Skewness          = skewness(returns), 
                    Kurtosis          = kurtosis(returns)))

# start and end of the time series
Start = as.numeric(unlist(strsplit(monthlyDAX$monthYear[2], split = "-")))
End   = as.numeric(unlist(strsplit(monthlyDAX$monthYear[nrow(monthlyDAX)], split = "-")))

# save DAX monthly log-returns as a time series
ts_returns = ts(returns, start=Start, end=End, frequency=12) 

# title of the plot
forTitle   = format(monthlyDAX$Date, "%Y.%m")
Title = paste("DAX monthly log-returns ", forTitle[2], " - ", forTitle[nrow(monthlyDAX)], sep = "")

# plot of the DAX monthly log-returns
plot(ts_returns, main = Title, t = "l", col = "blue3",
     xlab = "Date", ylab = "DAX log-returns", lwd = 1.5)
abline(h = 0, col = "darkgreen", lwd = 1.5)
