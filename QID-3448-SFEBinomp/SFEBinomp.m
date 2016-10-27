
clear all
close all
clc

% user inputs parameters
disp('Please input observations,trajectories, p as: [100, 3, 0.6]');
disp(' ') ;
para=input('[observations trajectories p]=');
while length(para) < 3
  disp('Not enough input arguments. Please input in 1*3 vector form like [100, 3, 0.6] or [100 3 0.6]');
  disp(' ') ;
  para=input('[observations trajectories p]=');
end
obs=para(1);
traj=para(2);
p=para(3);

% main simulation
t=1:obs;
trend = t*(2*p-1);
std = sqrt(4*t*p*(1-p));
s1=trend+2*std;
s2=trend-2*std;
z=unifrnd(p-1,p,traj,obs);    % Generate unifrnd in (p-1, p)
z=z>0;
z=z*2-1;                      % z=1 with p, z=-1 with 1-p 
walk=zeros(traj,obs);
for j=2:obs
    walk(:,j)=walk(:,j-1)+z(:,j);
end

% plot of binomial process
plot(walk','LineWidth',2.5)
hold on
plot(trend','k','LineWidth',2.5)
plot([s1;s2]','--k')
hold off 
xlabel('Time')
ylabel('Process')
title(sprintf('Binomial processes with p=%0.5g',p))

