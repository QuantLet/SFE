
clear;
clc;
close all;

%% Input parameters

s0   = 230;     % Stock price
k    = 210;     % Exercise price
i    = 0.04545; % Rate of interest
sig  = 0.25;    % Volatility
t    = 0.5;     % Time to expiration
n    = 5;       % Number of intervals
type = 0;       % 0 is American/1 is European
flag = 1;       % 1 is call/0 is put
div  = 0.2;     % Contionous dividend in percentage


%% main computation
dt = t/n;                                    % Interval of step
u  = exp(sig*sqrt(dt));                      % Up movement parameter u
d  = 1/u;                                    % Down movement parameter d
b  = i-div;                                  % Costs of carry
p  = 0.5 + 0.5*(b - sig^2/2)*sqrt(dt)/sig;   % Probability of up movement
s  = ones(n+1,n+1)*s0;
un = ones(n+1,1)-1;
un(n+1,1) = 1;
dm = un';
um = [];
j  = 1;

while j<n+1
    d1 = [ones(1,n-j)-1 (ones(1,j+1)*d).^((1:j+1)-1)];
    dm = [dm; d1];                                      % Down movement dynamics
    u1 = [ones(1,n-j)-1 (ones(1,j+1)*u).^((j:-1:0))];
    um = [um; u1];                                      % Up movement dynamics
    j  = j+1;
end

um = [un';um]';
dm = dm';
s  = s(1,1).*um.*dm;                                 % Stock price development
disp('Stock_Price')
disp(s)
s   = flipud(s);                                     % Rearangement
opt = zeros(size(s));

%% Option is a American call

if flag == 1 & type==0                                
    opt(:, n+1) = max(s(:, n+1) - k, 0);            % Determine option values from prices
    for j = n:-1:1;
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value is max of current price - X or discopt
        opt(:,j) = [max(s(1:j,j)-k,discopt);zeros(n+1-j,1)];
    end
    American_Call_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(American_Call_Price(n+1,1))

%% Option is a European call

elseif flag == 1 & type==1                          
    opt(:,n+1) = max(s(:,n+1)-k,0);                   % Determine option values from prices
    for j = n:-1:1;
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value
        opt(:,j) = [discopt;zeros(n+1-j,1)];
    end
    European_Call_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(European_Call_Price(n+1,1))
   
%% Option is an American put

elseif flag == 0 & type==0                            
    opt(:,n+1) = max(k-s(:,n+1),0);                % Determine option values from prices
    for j = n:-1:1
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value is max of X - current price or discopt
        opt(:,j) = [max(k-s(1:j,j),discopt);zeros(n+1-j,1)];
    end
    American_Put_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(American_Put_Price(n+1,1))
   
%% Option is a European put

elseif flag == 0 & type==1                            
    opt(:, n+1) = max(k-s(:, n+1), 0);              % Determine option values from prices
    for j = n:-1:1
        l = 1:j;
        % Probable option values discounted back one time step
        discopt = ((1-p)*opt(l,j+1)+p*opt(l+1,j+1))*exp(-b*dt);
        % Option value
        opt(:,j) = [discopt;zeros(n+1-j,1)];
    end
    European_Put_Price = flipud(opt)
    disp(' ') ;
    disp('The price of the option at time t_0 is')
    disp(European_Put_Price(n+1,1))
end