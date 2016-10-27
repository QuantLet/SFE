clc;
close all;
clear all;

a  = load('BAYER_close_0012.dat');
b  = load('BMW_close_0012.dat');
c  = load('SIEMENS_close_0012.dat');
d  = load('VW_close_0012.dat');

e  = a + b + c + d;
x  = log(e(1:end - 1)) - log(e(2:end)); %negative log-returns
n  = length(x)
x  = sort(x, 'descend'); %from positive losses to negative profits
k  = 100;
x1 = x(1:k, :);

%empirical mean excess function
t = x(1:k + 1); %t must be >0
for i = 1:length(t)
    y = x(find(x > t(i)));
    MEF(i) = mean(y - t(i));
end

plot(t, MEF, 'Linewidth', 1.5)

%mean excess function of generalized Pareto distribution, theorem 18.8
theta = x(k + 1);
z     = x(1:k) - theta;
params= gpfit(z);
K     = params(1)
sigma = params(2);
gpme  = (sigma + K * (t - mean(t))) ./ (1 - K);

hold on
plot(t,gpme, 'k', 'Linewidth', 1.5, 'Linestyle', ':')

%Hill estimator, mean excess function of Pareto distribution
alphaH = (mean(log(x1)) - log(x1(k))) ^ (-1)
sigmaH = x1(k) * (k / n) ^ (1 / alphaH);
gp1me  = t ./ (alphaH - 1)

plot(t, gp1me, 'r', 'Linewidth', 1.5, 'Linestyle','--')
title('Mean Excess Functions', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('u', 'FontSize', 16, 'FontWeight', 'Bold')
ylabel('e(u)', 'FontSize', 16, 'FontWeight', 'Bold')
set(gca,'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
t   = [0:0.1:0.3];
set(gca, 'YTick', t, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
set(gca, 'YTickLabel', t, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
t1  = [0:0.05:0.3];
set(gca, 'XTick', t1, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
set(gca, 'XTickLabel', t1, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
ylim([0, max(MEF)])
xlim([0.04, 0.2])
box on
hold off

% to save the plot in pdf or png please uncomment next 2 lines:

% print -painters -dpdf -r600 SFEMeanExcessFun.pdf
% print -painters -dpng -r600 SFEMeanExcessFun.png
