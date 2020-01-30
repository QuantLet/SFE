clear
close all
clc


% User inputs parameters
disp('Please input # of observations n, beta, gamma, mean m as: [100, 0.1, 0.01, 1]') ;
disp(' ') ;
para = input('[# of observations, beta, gamma, mean]=');
while length(para) < 4
    disp('Not enough input arguments. Please input in 1*4 vector form like [100, 0.1, 0.01, 1] or [100 0.1 0.01 1]');
    para=input('[# of observations, beta, gamma, mean]=');
end

n     = para(1);
beta  = para(2);
gamma = para(3);
m     = para(4);

% Simulates a mean reverting square root process around m
i     = 0;
delta = 0.1;
x     = m;        % start value
while (i<(n*10))
    i = i+1;
    d = beta*(m - x(length(x)))*delta + gamma*sqrt(delta)*randn(1);
    x = [x; x(length(x))+d];
end

x=x(2:length(x));
ind = 10*(1:1:n);
x = x(ind);
  
% Make plot
plot(x, 'LineWidth',2)
title('Simulated OU process','FontSize',16,'FontWeight','Bold');
xlabel('x','FontSize',16,'FontWeight','Bold')
box on
set(gca,'LineWidth',1.6,'FontSize',16,'FontWeight','Bold')