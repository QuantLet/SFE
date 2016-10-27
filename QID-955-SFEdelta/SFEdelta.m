% user inputs parameters
disp('Please input [lower, upper] bound of Asset price S as: [50,150]') ;
disp(' ') ;
para=input('[lower, upper] bound of S =');
while length(para) < 2
  disp('Not enough input arguments. Please input in 1*2 vector form like [50,150] or [50 150]');
  para=input('[lower, upper] bound of S=');
end
S_min = para(1);
S_max = para(2);

disp(' ') ;
disp('Please input [lower, upper] bound of time to maturity tau as: [0.01, 1]') ;
disp(' ') ;
para2=input('[lower, upper] bound of tau =') ;
while length(para2) < 2
  disp('Not enough input arguments. Please input in 1*2 vector form like [0.01, 1] or [0.01 1]');
  para2=input('[lower, upper] bound of tau =');
end
tau_min=para2(1);
tau_max=para2(2);

% main computation
K     = 100;                   % exercise price 
r     = 0   ;                  % interest rate
sig   = 0.25 ;                 % volatility
d     = 0;                     % dividend rate
b     = r-d;                   % cost of carry
steps = 60;

[tau,dump] = meshgrid([tau_min:(tau_max-tau_min)/(steps-1):tau_max]);
[dump2,S]  = meshgrid([S_max:-(S_max-S_min)/(steps-1):S_min]);

d1    = (log(S/K)+(r-d+sig^2/2).*tau)./(sig.*sqrt(tau));
delta = normcdf(d1);

% plot
mesh(tau,S,delta);
title('Delta')
ylabel('Asset Price S');
xlabel('Time to Maturity \\tau');
