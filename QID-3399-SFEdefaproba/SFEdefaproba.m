
clear
clc
close all

%% Main computation

x=[0:0.01:1];
y1=normcdf((norminv(x)-sqrt(0.2)*(-3))/(sqrt(0.8)));
y2=normcdf((norminv(x)-sqrt(0.2)*(0))/(sqrt(0.8)));
y3=normcdf((norminv(x)-sqrt(0.2)*(3))/(sqrt(0.8)));

%% Plot

plot(x,y1,'b-','LineWidth',2)
hold on
plot(x,y2,'k:','LineWidth',2)
plot(x,y3,'r-.','LineWidth',2)
hold off

xlabel('Probability Default');ylabel('p(y)');legend('y=-3','y=0','y=3',4);