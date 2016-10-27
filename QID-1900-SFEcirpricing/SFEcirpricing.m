
clear
clc
close all

%% User inputs parameters

disp('Please input [a, b, sigma, tau, r] as: [0.221, 0.020, 0.055, 0.250, 0.020]');
disp(' ');
para=input('[a, b, sigma, tau, r] =');

while length(para) < 5
  disp('Not enough input arguments. Please input in 1*5 vector form like [0.221, 0.020, 0.055, 0.250, 0.020]');
  para=input('[a, b, sigma, tau, r] as =');
end

a=para(1);
b=para(2);
sigma=para(3);
tau=para(4);
r=para(5);

%% Main computation

phi  = sqrt(a^2+2*sigma^2);
g    = 2*phi + (a+phi)*(exp(phi*tau)-1);
B    = (2*(exp(phi*tau)-1))./g;
A    = 2*a*b/sigma^2*log(2*phi*exp((a+phi)*tau/2)./g);

Bondprice = exp(A-B*r);

disp('Bond price =')
disp(Bondprice)
 