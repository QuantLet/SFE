clear
clc
close all

% input parameters
n    = 1000;
a    = 2;
b    = 0;
M    = 11;
seed = 12;

% main computation
y(1) = seed;
i    = 2;

while(i<=n)
    y(i)= mod((a*y(i-1)+b),M);
    i   = i+1;
end
y = y/M;

% output
scatter(y(1:n-2),y(2:n-1),'k','LineWidth',3)
xlabel('U_i_-_1','FontSize',16,'FontWeight','Bold')
ylabel('U_i')
xlim([0 1.2])
box on
set(gca,'LineWidth',1.6,'FontSize',16,'FontWeight','Bold')