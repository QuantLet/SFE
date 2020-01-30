clear
close all
clc

RandStream.setGlobalStream(RandStream('mt19937ar', 'seed', 33));
disp('Please input Stock&#65533;s Initial Price S0, Interest Rate per Year r');
disp('Volatility per year vol');
disp('as:[100, 0.05, 0.03]');
disp(' ');
para = input('[S0, r, vol]=');

while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [100, 0.05, 0.03]');
    disp(' ');
    para = input('[S0, r, vol]=');
end

S0            = para(1); %Initial Stock Price
r             = para(2);  %Interest Rate per Year
vol           = para(3);%Volatility per Year
N             = 1000;
t             = (1:N) / N;
volatility    = vol * vol;
dt            = 1;
randomWt1     = normrnd(0, 1, N, 1);
Wtsum1        = cumsum(randomWt1);
Path1         = exp((r - 0.5 * volatility) * dt + vol * sqrt(dt) * Wtsum1);
StockPath1    = zeros(N, 1);
StockPath1(1) = S0;

for i = 2:N
    StockPath1(i) = S0 * Path1(i);
end

s    = StockPath1;
y    = zeros(N, 1);
y(1) = s(1);

for i = (2:N)
    if s(i) > y(1:i);
        y(i) = s(i);
    else
        y(i) = y(i-1);
    end
end

plot(t, StockPath1, 'blue', 'LineWidth', 2)
hold on
plot(t, y, 'red -.', 'LineWidth', 2)
hold on
ylabel('Asset Price')
title(' Simulated (St) vs. MaximumProcess (Mt)')
legend('St', 'Mt', 'Location', 'NorthWest')
hold off
