data    = load('dax99.dat');
dax99   = data(:,2);     % first line is date, second XetraDAX 1999
lndax99 = log(dax99);
ret     = diff(lndax99);

f = 'qua';% kernel function: quartic
N = 400;  % length of estimation vector
h = 0.03; % bandwidth

hold on
[xi fh] = kerndens(ret, h, N, f);

%[fh, xi] = ksdensity(ret, 'kernel','quartic','npoints', 400, 'width',0.03);
set(gca, 'ylim', [0 13], 'FontWeight', 'bold', 'FontSize', 16);
plot(xi, fh, 'b', 'LineWidth', 2)
xlim([-0.07 0.07])
title('DAX Density versus Normal Density', 'FontWeight', 'bold', 'FontSize', 16)

mu = mean(ret);                   %; empirical mean
si = sqrt(var(ret));              %; empirical standard deviation (std)
randn('seed', 100);
x  = normrnd(mu, si, 400, 1);     %; generate artifical data from the same mean and std

[xj, f]  = kerndens(x, h, N, f);  %; estimate its density
plot(xj, f, 'k', 'LineStyle', '-.', 'Linewidth', 2)
hold off
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');

print -painters -dpdf -r600 SFEdaxretDenNew.pdf
print -painters -dpng -r600 SFEdaxretDenNew.png
