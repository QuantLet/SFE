
clear
close all
clc
RandStream.setGlobalStream(RandStream('mt19937ar','seed',98));

S0  = 100;  % Initial Stock Price
r   = 0.05; % Interest Rate per Year
vol = 0.03; % Volatility per Year
b   = 25;   % Barrier
N   = 1000; % Number of observations

t           = (1:N)/N;
volatility  = vol*vol;
dt          = 1;
randomWt1   = normrnd(0, 1, N, 1);
randomWt2   = normrnd(0, 1, N, 1);
Wtsum1      = cumsum(randomWt1);
Wtsum2      = cumsum(randomWt2);
Path1       = exp((r-0.5*volatility)*dt+vol*sqrt(dt)*Wtsum1);
Path2       = exp((r-0.5*volatility)*dt+vol*sqrt(dt)*Wtsum2);

%save stock path in vector
StockPath1    = zeros(N,1);
StockPath2    = zeros(N,1);
StockPath1(1) = S0;
StockPath2(1) = S0;

for i=2:N
    StockPath1(i)=S0*Path1(i);
    StockPath2(i)=S0*Path2(i);
end

plot([1/N 1], [b b], 'black', 'LineWidth', 2)
hold on
h = find(StockPath1<b,1,'first');
plot(t,StockPath1, 'blue', 'LineWidth', 2)
hold on     
plot(t(h:end),StockPath1(h:end), 'red', 'LineWidth', 2)
hold on
hh = find(StockPath2 < b, 1, 'first');
plot(t, StockPath2, 'blue', 'LineWidth', 2)
hold on
plot(t(hh:end), StockPath2(hh:end), 'red', 'Linewidth', 2)
hold on
ylabel('Asset Price');
hold off
