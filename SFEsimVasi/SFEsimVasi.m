clear
clc
close all

% user inputs parameters
disp('Please input [a, b, sigma, r0, T] as: [0.161, 0.014, 0.009, 0.01, 250]') ;
disp(' ') ;
para=input('[a, b, sigma, r0, T] as =');

while length(para) < 5
    disp('Not enough input arguments. Please input in 1*5 vector form like [0.161, 0.014, 0.009, 0.01, 250]');
    para=input('[a, b, sigma, r0, T] as =');
end

a     = para(1);   %adjustment factor
b     = para(2);   %long term average interest rate    
sigma = para(3);  %instantaneous standard deviation
R0    = para(4);   %instantaneous forward rate
T     = para(5);   %time period
dt    = 1;         %time intervals
N     = T/dt;     %Number of  time intervals of length dt in long  time period T
R(1)  = R0;      %The initial short rate

%% simulation of the short rates

for i=1:N
    R(i+1) = R(i)+a*(b-R(i))*(1/N)+sigma*sqrt(1/N)*normrnd(0,1);
end

%% plot for the Short Rates vs Time

x = 0:dt:T;
plot(x,R,'b-','LineWidth',2);
xlabel('Time','FontSize',16,'FontWeight','Bold')
ylabel('Instantaneous Short Rates')
title('Vasicek Model')
box on
set(gca,'LineWidth',1.6,'FontSize',16,'FontWeight','Bold')