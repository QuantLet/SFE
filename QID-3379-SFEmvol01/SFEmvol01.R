# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Read data for FSE and LSE
DS  = read.table("FSE_LSE.dat")
D   = DS[, 1]                           # date
S   = DS[, 2:43]                        # S(t)
s   = log(S)                            # log(S(t))
end = dim(s)[1]                         # last observation
r   = s[2:end, ] - s[1:(end - 1), ]     # r(t)
n   = dim(r)[1]                         # sample size
t   = 1:n                               # time index, t

# Descriptive statistics for the DAX and FTSE 100 daily return processes
Y = rbind(cbind(min(r[, 1]), max(r[, 1]), mean(r[, 1]), median(r[, 1]), sd(r[, 1]/sqrt(n))), 
    cbind(min(r[, 22]), max(r[, 22]), mean(r[, 22]), median(r[, 22]), sd(r[, 22]/sqrt(n))))
colnames(Y) = c("Min", "Max", "Mean", "Median", "Std.Error")
rownames(Y) = c("DAX", "FTSE 100")
Y