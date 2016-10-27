
clear
clc
close all

%Load data
x = load('implvola.dat');
x = x * 100;

%Calculate first differences and determine the eigenvectors.
n     = length(x);
z     = x(2:n, :) - x(1:(n - 1), :);
s     = cov(z) * 100000;
[v e] = eig(s);

%Arranging eigenvalues
e1 = flipud(diag(e))';

%Explained sample variance by each principle component and cumulative
values = (e1 / (ones(8, 1)' * e1') * 100)'; 
cumulative_sum = (cumsum(e1 / (ones(8,1)' * e1') * 100))';

disp('Explained sample variance using principal components in percentage')
disp('      PC   Percentage Cumulative Percentage')
disp([(1:8)' values cumulative_sum])
