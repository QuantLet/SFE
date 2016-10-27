% define input parameters
a          = 0.5;
trueSpread = 20.45;
recoveryR  = 0.4;
UAP        = 0.03;
LAP        = 0;
DayCount   = 0.25;
defProb    = 0.001;
DF         = 0.9;

% execute function
CompCorrGaussModelCDO(a, recoveryR, defProb, UAP, LAP, DF, DayCount, trueSpread)