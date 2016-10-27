clear all
close all
clc

% user inputs parameters
disp('Please input method type as: 1 - Direct Integration, 2 - Euler Scheme') ;
disp(' ') ;
method = input('Input method ');
disp(' ') ;

% set parameters
n     = 1;
x0    = 0.84;
mu    = 0.02;
sigma = sqrt(0.1);
delta = 1 / 1000;

% main computation
t     = (0:ceil(n / delta));
sizet = size(t);
for i = 1:sizet(1, 2)
    aux(i) = 1;
end
x    = aux';
x(1) = x0;
no   = normrnd(0, 1, sizet(1, 2) - 1, 1) * sqrt(delta);

if method == 1 
    x = x0 * exp(cumsum((mu - 0.5 * sigma ^ 2) * delta + sigma .* no));
    x = [x0; x];
else
    i = 2;
    while (i <= sizet(1, 2))
        x(i) = x(i - 1) + mu * x(i - 1) * delta + sigma * x(i - 1) * no(i - 1);
        i    = i + 1;
    end
end

% output
plot(x)
title('Geometric Brownian Motion')
xlim([0 1000])