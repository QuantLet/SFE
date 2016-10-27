
clear
close all
clc

% user inputs parameters
disp('Please input steps n, paths k, Probability of up p as: [100, 1000, 0.5]');
disp(' ') ;

para=input('[n k p]=');

while length(para) < 3
  disp('Not enough input arguments. Please input in 1*3 vector form like [100, 1000, 0.5] or [100 1000 0.5]');
  disp(' ') ;
  para=input('[n k p]=');
end

n=para(1);
k=para(2);
p=para(3);
if (p>1)|(p<0)
  disp('Probability is to be between 0 and 1, please input p again!')
  p=input('p=');
end

% main computation
t=1:n;
trend=n*(2*p-1);
std=sqrt(4*n*p*(1-p));
rand('state',0);
z=rand(n,k);
z=((floor(-z+p))+0.5)*2;
x=sum(z); 
h = 0.3*(max(x)-min(x));
[f,xi] = ksdensity(x, 'width', h);      % Kernel-based density estimation with specified bandwidth
norm=std*randn(k,1)+trend;
[nf,nxi] = ksdensity(norm, 'width', h);

% plot
hold on
plot(xi, f,'LineWidth',2,'Color','b');
plot(nxi, nf,'LineWidth',2,'Color','r','LineStyle','-.');
legend('Normal','Binomial',2);
title(sprintf('Distribution of generated binominal processes'))  
hold off
