%% clear all variables
clc
close all
clear all

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
dataset    = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);

%% Portfolio
d  = dataset.BAYER + dataset.BMW + dataset.SIEMENS + dataset.VOLKSWAGEN; 
x  = log(d(1:end-1))-log(d(2:end));%negative log-returns
n  = 100;
zb = sort(x);

%%  estimates of the parameters for the two-parameter generalized Pareto
theta  = zb(end-n);
z      = zb(end-n+1:end)-theta;
params = gpfit(z);
K      = params(1);
sigma  = params(2);
t      = (1:n)/(n+1);
y      = gpinv(t,K,sigma);

%% plot
hold on
plot(y,y,'r','LineWidth',2)
ylim([0,0.06])
xlim([0,0.06])
scatter(z,y,'o','filled','LineWidth',3)
title('QQ plot, Generalized Pareto Distribution','FontSize',16,'FontWeight','Bold')
hold off
box on
set(gca,'FontSize',16,'LineWidth',1.6,'FontWeight','bold');
