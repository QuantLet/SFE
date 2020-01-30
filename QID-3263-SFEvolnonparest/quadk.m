function y = quadk(x)
I = (x.*x < 1);
x = x.*I;
y = (15/16) * I.* (1 - x.*x).^2;

