clear all
close all
clc

format long
% user inputs parameters
disp('Please input spot S, strike K, and interest r as: [230, 210, 0.04545]') ;
disp(' ') ;
para = input('[spot price, strike price, interest rate]=');
while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [230, 210, 0.04545] or [230 210 0.04545]');
    para = input('[spot price, strike price, interest rate] = ');
end

% spot price
S = para(1);

% strike price
K = para(2);

% interest rate
r = para(3);

disp(' ') ;
disp('Please input cost of carry b, and volatility sig, remaining time tau as: [0.04545, 0.25, 0.5]') ;
disp(' ') ;

para2 = input('[cost of carry b, volatility sig, tau]=') ;
while length(para2) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [0.04545, 0.25, 0.5] or [0.04545 0.25 0.5]');
    para2 = input('[cost of carry b, volatility sig, tau] = ');
end

% cost of carry, volatility, remaining time
b   = para2(1);
sig = para2(2);
tau = para2(3);

% main computation
y   = (log(S / K) + (b - (sig^2) / 2) * tau ) / (sig * sqrt(tau));

% norm a
ba     = 0.332672527;
t1     = 1 / (1 + ba * y);
t2     = 1 / (1 + ba *(y + sig * sqrt(tau)));
a1     = 0.17401209;
a2     = -0.04793922;
a3     = 0.373927817;
norma1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3)) * exp(-y .* y / 2);
norma2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3)) * exp(-(y + sig * sqrt(tau))^2 / 2);
ca     = exp(-(r - b) * tau) * S * norma2 - exp(-r * tau) * K * norma1;

% norm b
bb     = 0.231641888;
t1     = 1 / (1 + bb * y);
t2     = 1 / (1 + bb * (y + sig * sqrt(tau)));
a1     = 0.127414796;
a2     = -0.142248368;
a3     = 0.71070687;
a4     = -0.726576013;
a5     = 0.530702714;
normb1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3) + a4 * (t1^4) + a5 * (t1^5)) * exp(-y^2 / 2);
normb2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3) + a4*(t2^4) + a5*(t2^5)) * exp(-(y + sig * sqrt(tau))^2 / 2);
cb     = exp(-(r - b) * tau) * S * normb2 - exp(-r * tau) * K * normb1;

% norm c
a1     = 0.09979268; 
a2     = 0.04432014; 
a3     = 0.00969920; 
a4     = -0.00009862; 
a5     = 0.00058155;
t1     = abs(y);
t2     = abs(y + sig * sqrt(tau));

normc1 = 1.0 / 2.0 - 1.0 / ( 2.0 * ( (1.0 + a1 * t1 + a2 * t1^2 + a3 * t1^3 + a4 * t1^4 + a5 * t1^5)^8 ));
if y < 0
    normc1 = 0.5 - normc1;
else
    normc1 = 0.5 + normc1;	
end

normc2 = 0.5 - 1.0 / (2.0 * ( (1.0 + a1 * t2 + a2 * t2^2 + a3 * t2^3 + a4 * t2^4 + a5 * t2^5)^8 ))
if (y + sig * sqrt(tau)) < 0
    normc2 = 0.5 - normc2;
else
    normc2 = 0.5 + normc2;	
end
cc = exp(-(r - b) * tau) * S * normc2 - exp(-r * tau) * K * normc1;

% norm d
n    = 0;
sum1 = 0;
sum2 = 0;
while n <= 12
    sum1 = sum1 + ((-1)^n) * y^(2 * n + 1)/(factorial(n) * 2^n * (2 * n + 1));
	  sum2 = sum2 + ((-1)^n) * (y + sig * sqrt(tau))^(2 * n + 1) / (factorial(n) * 2^n * (2 * n + 1));
	  n    = n + 1;
end

normd1 = 0.5 + sum1 / sqrt(2 * pi);
normd2 = 0.5 + sum2 / sqrt(2 * pi);

cd = exp(-(r - b) * tau) * S * normd2 - exp(-r * tau) * K * normd1;


% output
disp(' ');
disp('Price of European Call norm-a =')
disp(ca)
disp(' ');
disp('Price of European Call norm-b =')
disp(cb)
disp(' ');
disp('Price of European Call norm-c =')
disp(cc)
disp(' ');
disp('Price of European Call norm-d =')
disp(cd)
