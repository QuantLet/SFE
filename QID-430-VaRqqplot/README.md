
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **VaRqqplot** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : VaRqqplot

Published in : Statistics of Financial Markets

Description : External function, see SFEVaRqqplot.

Keywords : VaR, qq-plot

See also : 'SFEVaRbank, SFEVaRbank, SFEVaRqqplot, SFEVaRqqplot, SFEVaRtimeplot, SFEVaRtimeplot,
SFEVaRtimeplot, SFEVaRtimeplot2, SFEVaRtimeplot2, VaR, VaR, VaRest'

Author[Matlab] : Marlene Müller

Submitted[Matlab] : Mon, May 02 2016 by Meng Jou Lu

Input[Matlab]: 
- y: n x d matrix the returns of the time series.
- VaR: (n-h) x 1 or (n-h) x 2 matrix, VaR forecasts.

Output[Matlab] : The VaR is estimated and a QQ plot of y/VaR is displayed.

```


### MATLAB Code:
```matlab

function VaRqqplot(y, VaR)

n   = length(y);
d   = 1;
nov = 1;
h   = 250;

p1  = sum(y,2);
p   = p1(h+1:n);
qn  = norminv(((1:(n-h))-0.5)./(n-h),0,1);
tmp = p./VaR(:,1);
h   = qqplot(tmp)

set(h(1),'Marker','.')
set(h(3),'LineStyle','-')
set(h(3),'LineWidth',2)
title('VaR Reliability Plot')
xlabel('Normal Quantiles')
ylabel('L/VaR Quantiles')
ylim([-4 4])
xlim([-4 4])

```
