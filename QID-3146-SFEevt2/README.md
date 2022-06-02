[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEevt2** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEevt2 

Published in: Statistics of Financial Markets

Description: 'Shows the normal probability plot (PP Plot) of the pseudo random variables with extreme value distributions: Weibull, Frechet and Gumbel.'

Keywords: Frechet, GEV, Weibull, distribution, edf, extreme-value, gumbel, normal, normal-distribution, plot, pp-plot, random, random-number-generation

See also: SFEevt1, SFEevt3

Author: Wolfgang K. Haerdle, Konstantin Haeusler

Author [Matlab]: Juergen Franke

Submitted: 20220601 by WKH, KH

Input: 
- n : number of observations

Output: 'Normal plot of the pseudo random variables with Weibull, Frechet and Gumbel distributions.'

Example: 'User inputs the number of observations like 100, then 3 PP Plots of the random distributions may be generated using a selector. The PP line shows the difference of the distributions.'

```

![Picture1](SFEevt2-1_m.png)

![Picture2](SFEevt2-2_m.png)

![Picture3](SFEevt2-3_m.png)

![Picture4](SFEevtFrechet.png)

![Picture5](SFEevtGumbel.png)

![Picture6](SFEevtWeibull.png)

### R Code
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages, install 'fExtremes' package for the Gumbel distribution
libraries = c("fExtremes", "evd")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {install.packages(x)} )
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

set.seed(1234)
  
# global parameter settings
n = 100
y = (1:n) / (n + 1)

# choose EVT cdf for the plot header only
# sel = "Weibull"
# sel = "Frechet"
  sel = "Gumbel"

# sel "Weibull"       
# x = rweibull(n, shape=2, scale = 1) # you may change these params
  
# sel "Frechet"
# x = rfrechet(n, loc = 0, scale = 1, shape = 1)  # you may change these params
  
# sel "Gumbel"
x =  rgumbel(n, loc=0, scale=1)  # you may change these params
  
# now calc the order statistics of the generated rv's
x = sort(x) 
px= pnorm(x)  # calc the probas on the standard normal scale
  
# png( paste0("SFEevt", sel, ".png") )
par(pty="s")
plot(y, y, col = "red", type = "line", lwd = 2.5, main = paste( "PP Plot of Extreme Value - ", sel),
       xlab = "X", ylab = "Y", xaxt = "n", yaxt = "n", asp=1, xlim=c(0,1), ylim=c(0,1))
axis(1, at = seq(0, 1, 0.2))
axis(2, at = seq(0, 1, 0.2))
points(px, y, col = "blue", pch = 19, cex = 0.8)
#  dev.off()



```

automatically created on 2022-06-02

### MATLAB Code
```matlab

clear all
close all
clc

n = 100;

% Gumbel
gumb1 = gevrnd(0, 1, 0, 100, 1);
gumb2 = sort(gumb1);
gumb  = normcdf(gumb2, 0, 1);
t     = (1 : n) / (n + 1);

hold on
figure(1)
plot(t, t, 'r', 'LineWidth', 2)
scatter(gumb, t, '.', 'b')
t  = 0 : 0.2 : 1;
t1 = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
title('PP Plot of Extreme Value - Gumbel','FontSize', 16, 'FontWeight', 'Bold')
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off
% print -painters -dpdf -r600 SFEevt2_01.pdf
% print -painters -dpng -r600 SFEevt2_01.png

% Frechet
frec1 = gevrnd(0.5, 0.5, 1, 100, 1);
frec2 = sort(frec1);
frec  = normcdf(frec2, 0, 1);
t     = (1 : n) / (n + 1);

figure(2)
hold on
plot(t, t, 'r', 'LineWidth', 2)
scatter(frec, t, '.', 'b')
xlim([0 1])
ylim([0 1])
t  = 0 : 0.2 : 1;
t1 = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
title('PP Plot of Extreme Value - Frechet', 'FontSize', 16, 'FontWeight', 'Bold')
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off
% print -painters -dpdf -r600 SFEevt2_02.pdf
% print -painters -dpng -r600 SFEevt2_02.png

% Weibull
weib1 = gevrnd(-0.5, 0.5, -1, 100, 1);
weib2 = sort(weib1);
weib  = normcdf(weib2, 0, 1);
t     = (1 : n) / (n + 1);

figure(3)
hold on
plot(t, t, 'r', 'LineWidth', 2)
scatter(weib, t, '.', 'b')
xlim([0 1])
ylim([0 1])
title('PP Plot of Extreme Value - Weibull', 'FontSize', 16, 'FontWeight', 'Bold')
t  = 0 : 0.2 : 1;
t1 = 0 : 0.2 : 1;
set(gca, 'YTick', t)
set(gca, 'YTickLabel', t1)
box on
set(gca, 'FontSize', 16, 'LineWidth', 2, 'FontWeight', 'bold');
hold off

% print -painters -dpdf -r600 SFEevt2_03.pdf
% print -painters -dpng -r600 SFEevt2_03.png

```

automatically created on 2022-06-02