clear all
close all
clc

index          = 37.2416;
trueSpread     = [20.45, 131.7, 59, 37.48, 22.7];
date           = '10/22/2007';  % Date
Mat            = '12/20/2012';  % Date of maturity
EffD           = '9/20/2007'; 
recoveryR      = 0.4;     % recovery rate
discountR      = 0.03;    % discount rate
daysYear       = 365;     % number of days per year
periodspa      = 4;
UAP            = [0.03, 0.06, 0.09, 0.12, 0.22]; % Upper attachment points
LAP            = [0, 0.03, 0.06, 0.09, 0.12];    % Lower attachment points
day            = datenum(date);
Mat            = datenum(Mat);
EffD           = datenum(EffD);
dayFoY         = (day - EffD) / daysYear;
delta          = 1 / periodspa;
firstDayCount  = delta - dayFoY;
yn             = floor((Mat - EffD) / daysYear);
DayCount       = [firstDayCount; delta * ones(periodspa * yn, 1)];
time           = cumsum(DayCount);
lambda         = index / 10000/(1 - recoveryR);
DF             = (1 + discountR / periodspa) .^ (-periodspa * time);
defProb        = 1 - exp(-lambda .* time);
sqrtBC         = zeros(5, 1);
for tr = 1:5;
    if tr < 2
    sqrtBC(tr) = fminbnd(@(x)BaseCorrGaussModelCDO(x, recoveryR, defProb, UAP(tr), LAP(tr), DF, DayCount, trueSpread(tr)), 0, 1);
    else
    LowerTLoss = lowerTrLossGauss(sqrtBC(tr - 1), recoveryR, defProb, LAP(tr));
    sqrtBC(tr) = fminbnd(@(x)BaseCorrGaussModelCDO(x, recoveryR, defProb, UAP(tr), LAP(tr), DF, DayCount, trueSpread(tr), LowerTLoss), 0, 1);
    end
end
plot([1:5]', sqrtBC .^ 2, 'k', 'LineWidth', 2)
ylabel('Base Correlation', 'FontSize', 16, 'FontWeight', 'Bold')
xlabel('Tranches', 'FontSize', 16, 'FontWeight', 'Bold')
set(gca, 'XTick', 1:5, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
xlim([1, 5]);
txt = ['Equity          '; 'Mezzanine Junior'; 'Mezzanine       '; 'Senior          '; 'Super Senior    '];
text(1 + 0.1, sqrtBC(1) .^ 2 - 0.02, txt(1, :), 'FontSize', 16, 'FontWeight', 'Bold')
text(2, sqrtBC(2) .^ 2 - 0.02, txt(2, :), 'FontSize', 16, 'FontWeight', 'Bold')
text(3, sqrtBC(3) .^ 2 - 0.02, txt(3, :), 'FontSize', 16, 'FontWeight', 'Bold')
text(4, sqrtBC(4) .^ 2 - 0.02, txt(4, :), 'FontSize', 16, 'FontWeight', 'Bold')
text(5 - 1, sqrtBC(5) .^ 2 + 0.02, txt(5, :), 'FontSize', 16, 'FontWeight', 'Bold')
ylim([0, 0.7])
t1  = [0:0.2:0.7];
set(gca, 'YTick', t1, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
set(gca, 'YTickLabel', t1, 'FontSize', 16, 'FontWeight', 'Bold', 'LineWidth', 1.6)
box on
hold off

% to save the plot in pdf or png please uncomment next 2 lines:

% print -painters -dpdf -r600 SFEbaseCorr.pdf
% print -painters -dpng -r600 SFEbaseCorr.png
