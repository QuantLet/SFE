
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

#specify parameter settings for stock with continuous dividend payment:

s0   = 230     # Stock price
k    = 210     # Exercise price
i    = 0.04545 # Rate of interest
sig  = 0.25    # Volatility
t    = 0.5     # Time to expiration
n    = 5       # Number of intervals

type = 0       # 0 is American/1 is European
flag = 1       # 1 is call/0 is put

div  = 0.2     # Contionous dividend in percentage

# Main computation
dt        = t/n                                       # Interval of step
u         = exp(sig * sqrt(dt))                       # Up movement parameter u
d         = 1/u                                       # Down movement parameter d
b         = i                                         # Costs of carry
p         = 0.5 + 0.5 * (b - sig^2/2) * sqrt(dt)/sig  # Probability of up movement
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

um  = t(rbind(un, um))
s   = s[1, 1] * um * dm  # Stock price development
print("Stock_Price")
print(s)
s   = s[nrow(s):1, ]  # Rearangement
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