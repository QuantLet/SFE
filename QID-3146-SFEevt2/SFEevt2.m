clear all
close all
clc

n = 100;

% Gumbel
gumb1 = gevrnd(0, 1, 0, 100, 1);
gumb2 = sort(gumb1);
gumb  = normcdf(gumb2, 0, 1);
t     = (1 : n) / (n + 1);

hold on
figure(1)
plot(t, t, 'r', 'LineWidth', 2)
scatter(gumb, t, '.', 'b')
t  = 0 : 0.2 : 1;
t1 = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
title('PP Plot of Extreme Value - Gumbel','FontSize', 16, 'FontWeight', 'Bold')
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off
% print -painters -dpdf -r600 SFEevt2_01.pdf
% print -painters -dpng -r600 SFEevt2_01.png

% Frechet
frec1 = gevrnd(0.5, 0.5, 1, 100, 1);
frec2 = sort(frec1);
frec  = normcdf(frec2, 0, 1);
t     = (1 : n) / (n + 1);

figure(2)
hold on
plot(t, t, 'r', 'LineWidth', 2)
scatter(frec, t, '.', 'b')
xlim([0 1])
ylim([0 1])
t  = 0 : 0.2 : 1;
t1 = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
title('PP Plot of Extreme Value - Frechet', 'FontSize', 16, 'FontWeight', 'Bold')
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off
% print -painters -dpdf -r600 SFEevt2_02.pdf
% print -painters -dpng -r600 SFEevt2_02.png

% Weibull
weib1 = gevrnd(-0.5, 0.5, -1, 100, 1);
weib2 = sort(weib1);
weib  = normcdf(weib2, 0, 1);
t     = (1 : n) / (n + 1);

figure(3)
hold on
plot(t, t, 'r', 'LineWidth', 2)
scatter(weib, t, '.', 'b')
xlim([0 1])
ylim([0 1])
title('PP Plot of Extreme Value - Weibull', 'FontSize', 16, 'FontWeight', 'Bold')
t  = 0 : 0.2 : 1;
t1 = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off

% print -painters -dpdf -r600 SFEevt2_03.pdf
% print -painters -dpng -r600 SFEevt2_03.png
