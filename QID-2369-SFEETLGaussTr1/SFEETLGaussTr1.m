clear all
close all
clc

index     = 37.2416;
recoveryR =0.4;                            % Recovery rate
UAP       =[0.03, 0.06, 0.09, 0.12, 0.22]; % Upper attachment points
lam       = index / 10000 / (1 - recoveryR);
tr        = 1;
defProb   = 1 - exp(-lam);                % Default probability
rho       = 0.01:0.01:0.99;               % compound correlation
a         = sqrt(rho);                    % square-root of compound correlation
for i = 1:length(a)
etl(i, 1) = ETL(a(i), recoveryR, defProb, UAP(tr));
end

hold on
plot(rho, etl, 'k', 'LineWidth', 2)
xlabel('rho', 'FontSize', 16, 'FontWeight', 'Bold')
ylabel('ETL', 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'YTick', 0:0.05:0.15, 'FontSize', 16, 'FontWeight', 'Bold')
ylim([0, 0.15])
set(gca, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
t1  = [0:0.2:1];
set(gca, 'XTick', t1, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
set(gca, 'XTickLabel', t1, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
box on
hold off

% to save the plot in pdf or png please uncomment next 2 lines:
% print -painters -dpdf -r600 SFEETLGaussTr1.pdf
% print -painters -dpng -r600 SFEETLGaussTr1.png
