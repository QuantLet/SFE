
function LowerETL = lowerTrLossGauss(sqrtBCbef,R,defProb,LAP)
C        = norminv(defProb, 0, 1);
NinvK    = norminv(LAP / (1 - R), 0, 1);
A        = (C - sqrt(1 - sqrtBCbef ^ 2) * NinvK) / sqrtBCbef;
Sigma    = [1 -sqrtBCbef; -sqrtBCbef 1];
Mu       = [0 0];
EL1      = mvncdf([C,-A],Mu,Sigma);
EL2      = normcdf(A);
LowerETL = EL1 + EL2 * LAP / (1 - R);
