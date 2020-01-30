
clear all
close all
clc

format long
% main computation
y = 1:0.1:2 ;
b = 0.332672527;
a1= 0.17401209;
a2=-0.04793922;
a3= 0.373927817;
t = 1./(1 + b.*y);
phi = 1 - (a1.*t+a2.*t.^2+a3.*t.^3).*exp(-y.*y/2);

% output
disp(' ') ;
disp('Estimation Points')
disp(y)
disp('Estimated Normal CDF')
disp(phi)

subplot(1,2,1)
hold on
plot(y,phi,'LineWidth',2);
xlabel('x')
ylabel('cdf')
title('Approximation to normal cdf a')
scatter(y,phi,'r','o')
hold off

subplot(1,2,2)
axis off
hold on
w1=num2str(y','%10.2f');
w2=num2str(phi','%11.10f');
text(0.1,0.8,w1)
text(0.5,0.8,w2)
hold off
