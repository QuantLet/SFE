
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("matlab", "pracma")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data for FSE and LSE
DS = read.csv("FSE_LSE_2014.dat")
D  = DS[, 1]                           # date
S  = DS[, 2:43]                        # S(t)
r  = diff(as.matrix(log(S)))           # r(t) = log(S(t)) - log(S(t-1)) 
n  = length(r)                         # sample size
d  = NCOL(r)                           # columns or r

# Right tail index regression and Hill estimator
m1 = 10  # m1 largest observations
m2 = 25  # m2 largest observations

rsorted = apply(r, 2, sort, decreasing = TRUE)

x1 = log(rsorted[1:m1, ])
y1 = matrix(rep(log(c(1:m1)/n), d), ncol = d)

x2 = log(rsorted[1:m2, ]) 
y2 = matrix(rep(log(c(1:m2)/n), d), ncol = d)

ls1 = ls2 = hill1 = hill2 = numeric(d)

for (i in 1:d){
  ls1[i]   = lm(y1[, i] ~ x1[, i])$coef[2]
  ls2[i]   = lm(y2[, i] ~ x2[, i])$coef[2]
  hill1[i] = 1/(mean(x1[1:(m1-1), i]) - x1[m1, i])
  hill2[i] = 1/(mean(x2[1:(m2-1), i]) - x2[m2, i])
}

Y = cbind(-ls1, -ls2, hill1, hill2)
colnames(Y) = c("LS_m1", "LS_m2", "Hill_m1", "Hill_m2")
round(Y, 2)