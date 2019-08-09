%% clear all variables and console 
clear
clc

%% close windows
close all

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
Data       = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);
Data       = Data(:,{'Date','BAYER','BMW', 'SIEMENS', 'VOLKSWAGEN'});

h       = 250;        % size of moving window
x       = Data.BAYER + Data.BMW + Data.SIEMENS + Data.VOLKSWAGEN;
x       = diff(x);  % returns
minus_x = -x;
p       = 0.95;       % quantile for the Value at Risk
q       = 0.1;
Obs     = length(x);

%% Value at Risk
% preallocation
var  = NaN(1,Obs-h);
ksi  = var;
beta = var;
u    = var;

for i=1:(Obs-h)
    y = minus_x(i:(i+h-1));
    [var(i),ksi(i),beta(i),u(i)] = var_pot(y,h,p,q);
end

%% plot
plot(Data.Date(h+2:end),beta)
hold on
plot(Data.Date(h+2:end),ksi,'Color','red')
plot(Data.Date(h+2:end),u,'Color','m')
legend('Scale Parameter','Shape Parameter','Threshold','FontSize',16,'FontWeight','Bold','Location','NorthWest')
title('Parameters in Peaks Over Threshold Model','FontSize',16,'FontWeight','Bold')
