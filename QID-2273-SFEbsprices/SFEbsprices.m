clear all;
close all;
clc;

% set parameters
S     = 100;
K     = 100;
r     = 0.1;
tau   = 0.6;
tauu  = 0.003;
sig   = 0.15;
sigg  = 0.3;

% main computation
vS    = (10:1:159)';
vK    = (10:1:159)';
vr    = (0.01:0.005:0.055)';
vtau  = (0.01:0.01:1)';
vsig  = (0.01:0.01:0.6)';

Call1 = zeros(size(vS));
Put1  = zeros(size(vS));
Call2 = zeros(size(vS));
Put2  = zeros(size(vS));
Call3 = zeros(size(vS));
Put3  = zeros(size(vS));
Call4 = zeros(size(vS));
Put4  = zeros(size(vS));


for i=1:length(vS)
[Call1(i,:) Put1(i,:)]= blsprice(vS(i,:), K, r, sig, tau);
end
pp1=[vS,Call1];
for i=1:length(vS)
[Call2(i,:) Put2(i,:)]= blsprice(vS(i,:), K, r, sig,tauu);
end
pp2=[vS,Call2];
for i=1:length(vS)
[Call3(i,:) Put3(i,:)]= blsprice(vS(i,:), K, r, sigg,tau);
end
pp3=[vS,Call3];
for i=1:length(vS)
[Call4(i,:) Put4(i,:)]= blsprice(vS(i,:), K, r, sigg,tauu);
end
pp4=[vS,Call4];

% output
subplot(1,2,1)
hold on
plot(pp1(:,1),pp1(:,2),'b','LineWidth',2.5)
plot(pp2(:,1),pp2(:,2),'r','LineWidth',2.5,'LineStyle','-')
set(gca,'FontSize',16)
set(gca,'LineWidth',1.6)
xlim([0 165])
ylim([0 70])
xlabel('S');
ylabel('C(S,tau)')
hold off
subplot(1,2,2)
hold on
plot(pp3(:,1),pp3(:,2),'b','LineWidth',2.5)
plot(pp4(:,1),pp4(:,2),'r','LineWidth',2.5,'LineStyle','-')
set(gca,'FontSize',16)
set(gca,'LineWidth',1.6)
xlim([0 165])
ylim([0 70])
xlabel('S');
ylabel('C(S,tau)')
hold off
