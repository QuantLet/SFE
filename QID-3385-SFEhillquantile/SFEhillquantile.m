%% clear all variables
clear all
close all
clc

disp('Please input Quantile q, and Excess k as [0.01, 10]');
disp(' ') ;
para = input('[q, k]=');
while length(para) < 2
  disp('Not enough input arguments. Please input in 1*2 vector form like [0.01, 10]');
  disp(' ') ;
  para = input('[q, k]=');
end
q = para(1);              % quantile
k = para(2);              % excess

if(k < 1 && k> n)
    error('SFEhillquantile: excess should be greater than 0 and less or equal than the number of elements.')
end
if(q < 0 && q> 1)
    error('SFEhillquantile: please give a rational quantile value.')
end

x    = gprnd(0.1,1,0,100,1); % generalized pareto random numbers
x    = sort(x);
n    = size(x,1);
rest = hillgp1(x,k);  % ML-estimation of gamma 
xest = x(k)+x(k)*(((n/k)*(1-q))^(-rest)-1) % Hill-quantil estimation
