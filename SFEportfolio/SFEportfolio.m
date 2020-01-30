close all
clear 
clc

% Load data
x1 = load('BAYER_close_0012.dat');
x2 = load('BMW_close_0012.dat');
x3 = load('SIEMENS_close_0012.dat');
x4 = load('VW_close_0012.dat');

r1 = diff(log(x1));
r2 = diff(log(x2));
r3 = diff(log(x3));
r4 = diff(log(x4));

% Variance efficient portfolio
portfolio = [r1,r2,r3,r4];
opti      = inv(cov(portfolio))*[1,1,1,1]';
opti      = opti/sum(opti);
returns2  = portfolio*opti;
x         = returns2;
n         = size(x,1);
xf        = sort(x);
t         = [(1:n)/(n+1)]';
dat1      = [normcdf((xf-repmat(mean(xf),n,1))/std(xf)),t];
dat2      = [t,t];


%PP Plot
figure(1)
h1 = plot(dat1(:,1),dat1(:,2),'bo');
set(h1(1),'Marker','o','MarkerEdgeColor','none','MarkerFaceColor','b')
hold on
h1 = plot(dat2(:,1),dat2(:,2),'r-','LineWidth',2);
title('PP Plot of Daily Return of Portfolio','FontSize',16,'LineWidth',2,'FontWeight','bold')
set(gca,'FontSize',16,'LineWidth',2,'FontWeight','bold');
set(gca,'XTick',[0:0.2:1])
set(gca,'XTickLabel',{0,0.2,0.4, 0.6,0.8,1.0})
set(gca,'YTick',[0:0.2:1])
set(gca,'YTickLabel',{0,0.2,0.4, 0.6,0.8,1.0})
print -painters -dpdf -r600 SFEportfolio01.pdf
print -painters -dpng -r600 SFEportfolio01.png
hold off

%QQ Plot
figure(2)
h = qqplot(xf);
hold on
set(h(1),'Marker','o','MarkerEdgeColor','none','MarkerFaceColor','b')
set(h(3),'LineStyle','-')
set(h(3),'LineWidth',2)
title('QQ Plot of Daily Return of Portfolio','FontSize',16,'LineWidth',2,'FontWeight','bold');
xlabel('')
ylabel('')
box on
xlim([-4 4])
set(gca,'FontSize',16,'LineWidth',2,'FontWeight','bold');
hold off
print -painters -dpdf -r600 SFEportfolio02.pdf
print -painters -dpng -r600 SFEportfolio02.png