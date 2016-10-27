% create random sample
data = normrnd(0.05, 0.01, 2000, 1);

% define input parameter Model
Model.Data  = data;
Model.delta = 0.004;
Model.n     = length(data);

% define input parameter Params
a       = 0.26;
b       = 0.016;
sigma   = 0.01;
Params  = [a, b, sigma];

% execute function
CIRml(Params, Model)