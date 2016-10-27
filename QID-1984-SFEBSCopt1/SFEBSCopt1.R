
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

ReadConsoleInput = function(prompt.message, bounds) {
    input = NA
    while (!is.numeric(input)) {
        input = as.numeric(sub(",", ".", readline(prompt = prompt.message)))
        if (!missing(bounds)) {
            if (length(bounds) > 1) {
                if (input < bounds[1] | input > bounds[2]) {
                  input = NA
                  cat("Error: value must lie between", bounds[1], "and", bounds[2], 
                    "n")
                }
            } else {
                if (input < bounds[1]) {
                  input = NA
                  cat("Error: value must lie at or above", bounds[1], "n")
                }
            }
        }
    }
    return(input)
}

# parameter settings
K   = 210
S   = 230
r   = 0.04545
b   = 0.04545
tau = 0.5
sig = 0.25

# Check whether user wants to use defaults
use.defaults = TRUE
cat("The default option parameters are:n")
cat("S =", S, "n")
cat("K =", K, "n")
cat("r =", r, "n")
cat("b =", b, "n")
cat("tau =", tau, "n")
cat("sig =", sig, "n")

while (TRUE) {
    user.input = readline("Would you like to use these default values (y/n)? ")
    if (!(user.input %in% c("y", "n"))) {
        cat("Invalid input: please use y or n to answer the question.n")
    } else {
        if (user.input == "y") {
            use.defaults = TRUE
        } else {
            use.defaults = FALSE
        }
        break
    }
}

if (use.defaults == FALSE) {
    S   = ReadConsoleInput("Please enter a stock price S: ", bounds = c(0))
    K   = ReadConsoleInput("Please enter a strike price K: ", bounds = c(0))
    r   = ReadConsoleInput("Please enter the risk free rate r: ", bounds = c(0))
    b   = ReadConsoleInput("Please enter the cost of carry b: ", bounds = c(-1, 1))
    sig = ReadConsoleInput("Please enter the stock price volatility sigma: ", bounds = c(0))
    tau = ReadConsoleInput("Please enter the time to maturity tau: ", bounds = c(0))
}

set.seed(0)

# Compute call price from approximation a
y  = (log(S/K) + (b - (sig^2)/2) * tau)/(sig * sqrt(tau))
ba = 0.332672527
t1 = 1/(1 + ba * y)
t2 = 1/(1 + ba * (y + sig * sqrt(tau)))
a1 = 0.17401209
a2 = -0.04793922
a3 = 0.373927817
norma1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3)) * exp(-y * y/2)
norma2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3)) * exp(-(y + sig * sqrt(tau))^2/2)
call.price.a = exp(-(r - b) * tau) * S * norma2 - exp(-r * tau) * K * norma1

# Compute call price from approximation b
bb = 0.231641888
t1 = 1/(1 + bb * y)
t2 = 1/(1 + bb * (y + sig * sqrt(tau)))
a1 = 0.127414796
a2 = -0.142248368
a3 = 0.71070687
a4 = -0.726576013
a5 = 0.530702714
normb1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3) + a4 * (t1^4) + a5 * (t1^5)) * 
    exp(-y^2/2)
normb2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3) + a4 * (t2^4) + a5 * (t2^5)) * 
    exp(-(y + sig * sqrt(tau))^2/2)
call.price.b = exp(-(r - b) * tau) * S * normb2 - exp(-r * tau) * K * normb1

# Compute call price from approximation c
a1 = 0.09979268
a2 = 0.04432014
a3 = 0.0096992
a4 = -9.862e-05
a5 = 0.00058155
t1 = abs(y)
t2 = abs(y + sig * sqrt(tau))
normc1 = 1/2 - 1/(2 * (1 + a1 * t1 + a2 * t1^2 + a3 * t1^3 + a4 * t1^4 + a5 * t1^5)^8)

if (y < 0) {
    normc1 = 0.5 - normc1
} else {
    normc1 = 0.5 + normc1
}

normc2 = 1/2 - 1/(2 * (1 + a1 * t2 + a2 * t2^2 + a3 * t2^3 + a4 * t2^4 + a5 * t2^5)^8)

if (y + sig * sqrt(tau) < 0) {
    normc2 = 0.5 - normc2
} else {
    normc2 = 0.5 + normc2
}

call.price.c = exp(-(r - b) * tau) * S * normc2 - exp(-r * tau) * K * normc1

# Compute call price from approximation d (Taylor expansion)
n    = 0
sum1 = 0
sum2 = 0

while (n <= 12) {
    sum1 = sum1 + (-1)^n * y^(2 * n + 1)/(factorial(n) * 2^n * (2 * n + 1))
    sum2 = sum2 + (-1)^n * (y + sig * sqrt(tau))^(2 * n + 1)/(factorial(n) * 2^n * 
        (2 * n + 1))
    n    = n + 1
}

normd1 = 0.5 + sum1/sqrt(2 * pi)
normd2 = 0.5 + sum2/sqrt(2 * pi)
call.price.d = exp(-(r - b) * tau) * S * normd2 - exp(-r * tau) * K * normd1

# Return option prices
cat("Price of European Call norm-a: ")
print(call.price.a)

cat("Price of European Call norm-b: ")
print(call.price.b)

cat("Price of European Call norm-c: ")
print(call.price.c)

cat("Price of European Call norm-d: ")
print(call.price.d)
