
clear
clc
close all

x1    = load('kupfer.dat');
x     = x1(1:1001);
y     = diff(log(x));

opt1  = VaRest(y,1);
opt2  = VaRest(y,2);

n     = length(y);
h     = 250;
lam   = 0.04;
dist  = 0;
alpha = 0.01;
w     = 1;
p     = sum(y,2);

% For RMA
rmalt    = [((h+1):n)', p((h+1):n)];
rmaiup   = (p((h+1):n)>0.8*opt1(:,2));
rmailo   = (p((h+1):n)<0.8*opt1(:,1));
rmaiall1 = rmaiup+rmailo;
rmaiall  = [((h+1):n)',rmaiall1];
   
subplot(2,1,1)
scatter(rmaiall(:,1),rmaiall(:,2),'.','r')
title('Time plot of exceedances for RMA')
xlabel('X')
ylabel('Y')
xlim([200, 1050])
ylim([-0.05, 1.05])
 
% For EMA
emalt    = [((h+1):n)', p((h+1):n)];
emaiup   = (p((h+1):n)>0.8*opt2(:,2));
emailo   = (p((h+1):n)<0.8*opt2(:,1));
emaiall1 = emaiup+emailo;
emaiall  = [((h+1):n)',emaiall1];
   
subplot(2,1,2)
scatter(rmaiall(:,1),emaiall(:,2),'.','b')
title('Time plot of exceedances for EMA')
xlabel('X')
ylabel('Y')
xlim([200, 1050])  
ylim([-0.05, 1.05])