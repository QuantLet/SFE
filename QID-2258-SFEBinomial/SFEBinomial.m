clear all
close all
clc

disp('Please input [Probability, Number n] as: [0.5, 15]') ;
disp(' ') ;
para = input('[Probability, Number n] = ');
while length(para) < 2
    disp('Not enough input arguments. Please input in 1 * 2 vector form like [0.5, 15] or [0.5 15]');
    para = input('[Probability, Number n] = ');
end
p = para(1);
n = para(2);

x = 1:n;
subplot(2, 1, 1)
y = binopdf(x, n, p);

for i = 1:length(x)
    line([i, i],[0, y(i)], 'LineWidth', 5)
end
title('Binomial distribution') 

subplot(2, 1, 2)
z = binocdf(x, n, p);

for i = 1:length(x)
    line([i - 1, i], [z(i), z(i)], 'LineWidth', 3, 'Color', 'r')
end

% plot(x, z, '+')

disp('Please input [Value of x, Probability, Number n] as: [5, 0.5, 15]') ;
disp(' ') ;
para = input('[Value of x, Probability, Number n] = ');
while length(para) < 3
    disp('Not enough input arguments. Please input in 1 * 2 vector form like [5, 0.5, 15] or [5 0.5 15]');
    para = input('[Value of x, Probability, Number n] = ');
end
x1 = para(1);
p1 = para(2);
n1 = para(3);

disp(' ')
disp('Binomial distribution for the specified x, p, n')
disp(' ')
disp('P(X = x) = f(x) =')
binopdf(x1, n1, p1)
disp('P(X <= x) = F(x) =')
binocdf(x1, n1, p1)
disp('P(X >= x) = 1 - F(x - 1) =')
1 - binocdf(x1 - 1, n1, p1)
disp('P(X < x) = P(X <= x) - P(X = x) = P(X <= x - 1) = F(x - 1) =')
binocdf(x1 - 1, n1, p1)
disp('P(X > x) = P(X >= x) - P(X = x) = P(X >= x + 1) = 1 - F(x) =')
1 - binocdf(x1, n1, p1)