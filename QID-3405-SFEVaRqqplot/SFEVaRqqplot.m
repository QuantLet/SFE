
clear
close all
x1   = load('kupfer.dat');
x    = x1(1:1001);
y    = diff(log(x));
h    = 250;

% Option 1=RMA, 2=EMA
% opt1 = RMA;
% opt2 = EMA;

opt1 = VaRest(y,1);
opt2 = VaRest(y,2);

figure(1)
VaRqqplot(y,opt1)
figure(2)
VaRqqplot(y,opt2)
daspect([1 1 1])