[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEbitreePDiv** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: SFEbitreePDiv

Published in: Statistics of Financial Markets

Description: 'Computes European/American option prices using a binomial tree for assets with dividends as a percentage of the stock price amount.'

Keywords: 'binomial, tree, asset, call, put, option, option-price, european-option, dividends, financial, black-scholes'

See also: SFEbitreeFDiv, SFEbitreeCDiv, SFSbitreeNDiv

Author[R]: Awdesch Melzer, Ying Chen

Author[Matlab]: Ying Chen

Author[Python]: Franziska Wehrmann

Submitted[R]: Tue, December 03 2013 by Awdesch Melzer
Submitted[Python]: Thu, January 30 2020 by Franziska Wehrmann


Input: 
- i : Interest Rate
- n : Number of Intervals
- pdiv : Dividends as a percentage of the stock price amount
- nodiv : Times of Dividend Payoff
- tdiv : Time Point of Dividend Payoff
- s0 : Stock Price
- t : Time to Expiration
- k : Exercise Price
- sig : Volatility
- flag : 1 is call, 0 is Put
- type : 0 is American, 1 is European

Output: binomial trees and price of option

Example[R]: 'User inputs parameters [s0, k, i, sig, t, n, type] like [230, 210, 0.04545, 0.25, 0.5, 5, 1], [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as [1, 1, 0.15, 0.01], then call price 28.3836 is shown.'

Example[Python]: 'Download .py file and run or copy-paste in jupyter notebook. Change variables in MAIN section of script (below definition of fuctions).'

```

### R Code
```r


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


```

automatically created on 2020-01-31

### MATLAB Code
```matlab

clear;
clc;
close all;

%% User inputs parameters

disp('Please input Price of Underlying Asset s0, Exercise Price k, Domestic Interest Rate per Year i');
disp('Volatility per Year sig, Time to Expiration (Years) t, Number of steps n, type');
disp('as: [230, 210, 0.04545, 0.25, 0.5, 5, 1] or [1.50, 1.50, 0.08, 0.2, 0.33, 6, 1]');
disp(' ');
para = input('[s0, k, i, sig, t, n, type]=');

while length(para) < 7
    disp('Not enough input arguments. Please input in 1*7 vector form like [230, 210, 0.04545, 0.25, 0.5, 5 ,1] or [1.50, 1.50, 0.08, 0.2, 0.33, 6, 1]');
    disp(' ');
    para = input('[s0, k, i, sig, t, n, type]=');
end

s0   = para(1);              % Stock price
k    = para(2);              % Exercise price
i    = para(3);              % Interest rate
sig  = para(4);              % Volatility
t    = para(5);              % Time to expiration
n    = para(6);              % Number of intervals
type = para(7);              % 0 is American/1 is European

%Check conditions 

if s0<=0
    disp('SFEBiTree: Price of Underlying Asset should be positive! Please input again')
    s0=input('s0=');
end
if k<0
    disp('SFEBiTree: Exercise price couldnot be negative! Please input again')
    k=input('k=');
end
if sig<0
    disp('SFEBiTree: Volatility should be positive! Please input again')
    sig=input('sig=');
end
if t<=0
    disp('SFEBiTree: Time to expiration should be positive! Please input again')
    t=input('t=');
end
if n<1
    disp('SFEBiTree: Number of steps should be at least equal to 1! Please input again')
    n=input('n=');
end

disp(' ');
disp('Please input option choice, Number of pay outs, time point of dividend payoff, ');
disp('dividend rate in percentage of stock price as: [1, 1, 0.15, 0.01]');
disp(' ');
para2 = input('[flag, nodiv tdiv pdiv ]=');

while length(para2) < (2*para2(2)+2)
    disp('Not enough input arguments. Please input in 1*(2+2*nodiv) vector form like [1, 1, 0.15, 0.01]');
    disp(' ');
    para2=input('[flag, nodiv, tdiv, pdiv ]=');
end

flag  = para2(1);                             % 1 for call, 2 for put option choice
nodiv = para2(2);                             % Times of dividend payoff
tdiv  = para2(3:(nodiv+2));                   % Time point of dividend payoff
pdiv  = para2((nodiv+3):(nodiv+nodiv+2));     % Dividends as a percentage of the stock price amount

if t<max(tdiv)
    disp('SFEBiTree: Payoff shall happend before expiration! Please input tdiv again as (1*ndiv) vector < t')
    tdiv = input('tdiv=');
end
if pdiv<0
    disp('SFEBiTree: Dividend must be nonnegative! Please input pdiv again as (1*ndiv) vector')
    pdiv = input('pdiv=');
end

%% Main computation
 
dt        = t/n;                                % Interval of step
u         = exp(sig*sqrt(dt));                  % Up movement parameter u
d         = 1/u;                                % Down movement parameter d
b         = i;                                  % Costs of carry
p         = 0.5+0.5*(b-sig^2/2)*sqrt(dt)/sig;   % Probability of up movement
tdivn     = floor(tdiv/t*n-0.0001)+1;
s         = ones(n+1,n+1)*s0;
un        = ones(n+1,1)-1;
un(n+1,1) = 1;
dm        = un';
um        = [];
j         = 1;

while j<n+1
    d1 = [ones(1,n-j)-1 (ones(1,j+1)*d).^((1:j+1)-1)];
    dm = [dm; d1];                                       % Down movement dynamics
    u1 = [ones(1,n-j)-1 (ones(1,j+1)*u).^((j:-1:0))];
    um = [um; u1];                                       % Up movement dynamics
    j  = j+1;
end

um = [un';um]';
dm = dm';
s  = s(1,1).*um.*dm;                                     % Stock price development
j  = 1;

while (j<=nodiv)
    s(:,(tdivn(j)+1):(n+1))=s(:,(tdivn(j)+1):(n+1))*(1-pdiv(j));
    j = j+1;
end

Stock_Price = s;
disp('Stock_Price')
disp(s)

s   = flipud(s);                                       % Rearrangement
opt = zeros(size(s));

%% Option is a american call

if flag == 1 & type==0                            
    opt(:,n+1) = max(s(:,n+1)-k,0);                % Determine option values from prices
    for j = n:-1:1;
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value is max of current price - X or discopt
        opt(:,j) = [max(s(1:j,j)-k,discopt);zeros(n+1-j,1)];
    end
    American_Call_Price = flipud(opt)
    disp(' ');
    disp('The price of the option at time t_0 is')
    disp(American_Call_Price(n+1,1))
   
%% Option is a european call    

elseif flag == 1 & type==1                        
    opt(:,n+1) = max(s(:,n+1)-k,0);                   % Determine option values from prices
    for j = n:-1:1;
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value
        opt(:,j) = [discopt;zeros(n+1-j,1)];
    end
    European_Call_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(European_Call_Price(n+1,1))
   
%% Option is an american put  

elseif flag == 0 & type==0                          
    opt(:,n+1) = max(k-s(:,n+1),0);                   % Determine option values from prices
    for j = n:-1:1
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value is max of X - current price or discopt
        opt(:,j) = [max(k-s(1:j,j),discopt);zeros(n+1-j,1)];
    end
    American_Put_Price = flipud(opt)
    disp(' ');
    disp('The price of the option at time t_0 is')
    disp(American_Put_Price(n+1,1))
   
%% Option is a european put

elseif flag == 0 & type==1                        
    opt(:,n+1) = max(k-s(:,n+1),0);                   % Determine option values from prices
    for j = n:-1:1
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value
        opt(:,j) = [discopt;zeros(n+1-j,1)];
    end
    European_Put_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(European_Put_Price(n+1,1))
end
```

automatically created on 2020-01-31

### PYTHON Code
```python

import numpy as np 

def calc_parameters(T, N, sigma, r, div):
    """
    Calculates the dependent parameters of the Binomial Tree (CRR)
    input:
      T     : time to maturity
      N     : number of steps of the tree
      sigma : volatility
      r     : interest rate 0.05 = 5%
      div   : cuntinuous dividend 0.03 = 3%
    output: 
      dt    : size of time step
      u     : factor of upwards movement of stock
      d     : factor of downwards movement of stock
      q     : risk-neutral probability
      b     : cost of carry
    """
    dt = T/N
    u = np.exp(sigma*np.sqrt(dt))
    d = 1/u
    b = r-div
    q = 1/2 + 1/2 * (b - 1/2 * sigma**2)*np.sqrt(dt)/sigma # P(up movement)
    return(dt, u, d, q, b)


def set_factor(t,t_div,div):
    """
    Determines the factor of dividend with which the stock is multiplied
    input:
      t      : current time
      div    : discrete dividend 0.03 = 3%
      t_div  : time point on which dividend is issued 
    output:
      factor with which the stock price is multiplied
    """
    if t>t_div : 
        factor = 1-div
    elif t<=t_div:
        factor = 1
    return factor


def calc_price(S0, K, u, d, N, r, dt, q, disc_div, disc_div_t, option):
    """
    Uses Backpropergation to calculate the option price of an European or 
    American option, saves the stock and option prices of the tree
    input:
      S0, K, u, d, N, r, dt, q: parameters of the Binomial Tree (CRR) Model
                                as in function calc_parameters      
      disc_div        : discrete dividend 0.03 = 3%
      disc_div_t      : time point when dividend is issued
      option          : 'Call', 'Put'
    output:
      asset_values    : The asset values from t=T to t=0 
      option_values   : The option values from t=T to t=0
      time_idx_values : Time step indices to the values above
      price           : price of the option
    """
    # calculate the values at maturity T
    # factor: 1-div for t > t_div, else: 1
    factor = set_factor(T, disc_div_t, disc_div)
    asset_values = factor * S0*(u**np.arange(N,-1,-1))*(d**np.arange(0,N+1,1))
    if option == 'Call':
        option_values = (np.maximum((asset_values-K),0)).tolist()
    elif option == 'Put':
        option_values = (np.maximum((K-asset_values),0)).tolist()
    asset_values = asset_values.tolist()

    #Using the recursion formula for pricing in the CRR model: 
    for n in np.arange(N-1,-1,-1):  # from (T-dt, T-2*dt, ...., dt, 0)
        factor = set_factor(n*dt, disc_div_t, disc_div)
        asset_val_temp = factor*(S0*(u**np.arange(n,-1,-1))*
                                 (d**np.arange(0,n+1,1)))
        option_val_temp =  (np.exp(-1*r*dt)
                            * (q*np.array(option_values[-(n+2):-1]) 
                               + (1-q)*np.array(option_values[-(n+1):])))
        asset_values += asset_val_temp.tolist()
        option_values += option_val_temp.tolist()
    
    price = option_values[-1]
    
    return asset_values, option_values, price


####### MAIN ################

S0     = 230      # current stock price
K      = 210      # strike price
T      = 0.50     # time to maturity
sigma  = 0.25     # volatility
r      = 0.04545  # interest rate
div    = 0        # continuous dividend
disc_div, disc_div_t = (0.01, 0.15)  # (div, t). after t: S(t)=(1-div_1)*S(t)
N      = 5        # steps in tree
option = 'Call'  

# calculate price 
dt, u, d, q, b = calc_parameters(T, N, sigma, r, div)
asset_values, option_values, price = calc_price(S0, K, u, d, N, 
                                                r, dt, q, 
                                                disc_div, disc_div_t, option)
print(price)

```

automatically created on 2020-01-31