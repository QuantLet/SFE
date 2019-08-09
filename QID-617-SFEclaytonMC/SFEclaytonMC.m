clear all
close all
clc

theta  = 0.79;     %dependence parameter of clayton copula
sample = 10000;    %sample size

% main computation
r   = gamrnd(theta^(-1), 1, sample, 1);
x1  = unifrnd(0, 1, sample, 1);
x2  = unifrnd(0, 1, sample, 1);
u1  = log(x1)./r;
u2  = log(x2)./r;
u   = [u1, u2];
g   = (1 - u).^(-(theta^(-1)));
rr1 = norminv(g(:, 1), 0, 1);
rr2 = norminv(g(:, 2), 0, 1);
rr  = [rr1, rr2];

% output
figure;
scatter(rr(:, 1), rr(:, 2), 'k', '.'); 
xlabel('X');
ylabel('Y');
title('Normal Marginal Distribution')
figure
scatter(g(:, 1), g(:, 2), 'k', '.');
xlabel('X');
ylabel('Y');
title('Uniform Marginal Distribution')