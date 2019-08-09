function [var,ksi,beta,u] = var_pot(y,h,p,q)
    N  = floor(h*q);
    ys = sort(y,'descend');
    u  = ys(N+1);
    z  = y(y>u)-u;
    
    params = gpfit(z);
    warning off

    ksi  = params(1);
    beta = params(2);
    var  = u + beta/ksi*((h/N*(1-p))^(-ksi)-1);
end
