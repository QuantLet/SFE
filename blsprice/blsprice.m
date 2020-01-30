function [Call Put] = blsprice(S,K,r,sigma,tau)

if tau == 0 
    t = 1;
else
    t = 0;
end

y = (log(S/K)+(r-sigma^2/2)*tau)/(sigma*sqrt(tau)+t);
cdfn = normcdf(y+sigma*sqrt(tau));
    
if t ==0
    t_l = 1;
else
    t_l = 0;
end

Call = S*(cdfn*t_l+t)-K*exp(-r*tau)*normcdf(y)*t_l+t;
Put = K*exp(-r*tau)*(normcdf(-y))*t_l+t-S*(normcdf(-y-sigma*sqrt(tau))*t_l+t);
