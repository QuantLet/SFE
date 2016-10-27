
clear
close all
clc

%% user inputs parameters
disp('Please input Spot date t0, Capital V, Floor F and Expiry date T as: [0, 100000, 95000, 2]') ;
disp(' ') ;
para=input('[Spot date, Capital, Floor, Expiry date]=');

while length(para) < 4
  disp('Not enough input arguments. Please input in 1*4 vector form like [0, 100000, 95000, 2] or [0 100000 95000 2]');
  para=input('[Spot date, Capital, Floor, Expiry date]=');
end

t0=para(1);
V=para(2);
F=para(3);
T=para(4);

disp(' ') ;
disp('Please input Spot stock price s0, Interest r, Volatility sig, and Dividend D as: [100, 0.1, 0.3, 0.02]') ;
disp(' ') ;
para2=input('[Spot price, Interest, Volatility, Dividend]=') ;

while length(para2) < 4
  disp('Not enough input arguments. Please input in 1*4 vector form like [100, 0.1, 0.3, 0.02] or [100 0.1 0.3 0.02]');
  para2=input('[Spot price, Interest, Volatility, Dividend]=');
end

s0=para2(1);
r=para2(2);
sig=para2(3);
d=para2(4);
tau=T-t0;		    % maturity tau=T-to
b=r-d;              % costs of carry

%% main computation: Newton's method

k=0.001;			% initial exercise price
t=100;				% initial difference between two ks
while (t>=0.00001)						                % acceptable value for difference
y=(log(s0/k)+(b-1/2*(sig^2))*tau)/(sig*sqrt(tau));      % y for BS 
yk=-1/(sig*sqrt(tau)*k);                                % FOC of y respect to k
cdfnyk1=-exp(-1*y^2/2).*(yk/sqrt(2*pi));                % FOC of PI(-y) respect to k
cdfnyk2=-exp(-1*(y+sig*sqrt(tau))^2/2).*(yk/sqrt(2*pi));% FOC of PI(-y-sig*sqrt(tau))

pk=exp(-r*tau)*k.*normcdf(-1*y)-exp((b-r)*tau)*s0*normcdf(-1*y-sig*sqrt(tau));        % BC's put option price 
pkk=exp(-r*tau)*normcdf(-1*y)+exp(-1*r*tau)*k.*cdfnyk1-exp((b-r)*tau)*s0*cdfnyk2;  % FOC of put price respect to k
fk=exp(-d*tau)*s0+pk-V/F*k;                             % equation 2-23 see page 30
fkk=pkk-V/F;                                            %FOC of equation respect to k
k0=k;               % old k
k=k-fk/fkk;         % new k
t=k-k0;             % difference 
end

%% output

disp(' ') ;
disp('The exercise price applying NEWTON method =')
disp(k)
disp(' ') ;
disp('The BS put option price =')
disp(pk)