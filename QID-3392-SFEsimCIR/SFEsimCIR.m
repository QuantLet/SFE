%% clear variables and console and close windows
clear
clc
close all

%% set parameters for the simulation
Tobs  = 360;
alpha = 5;
mu    = 1;
sigma = 0.2;

dt = 1/Tobs;

% initial value of X (X_0):
X(1) = mu;

% set a seed if you want this simmulation to be reproducible
% rng(123); 

%% simulates a mean reverting square root process around mu
for i = 1:Tobs
    dW = randn * sqrt(dt);
    dX = alpha * (mu - X(i)) * dt + sigma * sqrt(abs(X(i))) * dW;
    X  = [X, X(i) + dW];
end

X = X(2:end);

%% plot
t = (1:Tobs)/Tobs;
set(gcf,'color','w')
plot(t, X, 'Color', 'blue', 'LineWidth', 2)
title('Simulated CIR process')
xlabel('t')
ylabel('X_t')
