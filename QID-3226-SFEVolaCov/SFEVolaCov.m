clear
clc
close all

%Load data
x = load('implvola.dat');

x = x / 100;
n = length(x);

%Calculate first differences and calculate the covariance matrix.
z = x(2:n, :) - x(1:(n - 1), :);
s = cov(z) * 100000;

disp('Empirical Covariance Matrix')
disp('      Sub 1    Sub 2     Sub 3     Sub 4     Sub 5     Sub 6     Sub 7     Sub 8')
disp(s)