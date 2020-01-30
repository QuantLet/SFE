%clear variables and close windows
clear all;
close all;
clc;

% Read data for FSE and LSE
DS = load('FSE_LSE.dat');
D  = [DS(:, 1)];                             % date
S  = [DS(:, 2 : 43)];                        % S(t)
s  = [log(S)];                               % log(S(t))
r  = [s(2 : end, :) - s(1 : (end - 1), :)];  % r(t)
n  = length(r);                              % sample size
t  = [1 : n];                                % time index, t

% Nonparametric volatility estimation, DAX
y  = [r(1 : (end - 1), 1) r(2 : end, 1)];
yy = [y(:, 1) y(:, 2).^2];
hm = 0.04;                                   % bandwidth
hs = 0.04;                                   % bandwidth

[m1h yg] = lpregest(y(:, 1), y(:, 2), 1, hm);      % estimate conditional mean function
[m2h yg] = lpregest(yy(:, 1), yy(:, 2), 1, hs);    % estimate conditional second moment 
sh       = [yg m2h(1, :)' - (m1h(1, :).^2)'];      % conditional variance
m1hx     = interp1(yg, m1h(1, :)', y(:, 1));       % interpolate mean
shx_DAX  = interp1(yg, sh(:, 2), y(:, 1));         % interpolate variance

figure
subplot(2, 1, 1)
plot(shx_DAX .^ 0.5); 
hold on;
title('DAX')
xlim([1 n])

% Nonparametric volatility estimation, FTSE 100
y  = [r(1 : (end - 1), 22) r(2 : end, 22)];
yy = [y(:, 1) y(:, 2).^2];
hm = 0.04;                                   % bandwidth
hs = 0.04;                                   % bandwidth

[m1h yg] = lpregest(y(:, 1), y(:, 2), 1, hm);      % estimate conditional mean function
[m2h yg] = lpregest(yy(:, 1), yy(:, 2), 1, hs);    % estimate conditional second moment 
sh       = [yg m2h(1, :)' - (m1h(1, :).^2)'];      % conditional variance
m1hx     = interp1(yg, m1h(1, :)', y(:, 1));       % interpolate mean
shx_FTSE = interp1(yg, sh(:, 2), y(:, 1));         % interpolate variance

subplot(2, 1, 2)
plot(shx_FTSE.^0.5); 
hold on;
title('FTSE 100')
xlabel('Time, t')
xlim([1 n])