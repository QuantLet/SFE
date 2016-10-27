

clear all
close all
clc

load yield_US3month9808.txt;

X             = yield_US3month9808(1:2600)/100;
n             = length(X)-1;
delt          = 1/252;

% Least square innitial estimation
X1            = sum( X(1:end-1) );
X2            = sum( X(2:end) );
X3            = sum( X(1:end-1).^2 );
X4            = sum( X(1:end-1).*X(2:end) );
X5            = sum( X(2:end).^2 );

c             = ( n*X4 - X1*X2 ) / ( n*X3 -X1^2 );
d             = ( X2 - c*X1 ) / n;
sd            = sqrt( (n*X5 - X2^2 - c*(n*X4 - X1*X2) )/n/(n-2) );

lambda        = -log(c)/delt;
mu            = d/(1-c);
sigma         = sd * sqrt( -2*log(c)/delt/(1-c^2) ) ;
InitialParams = [lambda mu sigma];

%optimize the Likelihood function
options                  = optimset('LargeScale', 'off', 'MaxIter', 300, 'MaxFunEvals', 300, 'Display', 'iter', 'TolFun', 1e-4, 'TolX', 1e-4, 'TolCon', 1e-4);
[Params, Fval, Exitflag] = fminsearch(@(Params) Vasimle(Params,X), InitialParams,options);

Results.Params           = Params;
Results.Fval             = -Fval/n;
Results.Exitflag         = Exitflag;

fprintf('\n a = %+3.6f\n b    = %+3.6f\n sigma = %+3.6f\n', Params(1), Params(2), Params(3));
fprintf(' log-likelihood = %+3.6f\n', -Fval/n);