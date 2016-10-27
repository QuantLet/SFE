clear all
close all
clc

% main computation
n      = 10000;
u      = unifrnd(0, 1, [10000, 1]);
u1     = unifrnd(0, 1, [10000, 1]);
theta  = 2 * pi * u1;
rho    = sqrt(-2 * log(u));
zeta1  = rho .* cos(theta);
zeta2  = rho .* sin(theta);
result = [zeta1 zeta2];

% create scatterplot
scatter(result(:, 1), result(:, 2), '.', 'k')
xlabel('Z_1')
ylabel('Z_2')

% define parameters of the distributions to display
v1 = var(result(:, 1));
v2 = var(result(:, 2));
m1 = mean(result(:, 1));
m2 = mean(result(:, 2));

% display parameters
disp('    Normal distribution 1')
disp('    Mean      Variance')
disp([m1 v1])
disp('    Normal distribution 2')
disp('    Mean      Variance')
disp([m2 v2])
