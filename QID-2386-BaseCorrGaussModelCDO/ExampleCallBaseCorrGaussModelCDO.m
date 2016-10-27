% define input parameters
a          = 0.5;
trueSpread = 20.45;
recoveryR  = 0.4;
UAP        = 0.03;
LAP        = 0;
DF         = 0.9;
DayCount   = 0.25;
defProb    = 0.001;

% execute function
BaseCorrGaussModelCDO(a, recoveryR, defProb, UAP, LAP, DF, DayCount, trueSpread)