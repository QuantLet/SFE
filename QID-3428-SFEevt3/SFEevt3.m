clear
close all
clc

n    = 150;
xf1  = evrnd(0, 1, n, 1);
xf   = sort(xf1);
t    = (1 : n) / (n + 1);
dat  = [evcdf(xf), t'];
dat2 = [t', t'];
hold on
scatter(dat(:, 1), dat(:, 2), '.')
plot(dat2(:, 1), dat2(:, 2), 'r', 'LineWidth', 2)
hold off
title('CDFs of Random Variables', 'FontSize', 16, 'FontWeight', 'Bold')
t    = 0 : 0.2 : 1;
t1   = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off

% print -painters -dpdf -r600 SFEevt3.pdf
% print -painters -dpng -r600 SFEevt3.png