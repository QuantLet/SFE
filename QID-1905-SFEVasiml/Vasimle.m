
function lnL = Vasimle(Params, X)
    s1    = X(2:end);
    s2    = X(1:end - 1);
    delta = 1 / 252;
    a     = Params(1);
    b     = Params(2);
    sigma = Params(3);
    n     = length(s1);
    v     = (sigma^2 * (1 - exp(-2 * a * delta))) / (2 * a);
    f     = s1 - s2. * exp(-a * delta) - b * (1 - exp(-a * delta));
    lnL   = (n / 2) * log(2 * pi) + n * log(sqrt(v))+sum((f / sqrt(v)).^2) / 2;
end