clear
clc
close all

% user inputs parameters
disp('Please input lag value lag, value of alpha1 a as: [30, 0.9]') ;
disp(' ') ;
para = input('[lag, a] = ');
while length(para) < 2
    disp('Not enough input arguments. Please input in 1*2 vector form like [30, 0.9] or [30 0.9]');
    para = input('[lag, a] = ');
end
lag = para(1);
a   = para(2);

% main computation
randn('state', 0)              % Start from a known state.
x = randn(10000, 1);           % 10000 Gaussian deviates ~ N(0, 1).
y = filter(1, [1 -a], x);      % Create an AR(1) process.
autocorr(y, lag, [], 2);       % Plot