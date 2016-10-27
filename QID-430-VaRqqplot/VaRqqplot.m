
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
