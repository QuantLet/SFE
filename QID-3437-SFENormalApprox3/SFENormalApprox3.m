
clear all
close all
clc

format long
% main computation
y = 1:0.1:2;
a1= 0.09979268; 
a2= 0.04432014; 
a3= 0.00969920; 
a4=-0.00009862; 
a5= 0.00058155;
t = abs(y);
s = 0.5 - 1.0./( 2.0 .* ( (1.0+a1.*t+a2.*t.^2+a3.*t.^3+a4.*t.^4+a5.*t.^5).^8 ) ); % computer s
phi = 0.5+s.*(-2*(y<0)+1); % if y<0, 0.5-s; if y>0, 0.5+s

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
title('Approximation to normal cdf c')
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
