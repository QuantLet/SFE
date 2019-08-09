function [var,tau,alpha,beta,kappa] = block_max(y,n,p)
    T = length(y);
    k = floor(T/n);
    
    z = NaN(1,k-1);
    for j=1:k-1
        r    = y((j-1)*n+1:j*n);
        z(j) = max(r);
    end

    r     = y((k-1)*n+1:end);
    z(k)  = max(r);
    warning off
    
    parmhat = gevfit(z);
    kappa   = parmhat(1);
    tau     = -1/kappa;
    alpha   = parmhat(2);
    beta    = parmhat(3);
    pext    = p^n;
    var     = beta+alpha/kappa*((-log(1-pext))^(-kappa)-1);
end