
clear
clc
close all

%Load data
x     = load('implvola.dat');
x     = x/100;

n     = length(x);
z     = x(2:n,:) - x(1:(n-1),:);
s     = cov(z)*100000;

%Determine Eigenvectors
[v e] = eigs(s);

f1    = v(:,1)';
f2    = v(:,2)';

%Adjust second Eigenvector
if f1(:,1)<0
    f1 = f1*(-1);
end

if f2(:,1)<0
    f2 = f2*(-1);
end

gr1    = [1:8;f1(1,:)]';
gr2    = [1:8;f2(1,:)]';

%Plot
hold on
plot(gr1(:,1),gr1(:,2),'Color','b','LineWidth',2)
scatter(gr1(:,1),gr1(:,2),'k')
plot(gr2(:,1),gr2(:,2),'Color','r','LineWidth',2,'LineStyle','--')
scatter(gr2(:,1),gr2(:,2),'k')
xlabel('Time')
ylabel('Percentage [%]')
title('Factor loadings')
hold off
