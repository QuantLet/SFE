% clear history
clear all
% load data file
T = readtable('yield_US3month9808.txt', 'ReadVariableNames', false);
% convert table to array
A = table2array(T);

% collect input
Model.Data  = A / 100;
Model.delta = 1 / 250;      
Model.n     = length(Model.Data);

% least square initial estimation 
x2     = Model.Data(1:end - 1);
x1     = Model.Data(2:end);
xbar_1 = mean(x1);
xbar_2 = mean(x2);
x3     = x1 - xbar_1;
x4     = x2 - xbar_2;
y1     = dot(x3, x4) / length(x1);
y2     = dot(x4, x4) / length(x1);
a      = 252 * log(y1 / y2);
gama   = exp(a / 252);
b      = (xbar_1 - gama * xbar_2) / (gama - 1);
y3     = x1 - b * (gama - 1) - gama * x2;
y4     = (b / (2 * a)) * (gama - 1)^2 + (gama / a) * (gama - 1) * x2;
sig    = sum(y3.^2 ./ y4) / length(x1);
a      = -a;
b      = -b;
sigma  = sqrt(sig);

% optimize the Likelihood function
InitialParams = [a b sigma];
options       = optimset('LargeScale', 'off', 'MaxIter', 300, 'MaxFunEvals', 300, 'Display',...
                         'iter', 'TolFun', 1e-4, 'TolX', 1e-4, 'TolCon', 1e-4);

% use fminsearch to find optimum
[Params, Fval, Exitflag] =  fminsearch(@(Params) CIRml(Params, Model), InitialParams, options);

% define output
Results.Params   = Params;
Results.Fval     = -Fval / Model.n;
Results.Exitflag = Exitflag;

% print results
fprintf('n a = %+3.6fn b = %+3.6fn sigma = %+3.6fn', Params(1), Params(2), Params(3));
fprintf('log-likelihood = %+3.6fn', -Fval / Model.n);
