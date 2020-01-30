
clear
clc
close all

x1   = load('kupfer.dat');
x    = x1(1:1001);
y    = diff(log(x));
h    = 250;
opt1 = VaRest(y,1);
opt2 = VaRest(y,2);

hold on
plot(h+1:length(x)-1,opt1(:,1),'g','LineStyle','--')
plot(h+1:length(x)-1,opt1(:,2),'g','LineStyle','--')
plot(h+1:length(x)-1,opt2(:,1),'blue')
plot(h+1:length(x)-1,opt2(:,2),'blue')
k=1:length(x)-1;

scatter(k(251:length(x)-1),y(251:length(x)-1),'.','k');

l=1;
for i=251:length(y)
    if  or(opt1(i-250,2)<y(i),y(i)<opt1(i-250,1))
        exceed(l) =y(i);
        scatter(i,exceed(l),'+','r')
        scatter(i,exceed(l),'s','r')
        l=l+1;
    end
end

xlim([230,1020])
title('VaR timeplot')
ylabel('Returns')
xlabel('Time')
hold off