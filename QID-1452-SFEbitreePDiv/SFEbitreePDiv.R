
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# input parameters
print("Please input Price of Underlying Asset s0, Exercise Price k, Domestic Interest Rate per Year i,")
print("Volatility per Year sig, Time to Expiration (Years) t, Number of steps n, type")
print("yields vector [s0, k, i, sig, t, n, type]=")
print("after 1. input the following: 230  210  0.04545  0.25  0.5  5  1")
print("then press enter two times")
para = scan()

while (length(para) < 7) {
    print("Not enough input arguments. Please input in 1*7 vector form like 230  210  0.04545  0.25  0.5  5  1")
    print(" ")
    print("[s0, k, i, sig, t, n, type]=")
    para = scan()
}

s0   = para[1]     # Stock price
k    = para[2]     # Exercise price
i    = para[3]     # Rate of interest
sig  = para[4]     # Volatility
t    = para[5]     # Time to expiration
n    = para[6]     # Number of intervals
type = para[7]     # 0 is American/1 is European

# Check conditions
if (s0 <= 0) {
    print("SFEBiTree: Price of Underlying Asset should be positive! Please input again. s0=")
    s0 = scan()
}
if (k < 0) {
    print("SFEBiTree: Exercise price couldnot be negative! Please input again. k=")
    k = scan()
}
if (sig < 0) {
    print("SFEBiTree: Volatility should be positive! Please input again. sig=")
    sig = scan()
}
if (t <= 0) {
    print("SFEBiTree: Time to expiration should be positive! Please input again. t=")
    t = scan()
}
if (n < 1) {
    print("SFEBiTree: Number of steps should be at least equal to 1! Please input again. n=")
    n = scan()
}

# input parameters
print(" ")
print("Please input option choice (1 for call, 0 for put) flag, Number of pay outs nodiv, time point of dividend payoff tdiv")
print("dividend rate in percentage of stock price as: [1 1 0.15 0.01]")
print("[flag, nodiv tdiv pdiv ]=")
para2 = scan()

while (length(para2) < (2 * para2[2] + 2)) {
    print("Not enough input arguments. Please input in 1*(2+2*nodiv) vector form like [1 1 0.15 0.01]")
    print("[flag nodiv tdiv pdiv ]=")
    para2 = scan()
}

flag  = para2[1]                                # 1 for call, 2 for put option choice
nodiv = para2[2]                                # Times of dividend payoff
tdiv  = para2[3:(nodiv + 2)]                    # Time point of dividend payoff
pdiv  = para2[(nodiv + 3):(nodiv + nodiv + 2)]  # Dividend in currency units

if (t < max(tdiv)) {
    print("SFEBiTree: Payoff shall happend before expiration! Please input tdiv again as [0.25 0.5]. tdiv=")
    tdiv = scan()
}
if (sum(pdiv) < 0) {
    print("SFEBiTree: Dividend must be nonnegative! Please input pdiv again as [1 1]. pdiv=")
    pdiv = scan()
}

# Main computation
dt        = t/n                                       # Interval of step
u         = exp(sig * sqrt(dt))                       # Up movement parameter u
d         = 1/u                                       # Down movement parameter d
b         = i                                         # Costs of carry
p         = 0.5 + 0.5 * (b - sig^2/2) * sqrt(dt)/sig  # Probability of up movement
tdivn     = floor(tdiv/t * n - 1e-04) + 1
s         = matrix(1, n + 1, n + 1) * s0
un        = rep(1, n + 1) - 1
un[n + 1] = 1
dm        = t(un)
um        = matrix(0, 0, n + 1)
j         = 1

while (j < n + 1) {
    d1 = cbind(t(rep(1, n - j) - 1), t((rep(1, j + 1) * d)^(seq(1, j + 1) - 1)))
    dm = rbind(dm, d1)  # Down movement dynamics
    u1 = cbind(t(rep(1, n - j) - 1), t((rep(1, j + 1) * u)^((seq(j, 0)))))
    um = rbind(um, u1)  # Up movement dynamics
    j  = j + 1
}

um = t(rbind(un, um))
dm = t(dm)
s  = s[1, 1] * um * dm  # stock price development
j  = 1

while (j <= nodiv) {
    s[, (tdivn[j] + 1):(n + 1)] = s[, (tdivn[j] + 1):(n + 1)] * (1 - pdiv[j])
    j = j + 1
}

Stock_Price = s
s   = s[nrow(s):1, ]
print(Stock_Price)  # Rearangement
opt = matrix(0, nrow(s), ncol(s))

# Option is an American call
if ((flag == 1) && (type == 0)) {
    opt[, n + 1] = pmax(s[, n + 1] - k, 0)  # Determine option values from prices
    loopv = seq(n, 1)
    for (j in loopv) {
        l = seq(1, j)
        # Probable option values discounted back one time step
        discopt = ((1 - p) * opt[l, j + 1] + p * opt[l + 1, j + 1]) * exp(-b * 
            dt)
        # Option value is max of current price - X or discopt
        opt[, j] = rbind(t(t(pmax(s[l, j] - k, discopt))), t(t(rep(0, n + 1 - j))))
    } 
    American_Call_Price = opt[nrow(opt):1, ]
    print(American_Call_Price)
    print(" ")
    print("The price of the option at time t_0 is")
    print(American_Call_Price[n + 1, 1])
}

if ((flag == 1) && (type == 1)) {
    # Option is a European call
    opt[, n + 1] = pmax(s[, n + 1] - k, 0)  # Determine option values from prices
    loopv = seq(n, 1)
    for (j in loopv) {
        l = seq(1, j)
        # Probable option values discounted back one time step
        discopt = ((1 - p) * opt[l, j + 1] + p * opt[l + 1, j + 1]) * exp(-b * 
            dt)
        # Option value
        opt[, j] = rbind(t(t(discopt)), t(t(rep(0, n + 1 - j))))
    }  
    European_Call_Price = opt[nrow(opt):1, ]
    print(European_Call_Price)
    print(" ")
    print("The price of the option at time t_0 is")
    print(European_Call_Price[n + 1, 1])
}

if ((flag == 0) && (type == 0)) {
    # Option is an American put
    opt[, n + 1] = pmax(k - s[, n + 1], 0)  # Determine option values from prices
    loopv = seq(n, 1)
    for (j in loopv) {
        l = seq(1, j)
        # Probable option values discounted back one time step
        discopt = ((1 - p) * opt[l, j + 1] + p * opt[l + 1, j + 1]) * exp(-b * 
            dt)
        # Option value is max of X - current price or discopt
        opt[, j] = rbind(t(t(pmax(k - s[l, j], discopt))), t(t(rep(0, n + 1 - j))))
    }  
    American_Put_Price = opt[nrow(opt):1, ]
    print(American_Put_Price)
    print(" ")
    print("The price of the option at time t_0 is")
    print(American_Put_Price[n + 1, 1])
}

if ((flag == 0) && (type == 1)) {
    # Option is a European put
    opt[, n + 1] = pmax(k - s[, n + 1], 0)  # Determine option values from prices
    loopv = seq(n, 1)
    for (j in loopv) {
        l = seq(1, j)
        # Probable option values discounted back one time step
        discopt = ((1 - p) * opt[l, j + 1] + p * opt[l + 1, j + 1]) * exp(-b * 
            dt)
        # Option value
        opt[, j] = rbind(t(t(discopt)), t(t(rep(0, n + 1 - j))))
    } 
    European_Put_Price = opt[nrow(opt):1, ]
    print(European_Put_Price)
    print(" ")
    print("The price of the option at time t_0 is")
    print(European_Put_Price[n + 1, 1])
}

