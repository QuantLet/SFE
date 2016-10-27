
clear all
close all
clc

format long
% main computation
y = 1:0.1:2; % estimation points
k=10; % order number 
n = 0;
sum = 0 ;
while (n<(k+1))
	sum = sum + ( (-1)^n ).*y.^(2*n+1)/( factorial(n)*2^n*(2*n+1) );
	n = n+1;
end
phi = 0.5 + sum/sqrt(2*pi);

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
title('Approximation to normal cdf d')
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
