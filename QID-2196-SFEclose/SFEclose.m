%% clear all variables
clear all
close all
clc

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
dataset    = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);

%% plot
hold on
plot(dataset.Date,dataset.BAYER,'k','LineStyle','--','LineWidth',2)
plot(dataset.Date,dataset.BMW,'r','LineStyle',':','LineWidth',2)
plot(dataset.Date,dataset.SIEMENS,'b','LineStyle','-','LineWidth',2)
plot(dataset.Date,dataset.VOLKSWAGEN,'g','LineStyle','-.','LineWidth',2)
title('Closing Prices for German Companies','FontSize',16,'FontWeight','Bold')
box on
set(gca,'FontSize',16,'LineWidth',2,'FontWeight','bold');
hold off
