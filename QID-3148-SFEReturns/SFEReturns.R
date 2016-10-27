
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fBasics", "tseries")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# load data
datax = read.table("sfm_pri.dat", header = FALSE)

msg1 = "This program calculates the first order auto correlation of returns, squared returns and absolute returns and skewness, kurtosis and the Bera Jarque statistic for german blue chips, 1974 - 1996"
print(msg1)

datax = as.matrix(datax)
stocks = as.matrix(c("all", "allianz", "basf", "bayer", "bmw", "cobank", "daimler", 
    "deutsche bank", "degussa", "dresdner bank", "hoechst", "karstadt", "linde", 
    "man", "mannesmann", "preussag", "rwe", "schering", "siemens", "thyssen", 
    "volkswagen"))
s = menu(stocks, graphics = TRUE, title = "Select one")
n = nrow(datax)
x = (datax[, s])
st = stocks[s]

# select all companies, if the first menu entry was selected
if (s == 1) {
    x = (datax[, 2:ncol(datax)])
    st = c(stocks[2:21])
}

x = as.matrix(x)
result = matrix(1, ncol = 7, nrow = ncol(x), dimnames = list(st, c("rho(ret):", 
    "rho n(ret^2):", "rho(|ret|):", "S:", "K:", "JB:", "JB p-value:")))
	
for (i in 1:ncol(x)) {
    # start calculation
    ret1 = log(x[2:n, i]) - log(x[1:(n - 1), i])
    skew = skewness(ret1)
    kurt = kurtosis(ret1)
    ret1 = as.matrix(ret1)
    ret2 = matrix(c(ret1^2))
    ret3 = matrix(c(abs(ret1)))
    n = nrow(ret1)
    rho1 = cor(ret1[2:n], ret1[1:(n - 1)])
    rho2 = cor(ret2[2:n], ret2[1:(n - 1)])
    rho3 = cor(ret3[2:n], ret3[1:(n - 1)])
    jb = jarque.bera.test(ret1)
    
    # end calculation
    result[i, 1] = rho1
    result[i, 2] = rho2
    result[i, 3] = rho3
    result[i, 4] = skew[1]
    result[i, 5] = kurt[1]
    result[i, 6] = jb[[1]]
    result[i, 7] = jb[[3]]
}

# Output
msg2 = "first order auto correlation of returns, squared returns and absolute returns and skewness, kurtosis and Bera Jarque statistic for german blue chips, 1974 - 1996"
print(msg2)
print("")
result 
