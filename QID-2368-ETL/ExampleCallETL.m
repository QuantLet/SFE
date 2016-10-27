% Example Call
% Plaese first save the file on your current working directory and then use the example call
index     = 37.2416;
recoveryR = 0.4;                            % Recovery rate
UAP       = [0.03, 0.06, 0.09, 0.12, 0.22]; % Upper attachment points
lam       = index / 10000 / (1 - recoveryR);
tr        = 1;
defProb   = 1 - exp(-lam);                  % Default probability
rho       = 0.01:0.01:0.99;                 % compound correlation
a         = sqrt(rho);                      % square-root of compound correlation
etl       = NaN;
for i = 1:length(a)
    etl(i) = ETL(a(i), recoveryR, defProb, UAP(tr));
end
etl