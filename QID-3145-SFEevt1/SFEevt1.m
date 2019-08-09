clear all
close all
clc

n     = 100;
sp    = 5;
xpos  = sp * (1:n)/n;
xneg  = - sp + xpos;
x     = [xneg,xpos]';
alpha = 1 / 2;
gumb  = [x gevpdf(x)];
frec  = [x gevpdf(x,alpha,0.5,1)];
weib  = [x gevpdf(x,-alpha,0.5,-1)];

hold on
plot(gumb(:,1), gumb(:,2), 'k', 'LineWidth', 2, 'LineStyle','-')
plot(frec(:,1), frec(:,2), 'r', 'LineWidth', 2, 'LineStyle',':')
plot(weib(:,1), weib(:,2), 'b', 'Linewidth', 2, 'LineStyle','-.')
title('Extreme Value Densities', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('X', 'FontSize', 16, 'FontWeight', 'Bold')
ylabel('Y', 'FontSize', 16, 'FontWeight', 'Bold')
t  = 0: 0.2: 1;
t1 = 0: 0.2: 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off

% print -painters -dpdf -r300 SFEevt1.pdf
% print -painters -dpng -r300 SFEevt1-1Matlab.png

