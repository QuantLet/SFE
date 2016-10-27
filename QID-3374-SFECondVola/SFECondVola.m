close all
clear all
clc

% create plot for FTSE
subplot(2, 2, 1)
x = load('ConVola(FIAPARCH)ftse.txt');
n = length(x);
plot(x)
box on
set(gca, 'LineWidth', 1.6, 'FontSize', 16, 'FontWeight', 'Bold')
hold on;

title('FTSE', 'FontSize', 16, 'FontWeight', 'Bold');
xlabel('');
ylabel('');
set(gca, 'XTick', [0:881:n], 'FontSize', 16, 'FontWeight', 'Bold')
xlim([0 n])

y = load('ConVola(HYGARCH)ftse.txt');
plot(y, '-r')
hold on;

% create plot for Bayer
subplot(2, 2, 2)
x = load('ConVola(FIAPARCH)bayer.txt');
n = length(x);
plot(x)
box on
set(gca, 'LineWidth', 1.6, 'FontSize', 16, 'FontWeight', 'Bold')
hold on;

title('Bayer', 'FontSize', 16, 'FontWeight', 'Bold');
xlabel('');
ylabel('');
set(gca, 'XTick', [0:881:n], 'FontSize', 16, 'FontWeight', 'Bold')
xlim([0 n])
ylim([0 70])

y = load('ConVola(HYGARCH)bayer.txt');

plot(y, '-r')
hold on;

% create plot for Siemens
subplot(2, 2, 3)
x = load('ConVola(FIAPARCH)siemens.txt');
n = length(x);
plot(x)
box on
set(gca, 'LineWidth', 1.6, 'FontSize', 16, 'FontWeight', 'Bold')
hold on;

title('Siemens', 'FontSize', 16, 'FontWeight', 'Bold');
xlabel('Time', 'FontSize', 16, 'FontWeight', 'Bold');
ylabel('');
set(gca, 'XTick', [0:881:n], 'FontSize', 16, 'FontWeight', 'Bold')
xlim([0 n])

y = load('ConVola(HYGARCH)siemens.txt');
plot(y, '-r')
hold on;

% create plot for VW
subplot(2, 2, 4)
x = load('ConVola(FIAPARCH)vw.txt');
n = length(x);
plot(x)
box on
set(gca, 'LineWidth', 1.6, 'FontSize', 16, 'FontWeight', 'Bold')
hold on;

title('Volkswagen', 'FontSize', 16, 'FontWeight', 'Bold');
xlabel('Time', 'FontSize', 16, 'FontWeight', 'Bold');
ylabel('');
set(gca, 'XTick', [0:881:n], 'FontSize', 16, 'FontWeight', 'Bold')
xlim([0 n])

y = load('ConVola(HYGARCH)VW.txt');
plot(y, '-r')
box on
set(gca, 'LineWidth', 1.6, 'FontSize', 16, 'FontWeight', 'Bold')
hold on;
