clear
clc
close all

% User inputs parameters

disp('Please input spot S, strike K, and interest r as: [98, 100, 0.05]') ;
disp(' ') ;
para = input('[spot price, strike price, interest rate] = ');

while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [98, 100, 0.05] or [98 100 0.05]');
    para = input('[spot price, strike price, interest rate] = ');
end

% spot price
S = para(1);

% strike price
K = para(2);

% interest rate
r = para(3);

disp(' ') ;
disp('Please input cost of carry b, and volatility sig, remaining time tau as: [0.05, 0.20, 20/52]') ;
disp(' ') ;
para2 = input('[cost of carry b, volatility sig, tau] = ') ;

while length(para2) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [0.05, 0.20, 20/52] or [0.05 0.20 20/52]');
    para2 = input('[cost of carry b, volatility sig, tau]=');
end

% cost of carry, volatility, remaining time
b   = para2(1);
sig = para2(2);
tau = para2(3);

% Main computation: Black-Scholes formula
y = (log(S / K) + (b - (sig^2) / 2) * tau) / (sig * sqrt(tau));
c = exp(-(r - b) * tau) * S * normcdf(y + sig * sqrt(tau)) - exp(-r * tau) * K * normcdf(y);

% Output

disp(' ') ;
disp('Asset price S = ')
disp(S)
disp('Strike K = ')
disp(K)
disp('Interest rate r = ')
disp(r)
disp('Costs of carry b = ')
disp(b)
disp('Volatility sigma = ')
disp(sig)
disp('Time to expiration tau = ')
disp(tau)
disp('Price of European Call = ')
disp(c)
