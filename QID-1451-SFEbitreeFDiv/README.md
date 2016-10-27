
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="884" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEbitreeFDiv** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEbitreeFDiv

Published in : Statistics of Financial Markets

Description : 'Computes European/American option prices using a binomial tree for assets with fixed
amount dividends.'

Keywords : 'binomial, tree, asset, call, put, option, option-price, european-option, dividends,
financial, black-scholes'

See also : SFEbitreePDiv, SFEbitreeCDiv, SFSbitreeNDiv

Author : Awdesch Melzer, Piotr Majer, Ying Chen

Author[Matlab] : Ying Chen

Submitted : Fri, June 13 2014 by Felix Jung

Input: 
- n: Number of Intervals
- k: Exercise Price
- i: Interest Rate
- t: Time to Expiration
- type: 0 is American, 1 is European
- tdiv: Time Point of Dividend Payoff
- sig: Volatility
- pdiv: Dividend in Currency Units
- flag: 1 is call, 0 is Put
- nodiv: Times of Dividend Payoff
- s0: Stock Price

Output : binomial trees and price of option

Example : 'User inputs parameters [s0, k, i, sig, t, n, type] like [230, 210, 0.04545, 0.25, 0.5,
5, 1], [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as [1, 2, 0.25, 0.25, 1, 1], then call
price is shown.'

Example[Matlab] : 'User inputs the SFEbitreeCDiv parameters [s0, k, i, sig, t, n, type] like [230,
210, 0.04545, 0.25, 0.5, 5, 1], [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as [1, 2, 0.25,
0.25, 1, 1], then call price 28.7679 is shown.'

```


### R Code:
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

s0   = para[1]      # Stock price
k    = para[2]      # Exercise price
i    = para[3]      # Rate of interest
sig  = para[4]      # Volatility
t    = para[5]      # Time to expiration
n    = para[6]      # Number of intervals
type = para[7]      # 0 is American/1 is European

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

#  input parameters 
print(" ")
print("Please input option choice (1 for call, 0 for put) flag, Number of pay outs nodiv, time point of dividend payoff tdiv")
print("dividend in currency units for each time point pdiv as: [1 2 0.25 0.5 1 1]")
print("[flag, nodiv tdiv pdiv ]=")
para2 = scan()

while (length(para2) < (2 * para2[2] + 2)) {
    print("Not enough input arguments. Please input in 1*(2+2*nodiv) vector form like [1 2 0.25 0.5 1 1]")
    print("[flag, nodiv tdiv pdiv ]=")
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
m  = matrix(0, nrow(s), ncol(s))

while (j <= nodiv) {
    m[, (tdivn[j] + 1):(n + 1)] = m[, (tdivn[j] + 1):(n + 1)] - pdiv[j]
    j = j + 1
}
loopj = seq(n + 1, 1)
for (j in loopj) {
    hmat = rbind(s[j, 1:6] + m[j, 1:6], matrix(0, 1, n + 1))
    s[j, 1:6] = pmax(hmat[1, ], hmat[2, ])
}

Stock_Price = s
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
    # # Option is a European call
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
    # # Option is an American put
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
    # # Option is a European put
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

### MATLAB Code:
```matlab

clear;
clc;
close all;

%% user inputs parameters

disp('Please input Price of Underlying Asset s0, Exercise Price k, Domestic Interest Rate per Year i');
disp('Volatility per Year sig, Time to Expiration (Years) t, Number of steps n, type');
disp('as: [230, 210, 0.04545, 0.25, 0.5, 5, 1] or [100, 100, 0.1, 0.3, 1, 6, 1]');
disp(' ');
para=input('[s0, k, i, sig, t, n, type]=');
while length(para) < 7
    disp('Not enough input arguments. Please input in 1*7 vector form like [230, 210, 0.04545, 0.25, 0.5, 5, 1] or [100, 100, 0.1, 0.3, 1, 6, 1]');
    disp(' ');
    para=input('[s0, k, i, sig, t, n, type]=');
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
disp('Please input option choice (1 for call, 0 for put) flag, Number of pay outs nodiv, time point of dividend payoff tdiv');
disp('dividend in currency units for each time point pdiv as: [1, 2, 0.25, 0.5, 1,1], [1, 0, 0, 0, 0, 0] or [0, 2, 0.25, 0.75, 1, 1]');
disp(' ') ;
para2=input('[flag, nodiv tdiv pdiv ]=');

while length(para2) < (2*para2(1)+2)
    disp('Not enough input arguments. Please input in 1*(2+2*nodiv) vector form like [1, 2, 0.25, 0.5, 1,1], [1, 0, 0, 0, 0, 0] or [0, 2, 0.25, 0.75, 1, 1]');
    disp(' ');
    para2 = input('[flag, nodiv tdiv pdiv ]=');
end

flag  = para2(1);                              % 1 for call, 2 for put option choice
nodiv = para2(2);                              % Times of dividend payoff
tdiv  = para2(3:(nodiv+2));                    % Time point of dividend payoff
pdiv  = para2((nodiv+3):(nodiv+nodiv+2));      % Dividend in currency units

if t<max(tdiv)
    disp('SFEBiTree: Payoff shall happend before expiration! Please input tdiv again as [0.25, 0.5]')
    tdiv=input('tdiv=');
end
if pdiv<0
    disp('SFEBiTree: Dividend must be nonnegative! Please input pdiv again as [1,1]')
    pdiv=input('pdiv=');
end

%% main computation

dt    = t/n;                                    % Interval of step
u     = exp(sig*sqrt(dt));                      % Up movement parameter u
d     = 1/u;                                    % Down movement parameter d
b     = i;                                      % Costs of carry
p     = 0.5+0.5*(b-sig^2/2)*sqrt(dt)/sig;       % Probability of up movement
tdivn = floor(tdiv/t*n-0.0001)+1;

% dividend current value

D    = 0;
l    = 1;
nodi = nodiv;

while nodi>0
   
    D=D+exp(-b*tdiv(l))*pdiv(l);
    nodi=nodi-1;
    l=l+1;
end

%%%%adjusted stock price

s         = ones(n+1,n+1)*(s0-D);
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
s  = s(1,1).*um.*dm;                                  % Stock price development

% j=1;
% m=zeros(length(s));
% while (j<=nodiv)
%     m(:,(tdivn(j)+1):(n+1))=m(:,(tdivn(j)+1):(n+1))-pdiv(j);
%     j = j+1;
% end
% for j = n+1:-1:1;
%     s(j,:) = [max([s(j,:)+m(j,:);zeros(1,n+1)])];
% end
Stock_Price = s
s	    = flipud(s);                                       % Rearangement
opt 	    = zeros(size(s));

%% Option is a american call

if flag == 1 & type==0
    opt(:,n+1) = max(s(:,n+1)-k,0);                   % Determine option values from prices
    for j = n:-1:1;
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value is max of current price - X or discopt
        opt(:,j) = [max(s(1:j,j)-k,discopt);zeros(n+1-j,1)];
    end
    American_Call_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(American_Call_Price(n+1,1))

%% Option is a european call

elseif flag == 1 & type==1
    opt(:,n+1) = max(s(:,n+1)-k,0);               % Determine option values from prices
    for j = n:-1:1;
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value
        opt(:,j) = [discopt;zeros(n+1-j,1)];
    end
    European_Call_Price = flipud(opt)
    disp(' ');
    disp('The price of the option at time t_0 is')
    disp(European_Call_Price(n+1,1))

%% Option is an american put

elseif flag == 0 & type==0
    opt(:,n+1) = max(k-s(:,n+1),0);               % Determine option values from prices
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
    opt(:,n+1) = max(k-s(:,n+1),0);               % Determine option values from prices
    for j = n:-1:1
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value
        opt(:,j) = [discopt;zeros(n+1-j,1)];
    end
    European_Put_Price = flipud(opt)
    disp(' ');
    disp('The price of the option at time t_0 is')
    disp(European_Put_Price(n+1,1))
end
```
