clear
clc
close all

%% Main computation
normaxis    = -5 : .1 : 15;
lognormaxis = 0.01 : .1 : 15;
n           = normpdf(normaxis);
ln          = normpdf(log(lognormaxis));

%% Plot

hold on

plot(normaxis, n, 'b', 'LineWidth', 2, 'LineStyle', '-');
plot(lognormaxis, ln, 'r', 'LineWidth', 2, 'LineStyle', '--');
axis([-5 15 0 0.5]);
title('Normal and Log Normal distributions'); 
xlabel('X')
ylabel('Y')

hold off

figure;
subplot(1, 2, 1);
plot(normaxis, n, 'b', 'LineWidth', 2, 'LineStyle', '-');
axis([-5 5 0 0.5])
title('Normal distribution'); 
xlabel('X')
ylabel('Y')

subplot(1, 2, 2);
plot(lognormaxis, ln, 'b', 'LineWidth', 2, 'LineStyle', '-');
axis([0 15 0 0.5])
title('Log normal distribution');
xlabel('X')
ylabel('Y')