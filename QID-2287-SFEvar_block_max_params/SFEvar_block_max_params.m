%% clear all variables and console 
clear
clc

%% close windows
close all

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
Data       = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);        
Data       = Data(:,{'Date','BAYER','BMW', 'SIEMENS', 'VOLKSWAGEN'});

%% create portfolio
x       = Data.BAYER + Data.BMW + Data.SIEMENS + Data.VOLKSWAGEN;
x       = diff(x);    % returns
minus_x = -x;         % negative returns
Obs     = length(x);  % number of observations
p       = 0.95;       % quantile for the Value at Risk
h       = 250;        % size of moving window
n       = 16;         % size of moving window for estimating quantile in VaR

%% Value at Risk
% preallocation
var   = NaN(1,Obs-h);
tau   = var;
alpha = var;
beta  = var;
kappa = var;

for i = 1:Obs-h
    y = minus_x(i:i+h-1);
    [var(i),tau(i),alpha(i),beta(i),kappa(i)] = block_max(y,n,p);
end;

%% plot
plot(Data.Date(h+2:end),kappa)
hold on
plot(Data.Date(h+2:end),alpha,'Color','red')
plot(Data.Date(h+2:end),beta,'Color','m')
hold off
legend('Shape Parameter','Scale Parameter','Location Parameter','Location','NorthWest')
title('Parameters in Block Maxima Model')
