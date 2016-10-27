clear
data = load('SFEVaRBank.dat');
x    = data(:, 2);
v    = 1.96 * data(:, 4);
t    = 1:length(x);
dat  = [t', x];
dat2 = [t', v];
dat3 = [t', -v];

hold on
scatter(dat(:, 1), dat(:, 2), '.', 'k')
plot(dat2(:, 1), dat2(:, 2), 'LineWidth', 1)
plot(dat3(:, 1), dat3(:, 2), 'LineWidth', 1)

% In VaRest(y,method) "method" is:
%1 for RMA (rectangular moving average),
%2 for EMA (exponential moving average)
VaRma  = VaRest(x, 1);
k      = 251:(length(VaRma) + 250);

VaRma1 = [k', VaRma(:, 2)];
plot(VaRma1(:, 1), VaRma1(:, 2), 'Color', 'b', 'LineStyle', '--', 'LineWidth', 1)
VaRma2 = [k', VaRma(:,1)];
plot(VaRma2(:, 1), VaRma2(:, 2), 'Color', 'b', 'LineStyle', '--', 'LineWidth', 1)

% Exceedances from the year 1994
dat94  = dat(1:260, :);
l      = 1;
for i  = 1:length(dat94)
    if  or(dat94(i, 2) > dat2(i, 2), dat94(i, 2) < dat3(i, 2))
        exceed94(l, :) = dat94(i, 1:2);
        l = l + 1;
    end
end

scatter(exceed94(:, 1), exceed94(:, 2), '+', 'r')
scatter(exceed94(:, 1), exceed94(:, 2), 's', 'r')


% Exceedances from the year 1995
m = 1;
for i = 260:(length(x))
    if  or(dat(i, 2) > dat2(i, 2), dat(i, 2) < dat3(i, 2))
        exceed95(m, :) = dat(i, 1:2);
        m = m + 1;
    end
end

scatter(exceed95(:, 1), exceed95(:, 2), '+', 'k')
scatter(exceed95(:, 1), exceed95(:, 2), 's', 'k')

title('VaR and exceedances (1994-1995)')
xlabel('X')
ylabel('Y')
xlim([-10, 530])
hold off

