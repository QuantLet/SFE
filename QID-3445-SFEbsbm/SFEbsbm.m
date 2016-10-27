
clear
close all
clc

% set parameters
S0 = 100;
K  = 110;
r = 0.05;
si  = 0.3;
tau = 0.02;

% main computation
T    = 1000;
t    = (1:T)/T;
dt   = t(2)-t(1);
Wt1  = normrnd(0,1,length(t),1);
Wt   = cumsum(Wt1);
St   = S0*exp((r-0.5*si )* dt + si * sqrt(dt) * Wt);
Call = zeros(size(St));
Put  = zeros(size(St));
for i=1:length(St)
[Call(i,:), Put(i,:)] = blsprice(St(i,:), K, r, si,tau);
end

% output
subplot(2,1,1)
plot(t,St,'b','LineWidth',2.5)
set(gca,'LineWidth',1.6)
set(gca,'FontSize',16)
xlabel('t')
ylabel('S_t')

subplot(2,1,2)
plot(t,Call,'r','LineWidth',2.5)
set(gca,'LineWidth',1.6)
set(gca,'FontSize',16)
xlabel('t')
ylabel('C(S,t)')
 