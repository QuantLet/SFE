function lnL = CIRml(Params, Model)
    % define input parameters
    lData = Model.Data;
    DataF = lData(1:end - 1);
    DataL = lData(2:end);
    a     = Params(1);
    b     = Params(2);
    sigma = Params(3);
    
    % compute relevant parameters for the log-likelihood function
    c   = 2 * a / (sigma^2 * (1 - exp(-a * Model.delta)));
    u   = c * exp(-a * Model.delta) * DataF;
    v   = c * DataL;
    q   = 2 * a * b / sigma^2 - 1;
    z   = 2 * sqrt(u .* v);
    bf  = besseli(q, z, 1);
    
    % compute log-likelihood
    lnL = -(Model.n - 1) * log(c) - sum(-u - v + 0.5 * q * log(v ./ u) + log(bf) + z);
end