
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("pracma")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

bvnIntegrand = function(theta, b1, b2) {
    # Bivariate normal distribution | SUBROUNTINE of mvncdf() Integrand is 
    # exp(-(b1^2 + b2^2 - 2*b1*b2*sin(theta))/(2*cos(theta)^2) )
    sintheta = sin(theta)
    cossqtheta = cos(theta)^2  # always positive
    integrand = exp(-((b1 * sintheta - b2)^2/cossqtheta + b1^2)/2)
    return(integrand)
}

mvncdf = function(b, mu, sigma) {
    # MVNCDF Multivariate normal cumulative distribution function.  P = MVNCDF(B,
    # MU, SIGMA) returns the joint cumulative probability using numerical
    # integration. B is a vector of values, MU is the mean parameter vector, and
    # SIGMA is the covariance matrix.
    n = NROW(b)
    b = as.matrix(b)
    if (NCOL(b) != length(mu)) {
        stop("The first two inputs must be vectors of the same length.")
    }
    # Rho = sigma/(sqrt(diag(sigma))%*%t(sqrt(diag(sigma))))
    rho = sigma[2]
    if (rho > 0) {
        p1 = pnorm(apply(b, 2, min))
        p1[any(is.nan(b), 2)] = NaN
    } else {
        p1 = pnorm(b[, 1]) - pnorm(-b[, 2])
        p1[p1 < 0] = 0  # max would drop NaNs
    }
    if (abs(rho) < 1) {
        loLimit = asin(rho)
        hiLimit = sign(rho) * pi/2
        p2 = numeric()
        for (i in 1:n) {
            b1 = b[i, 1]
            b2 = b[i, 2]
            p2[i] = integral(function(x) bvnIntegrand(x, b1, b2), xmin = loLimit, 
                xmax = hiLimit, method = "Kronrod", reltol = 1e-10)
        }
    } else {
        p2 = rep(0, length(p1))
    }
    p = p1 - p2/(2 * pi)
    return(p)
}

CompCorrGaussModelCDO = function(a, R, defProb, UAP, LAP, DF, DayCount, trueSpread) {
    C = qnorm(defProb, 0, 1)
    NinvK = qnorm(UAP/(1 - R), 0, 1)
    A = (C - sqrt(1 - a^2) * NinvK)/a
    Sigma = matrix(c(1, -a, -a, 1), 2, 2)
    Mu = c(0, 0)
    EL1 = mvncdf(cbind(C, -A), Mu, Sigma)
    EL2 = pnorm(A)
    if (LAP == 0) {
        EL = EL1/UAP * (1 - R) + EL2
    } else {
        NinvL = qnorm(LAP/(1 - R), 0, 1)
        B = (C - sqrt(1 - a^2) * NinvL)/a
        EL3 = mvncdf(cbind(C, -B), Mu, Sigma)
        EL4 = pnorm(B)
        UpperETL = EL1 + EL2 * UAP/(1 - R)
        LowerETL = EL3 + EL4 * LAP/(1 - R)
        EL = (UpperETL - LowerETL)/(UAP - LAP) * (1 - R)
    }
    ProtectLeg = sum(diff(c(0, EL)) * DF)
    PremiumLeg = sum((1 - EL) * DF * DayCount)
    spread = ProtectLeg/PremiumLeg * 10000
    if (LAP == 0) {
        spread = (ProtectLeg - 0.05 * PremiumLeg) * 100
    }
    y = abs(spread - trueSpread)
    return(y)
}

# Main computation
index = 37.2416
trueSpread = c(20.45, 131.7, 59, 37.48, 22.7)
date = "10/22/2007"
Mat = "12/20/2012"
EffD = "9/20/2007"
recoveryR = 0.4
discountR = 0.03
daysYear = 365
periodspa = 4
UAP = c(0.03, 0.06, 0.09, 0.12, 0.22)
LAP = c(0, 0.03, 0.06, 0.09, 0.12)
day = as.Date(date, "%m/%d/%Y")
Mat = as.Date(Mat, "%m/%d/%Y")
EffD = as.Date(EffD, "%m/%d/%Y")
dayFoY = (day - EffD)/daysYear
delta = 1/periodspa
firstDayCount = delta - dayFoY
yn = floor((Mat - EffD)/daysYear)
DayCount = c(firstDayCount, rep(delta, periodspa * yn))
time = cumsum(DayCount)
lambda = index/10000/(1 - recoveryR)
DF = (1 + discountR/periodspa)^(-periodspa * time)
defProb = 1 - exp(-lambda * time)
sqrtCorr = matrix(0, 5, 1)
for (tr in 1:5) {
    sqrtCorr[tr] = fminbnd(function(x) CompCorrGaussModelCDO(x, recoveryR, defProb, 
        UAP[tr], LAP[tr], DF, DayCount, trueSpread[tr]), 0, 1)$x
}

# plot
plot(1:5, sqrtCorr^2, type = "l", lwd = 2, ylab = "Compound Correlation", xlab = "Tranches", 
    xlim = c(1, 5), ylim = c(0, 0.7))
txt = c("Equity", "Mezzanine Junior", "Mezzanine", "Senior", "Super Senior")
text(1 + 0.1, sqrtCorr[1]^2 + 0.04, txt[1])
text(2, sqrtCorr[2]^2 - 0.04, txt[2])
text(3, sqrtCorr[3]^2 + 0.04, txt[3])
text(4, sqrtCorr[4]^2 + 0.04, txt[4])
text(5, sqrtCorr[5]^2 + 0.04, txt[5], xpd = NA)