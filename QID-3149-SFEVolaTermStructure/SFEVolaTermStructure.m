clear
clc
close all

%Load data
x = load('implvola.dat');
x = x / 100;

dat1=[[1:8]; x(11, :)];
dat2=[[1:8]; x(31, :)];
dat3=[[1:8]; x(111, :)];
dat4=[[1:8]; x(231, :)];

%Plot different term structures of the implied volatility.
hold on

plot(dat1(1,:), dat1(2,:), 'Color','b', 'LineWidth', 2, 'LineStyle', '-')
plot(dat2(1,:), dat2(2,:), 'Color','g', 'LineWidth', 2, 'LineStyle', '--')
plot(dat3(1,:), dat3(2,:), 'Color','c', 'LineWidth', 2, 'LineStyle', ':')
plot(dat4(1,:), dat4(2,:), 'Color','r', 'LineWidth', 2, 'LineStyle', '-.')

scatter(dat1(1,:), dat1(2,:), 'k')
scatter(dat2(1,:), dat2(2,:), 'k')
scatter(dat3(1,:), dat3(2,:), 'k')
scatter(dat4(1,:), dat4(2,:), 'k')

hold off

title('Term Structure')
xlabel('Time')
ylabel('Percentage [%]')