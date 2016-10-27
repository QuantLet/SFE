
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **VaRest** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : VaRest

Published in : Statistics of Financial Markets

Description : External function for estimating the value at risk(VaR).

Keywords : VaR

See also : 'SFEVaRbank, SFEVaRbank, SFEVaRqqplot, SFEVaRqqplot, SFEVaRtimeplot, SFEVaRtimeplot,
SFEVaRtimeplot, SFEVaRtimeplot2, SFEVaRtimeplot2, VaRqqplot'

Author[Matlab] : Marlene Müller

Submitted[Matlab] : Mon, May 02 2016 by Meng Jou Lu

Input[Matlab]: 
- y: the returns of the assets method
- method: for VaR, one of 1 = RMA (rectangular moving average) 2 = EMA (exponential moving average)

Output[Matlab] : VaR - the VaR for observations h+1 to n.

```


### MATLAB Code:
```matlab

function VaR = VaRest(y,method)

n     = length(y);
h     = 250;
lam   = 0.96;
dist  = 0;
alpha = 0.01;
w     = 1;
bw    = 0;

% Method 1 = RMA, Method 2 = EMA
if (method == 1)
    sigh = ones(n-h)-1;
    tmp  = cumsum(y.*y);
    tmp1 = (tmp((h+1):n)-tmp(1:(n-h)))./h;
    sigh = sqrt(sum(sum(w.*tmp1,3).*w,2));
end

grid = (h-1:-1:0)';
if (method == 2)
    sigh = ones(n-h,1)-1;
    j=h;
    while j<n
        j         = j+1;
        tmp       = (lam.^grid). * y((j-h):(j-1));
        tmp1      = sum(tmp.*tmp);
        sigh(j-h) = sqrt(sum(sum(tmp1),2).*(1-lam));

    end
end

if (dist == 0)
    qf   = norminv(alpha);
else
    sigh = sigh./sqrt(dist/(dist-2));
    qf   = tinv(alpha,dist);
end
VaR      = qf.*sigh;
VaR      = [VaR,(-VaR)];

```
