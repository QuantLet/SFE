% clear variables and close windows
clear all
close all
clc

x1 = load('FTSElevel(03.01.00-30.10.06).txt');
x2 = load('BAYERlevel(03.01.00-30.10.06).txt');
x3 = load('SIEMENSlevel(03.01.00-30.10.06).txt');
x4 = load('VWlevel(03.01.00-30.10.06).txt');

x1 = diff(log(x1(:, 1)));
n1 = length(x1);
x2 = diff(log(x2(:, 1)));
n2 = length(x2);
x3 = diff(log(x3(:, 1)));
n3 = length(x3);
x4 = diff(log(x4(:, 1)));
n4 = length(x4);

figure(1)
subplot(2, 2, 1)
plot(x1)
title('FTSE', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('')
ylabel('Log-Returns', 'FontSize', 16, 'FontWeight', 'Bold')
ylim([-.1, .1])
xlim([0, n1 + 1])
set(gca, 'Xtick', [1 : n1/2 : (n1 + 1)], 'XTickLabel', {0, n1/2, n1}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'Ytick', [-0.1 : 0.1 : 0.1], 'YTickLabel', {-10, 0, 10}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'LineWidth', 1.6)
box on

subplot(2, 2, 2)
plot(x2)
title('Bayer', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('')
ylabel('Log-Returns', 'FontSize', 16, 'FontWeight', 'Bold')
ylim([-.1, .1])
xlim([0, n2 + 1])
set(gca, 'Xtick', [1 : n2/2 : (n2 + 1)], 'XTickLabel', {0, n2/2, n2}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'Ytick', [-0.1 : 0.1 : 0.1], 'YTickLabel', {-10, 0, 10}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'LineWidth', 1.6)
box on

subplot(2, 2, 3)
plot(x3)
title('Siemens', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('')
ylabel('Log-Returns', 'FontSize', 16, 'FontWeight', 'Bold')
ylim([-.1, .1])
xlim([0, n3 + 1])
set(gca, 'Xtick', [1 : n3/2 : (n3 + 1)], 'XTickLabel', {0, n3/2, n3}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'Ytick', [-0.1 : 0.1 : 0.1], 'YTickLabel', {-10, 0, 10}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'LineWidth', 1.6)
box on

subplot(2, 2, 4)
plot(x4)
title('Volkswagen', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('')
ylabel('Log-Returns', 'FontSize', 16, 'FontWeight', 'Bold')
ylim([-.1, .1])
xlim([0, n4 + 1])
set(gca, 'Xtick', [1 : n4/2 : (n4 + 1)], 'XTickLabel', {0, n4/2, n4}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'Ytick', [-0.1 : 0.1 : 0.1], 'YTickLabel', {-10, 0, 10}, 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'LineWidth', 1.6)
box on