clear
clc
close all

% Input parameters
n    = 10000;         % sample size
seed = 1298324;    % makes sure that the same numbers are generated each time
                 % the quantlet is executed

% Main computation
y(1) = seed;
a    = 2^16 + 3;
M    = 2^31;
i    = 2;
while(i<=n)
    y(i) = mod((a*y(i-1)),M);
    i    = i+1;
end
y = y/M;

% Output
scatter3(y(1:n-2),y(2:n-1),y(3:n),'k','.')