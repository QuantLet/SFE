%--------------------------------------------------------------------------
%Book:     SFE
%--------------------------------------------------------------------------
%Quantlet: SFE_arfima
%--------------------------------------------------------------------------
%Description: Computes the arfima(p,d,q) time series.
%--------------------------------------------------------------------------
%Usage: SFE_arfimaplot
%--------------------------------------------------------------------------
%Inputs: 
%N - Length of the generated time series
%AR - coefficients of the AR polynomial
%MA - coefficients of the MA polynomial
%d -  fractionally differencing parameter (long memory)
%--------------------------------------------------------------------------
%Output: ARFIMA(AR,d,MA) time series
%--------------------------------------------------------------------------
%Example:
%--------------------------------------------------------------------------
% Author: Piotr Majer 20100715
%--------------------------------------------------------------------------
function [Z] = SFE_arfima(N,AR,MA,d)


X=zeros(1,N); Y=zeros(1,N); Z=zeros(1,N); 


e=normrnd(0,1,N,1); 
%%%%% N =length
MA_ord=length(MA);
AR_ord=length(AR);
%%%%%%%%%%%% Computing part: MA(q)
i=0;
if MA_ord >= 1
    for i=1:N
        j=0;map=0;
        for j=1:MA_ord
            if i > j
                map = map + MA(j)*e(i-j);
            end
        end
        X(i)= e(i)+ map;
    end
else
    X=e;
end
t=0;
%%%%%%%%%%% Computing part: d
if d == 0
    Y=X;
else
    infi =100; s=0;
    for s=0:infi
        b(s+1)=gamma(s+d)/(gamma(s+1)*gamma(d));
    end
    for t=1:N
        Y(t)=0;
        for s=0:infi
            if t > s
                Y(t)= Y(t)+ b(s+1)*X(t-s);
            end
        end
    end
end
%%%%%%%%%%%%% Computing part: AR(p)
t  = 0;
if AR_ord >= 1
    for t=1:N
        j=0; arp=0;
        for j=1:AR_ord
            if t > j
                arp = arp - AR(j)*Z(t-j);
            end
        end
        Z(t)= Y(t)+ arp;
    end
else
    Z=Y;
end

Z=Z';
end