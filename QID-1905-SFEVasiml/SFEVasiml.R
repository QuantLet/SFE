
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("neldermead")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

Vasimle = function(Params) {
    end = length(x)
    s1 = x[2:end]
    s2 = x[1:(end - 1)]
    delta = 1/252
    a = Params[1]
    b = Params[2]
    sigma = Params[3]
    n = length(s1)
    v = (sigma^2 * (1 - exp(-2 * a * delta)))/(2 * a)
    f = s1 - s2 * exp(-a * delta) - b * (1 - exp(-a * delta))
    lnL = (n/2) * log(2 * pi) + n * log(sqrt(v)) + sum((f/sqrt(v))^2)/2
    return(lnL)
}

# load data
x = read.table("yield_US3month9808.txt")
x = x[1:2600, 1]/100

n = length(x) - 1
end = length(x)
delt = 1/252

# Least square innitial estimation
X1 = sum(x[1:(end - 1)])
X2 = sum(x[2:end])
X3 = sum(x[1:(end - 1)]^2)
X4 = sum(x[1:(end - 1)] * x[2:end])
X5 = sum(x[2:end]^2)

c = (n * X4 - X1 * X2)/(n * X3 - X1^2)
d = (X2 - c * X1)/n
sd = sqrt((n * X5 - X2^2 - c * (n * X4 - X1 * X2))/n/(n - 2))

lambda = -log(c)/delt
mu = d/(1 - c)
sigma = sd * sqrt(-2 * log(c)/delt/(1 - c^2))

InitialParams = c(lambda, mu, sigma)

# optimize the Likelihood function
options = optimset(method = "fminsearch", MaxIter = 300, MaxFunEvals = 300, Display = "iter", 
    TolFun = c(1e-04), TolX = c(1e-04))

yhat = fminsearch(Vasimle, x0 = InitialParams, options)

Results = NULL
Results$Params = yhat$x
Results$Fval = -yhat$fval/n
Results$Exitflag = yhat$Exitflag

a = yhat$x[1]
b = yhat$x[2]
sigma = yhat$x[3]

# Estimates
rbind(a, b, sigma)
print(paste("log-likelihood = ", Results$Fval))
