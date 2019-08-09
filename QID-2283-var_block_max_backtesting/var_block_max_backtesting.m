function [v,K,outlier,yplus,p]=var_block_max_backtesting(x,v,h)
    v         = -v;
    L         = x;
    T         = length(L);
    outlier   = NaN(1,T-h);
    exceedVaR = NaN(1,T-h);
    
    for j=1:T-h
        exceedVaR(j) = (L(j+h)<v(j));
        if exceedVaR(j)>0 
            outlier(j) = L(j+h);
        end;
    end;
    p       = sum(exceedVaR)/(T-h);
    K       = find(isfinite(outlier));
    yplus   = K.*0+min(L(h+1:end))-2;
    outlier = outlier(K);
end
  