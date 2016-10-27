function VaR=VaRest(y,method)

n     = length(y);
h     = 250;
lam   = 0.96;
dist  = 0;
alpha = 0.01;
w     = 1;
bw    = 0;

% Method 1 = RMA, Method 2 = EMA
if (method == 1)
    sigh = ones(n - h) - 1;
    tmp  = cumsum(y .* y);
    tmp1 = (tmp((h + 1):n) - tmp(1:(n - h))) ./ h;
    sigh = sqrt(sum(sum(w .* tmp1, 3) .* w, 2));
end

grid = (h - 1:-1:0)';
if (method == 2)
    sigh = ones(n - h, 1) - 1;
    j    = h;
    while j < n
        j           = j + 1;
        tmp         = (lam .^ grid) .* y((j - h):(j - 1));
        tmp1        = sum(tmp .* tmp);
        sigh(j - h) = sqrt(sum(sum(tmp1), 2) .* (1 - lam));

    end
end

if (dist == 0)
    qf   = norminv(alpha);
else
    sigh = sigh ./ sqrt(dist / (dist - 2));
    qf   = tinv(alpha, dist);
end
VaR = qf .* sigh;
VaR = [VaR, (-VaR)];