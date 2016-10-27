
clear
clc
close all

% user inputs parameters
disp('Please input lag value lag, value of beta1, value of beta2 as: [30, 0.5, 0.4]') 
disp(' ') ;
para=input('[lag, beta1, beta2]=');

while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [30, 0.5, 0.4] or [30 0.5 0.4]');
    para=input('[lag, beta1, beta2]=');
end

lag=para(1);
beta1=para(2);
beta2=para(3);

% main computation
randn('state', 0)                      % Start from a known state.
x = randn(10000, 1);                   % 10000 Gaussian deviates ~ N(0, 1).
y1 = filter([1 beta1 beta2], 1, x);    % Create an MA(2) process.
y2 = filter([1 beta1 -beta2], 1, x);   % Create an MA(2) process.
y3 = filter([1 -beta1 beta2], 1, x);   % Create an MA(2) process.
y4 = filter([1 -beta1 -beta2], 1, x);  % Create an MA(2) process.

subplot(2,2,1)
autocorr(y1, lag, [], 2);              % Plot ACF for β1 = 0.5, β2 = 0.4

subplot(2,2,2)
autocorr(y2, lag, [], 2);              % Plot ACF for β1 = 0.5, β2 = −0.4

subplot(2,2,3) 
autocorr(y3, lag, [], 2);              % Plot ACF for β1 = −0.5, β2 = 0.4

subplot(2,2,4)
autocorr(y4, lag, [], 2);              % Plot ACF for β1 = −0.5, β2 = −0.4
