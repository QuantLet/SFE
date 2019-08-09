%Clear loaded variables and close graphics
clear all
close all
clc

p = 0.5;
n = 5;

bsamplem = binornd(1, 0.5, n, 1000);               %Random generation 
x1       = (mean(bsamplem) - p)/sqrt(p*(1 - p)/n);
[bden x] = ksdensity(x1);                          %Compute kernel density estimate

%Plot kernel density
hold on
plot(x, bden, 'Color', 'b', 'LineWidth', 4)
set(gca, 'FontWeight', 'bold')
set(gca, 'FontSize', 16)
xlabel('1000 Random Samples', 'FontSize', 16) 
ylabel('Estimated and Normal Density', 'Fontsize', 16)
ylim([0, 0.45])
xlim([-4, 4])
box on
plot(x, normpdf(x, 0, 1), 'Color', 'r', 'LineWidth', 4)  
set(gca, 'LineWidth', 1.6)
set(gca, 'TickLength', [0.015, 0.015])
str = sprintf('Asymptotic Distribution, n = %g ', n);
title(str, 'FontSize', 16)