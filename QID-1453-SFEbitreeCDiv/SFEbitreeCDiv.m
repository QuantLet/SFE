
clear;
clc;
close all;

%% user inputs parameters

disp('Please input Price of Underlying Asset s0, Exercise Price k, Domestic Interest Rate per Year i,');
disp('Volatility per Year sig, Time to Expiration (Years) t, Number of steps n, type');
disp('as: [230, 210, 0.04545, 0.25, 0.5, 5, 0] or  [1.5, 1.5, 0.09, 0.2, 0.33, 6 ,1]');
disp(' ');
para = input('[s0, k, i, sig, t, n, type]=');

while length(para) < 7
    disp('Not enough input arguments. Please input in 1*7 vector form like [230, 210, 0.04545, 0.25, 0.5, 5, 0] or  [1.5, 1.5, 0.09, 0.2, 0.33, 6 ,1],');
    disp(' ');
    para = input('[s0, k, i, sig, t, n, type]=');
end

s0   = para(1);              % Stock price
k    = para(2);              % Exercise price
i    = para(3);              % Rate of interest
sig  = para(4);              % Volatility
t    = para(5);              % Time to expiration
n    = para(6);              % Number of intervals
type = para(7);              % 0 is American/1 is European

%Check conditions
if s0<=0
    disp('SFEBiTree: Price of Underlying Asset should be positive! Please input again')
    s0=input('s0=');
end
if k<0
    disp('SFEBiTree: Exercise price couldnot be negative! Please input again')
    k=input('k=');
end
if sig<0
    disp('SFEBiTree: Volatility should be positive! Please input again')
    sig=input('sig=');
end
if t<=0
    disp('SFEBiTree: Time to expiration should be positive! Please input again')
    t=input('t=');
end
if n<1
    disp('SFEBiTree: Number of steps should be at least equal to 1! Please input again')
    n=input('n=');
end

disp(' ') ;
disp('Please input option choice (1 for call, 0 for put) flag, continuous dividend in percentage (0 if no dividend) div');
disp('as: [1, 0.2] or [1, 0.02]');
para2=input('[flag div]=');

while length(para2) < 2
    disp('Not enough input arguments. Please input in 1*2 vector form like [1, 0.2] or [1, 0.02]');
    disp(' ') ;
    para2=input('[flag div]=');
end
flag=para2(1);     % 1 is call/0 is put
div=para2(2);      % Contionous dividend in percentage
if div<0
    disp('SFEBiTree: Dividend must be nonnegative! Please input again')
    div=input('div=');
end


%% main computation
dt=t/n;                               % Interval of step
u=exp(sig*sqrt(dt));                  % Up movement parameter u
d=1/u;                                % Down movement parameter d
b=i-div;                              % Costs of carry
p=0.5+0.5*(b-sig^2/2)*sqrt(dt)/sig;   % Probability of up movement
s=ones(n+1,n+1)*s0;
un=ones(n+1,1)-1;
un(n+1,1)=1;
dm=un';
um=[];
j=1;

while j<n+1
    d1=[ones(1,n-j)-1 (ones(1,j+1)*d).^((1:j+1)-1)];
    dm=[dm; d1];                                       % Down movement dynamics
    u1=[ones(1,n-j)-1 (ones(1,j+1)*u).^((j:-1:0))];
    um=[um; u1];                                       % Up movement dynamics
    j=j+1;
end

um=[un';um]';
dm=dm';
s=s(1,1).*um.*dm;                                     % Stock price development
disp('Stock_Price')
disp(s)
s=flipud(s);                                          % Rearangement
opt = zeros(size(s));

%% Option is a American call

if flag == 1 & type==0                                
    opt(:,n+1) = max(s(:,n+1)-k,0);                   % Determine option values from prices
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
    opt(:,n+1) = max(k-s(:,n+1),0);                    % Determine option values from prices
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
    opt(:,n+1) = max(k-s(:,n+1),0);                    % Determine option values from prices
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