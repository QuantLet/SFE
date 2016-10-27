% define function to compute the base correlation of a gaussian model
function y = BaseCorrGaussModelCDO(a, R, defProb, UAP, LAP, DF, DayCount, trueSpread, LowerTLoss)
    C     = norminv(defProb, 0, 1);
    NinvK = norminv(UAP / (1 - R), 0, 1);
    A     = (C - sqrt(1 - a^2) * NinvK) / a;
    Sigma = [1 -a; -a 1];
    Mu    = [0 0];
    EL1   = mvncdf([C, -A], Mu, Sigma);
    EL2   = normcdf(A);

    if LAP == 0
        EL       = EL1 / UAP * (1 - R) + EL2;
    else
        UpperETL = EL1 + EL2 * UAP/(1 - R);
        EL       = (UpperETL - LowerTLoss) / (UAP - LAP) * (1 - R);
    end

    ProtectLeg = sum(diff([0; EL]) .* DF);
    PremiumLeg = sum((1 - EL) .* DF .* DayCount);
    spread     = ProtectLeg / PremiumLeg * 10000;

    if LAP == 0
        spread = (ProtectLeg - 0.05 * PremiumLeg) * 100;
    end

    y = abs(spread - trueSpread);