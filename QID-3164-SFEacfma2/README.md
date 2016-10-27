
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEacfma2** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEacfma2

Published in : Statistics of Financial Markets

Description : 'Plots the autocorrelation function of a MA(2) (moving average) process for different
parameters.'

Keywords : 'acf, arma, autocorrelation, correlation, discrete, graphical representation, linear,
moving-average, plot, process, simulation, stationary, stochastic, stochastic-process, time-series'

See also : SFEacfar1, SFEacfar2, SFEacfma1, SFEpacfma2

Author[R] : Joanna Tomanek

Author[Matlab] : Ying Chen, Christian M. Hafner, Lasse Groth

Author[SAS] : Daniel T. Pele

Submitted[R] : Mon, June 08 2015 by Lukas Borke

Submitted[Matlab] : Tue, January 19 2010 by Lasse Groth

Submitted[SAS] : Tue, June 17 2014 by Sergey Nasekin

Input: 
- beta1: value of beta_1
- beta_2: value of beta_2
- lag: lag value

Example : 'Plots the ACF of a MA(2) process with beta1=0.5, beta2=0.4 (top left), beta1=0.5,
beta2=-0.4 (top right), beta1=-0.5, beta2=0.4 (bottom left) and beta1=-0.5, beta2=-0.4 (bottom
right).'

Example[Matlab] : 'User inputs the SFEacfma2 parameters [lag, beta1, beta2] as [30, 0.5, 0.4].
Plots of the autocorrelation function of MA(2) processes with [Î²1,Î²2] = [+/- 0.5, +/- 0.4] are
given.'

```

![Picture1](SFEacfma2-1.png)

![Picture2](SFEacfma2_M.png)

![Picture3](SFEacfma2_SAS.png)


### R Code:
```r

rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
lag	= 30	# lag value
b1	= 0.5	# value of beta_1
b2	= 0.4	# value of beta_2

par(mfrow = c(2, 2))

plot(ARMAacf(ar = numeric(0), ma = c(b1, b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF")

plot(ARMAacf(ar = numeric(0), ma = c(b1, -b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF")

plot(ARMAacf(ar = numeric(0), ma = c(-b1, b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF")

plot(ARMAacf(ar = numeric(0), ma = c(-b1, -b2), lag.max = lag, pacf = FALSE), 
    type = "h", xlab = "Lag", ylab = "Sample ACF")
title("ACF") 

```

### MATLAB Code:
```matlab

clear
clc
close all

% user inputs parameters
disp('Please input lag value lag, value of beta1, value of beta2 as: [30, 0.5, 0.4]') 
disp(' ') ;
para=input('[lag, beta1, beta2]=');

while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [30, 0.5, 0.4] or [30 0.5 0.4]');
    para=input('[lag, beta1, beta2]=');
end

lag=para(1);
beta1=para(2);
beta2=para(3);

% main computation
randn('state', 0)                      % Start from a known state.
x = randn(10000, 1);                   % 10000 Gaussian deviates ~ N(0, 1).
y1 = filter([1 beta1 beta2], 1, x);    % Create an MA(2) process.
y2 = filter([1 beta1 -beta2], 1, x);   % Create an MA(2) process.
y3 = filter([1 -beta1 beta2], 1, x);   % Create an MA(2) process.
y4 = filter([1 -beta1 -beta2], 1, x);  % Create an MA(2) process.

subplot(2,2,1)
autocorr(y1, lag, [], 2);              % Plot ACF for β1 = 0.5, β2 = 0.4

subplot(2,2,2)
autocorr(y2, lag, [], 2);              % Plot ACF for β1 = 0.5, β2 = −0.4

subplot(2,2,3) 
autocorr(y3, lag, [], 2);              % Plot ACF for β1 = −0.5, β2 = 0.4

subplot(2,2,4)
autocorr(y4, lag, [], 2);              % Plot ACF for β1 = −0.5, β2 = −0.4

```

### SAS Code:
```sas

goptions reset=all;

* user inputs parameters
* Please input lag value lag, value of beta1, value of beta2 as: [30, 0.5, 0.4]; 

%let lag	= 30;
%let beta1	= 0.5;
%let beta2	= 0.4;


* main computation;
data ma;
do t = 1 to 10000;
eps=rannor(0);			*Generate the Gaussian white noise with 10000 observations;
output;
end;

data ma;set ma;
y1 = eps+&beta1*lag(eps)+&beta2*lag2(eps);	*Generate the MA(2) process;
y2 = eps+&beta1*lag(eps)-&beta2*lag2(eps);	*Generate the MA(2) process;
y3 = eps-&beta1*lag(eps)+&beta2*lag2(eps);	*Generate the MA(2) process;
y4 = eps-&beta1*lag(eps)-&beta2*lag2(eps);	*Generate the MA(2) process;

run;

*Compute the ACF;

proc arima data = ma ;
identify var = y1  nlag = &lag outcov = acf1 noprint;
identify var = y2  nlag = &lag outcov = acf2 noprint;
identify var = y3  nlag = &lag outcov = acf3 noprint;
identify var = y4  nlag = &lag outcov = acf4 noprint;
run;
quit;


proc append data = acf2 base = acf1;
proc append data = acf3 base = acf1;
proc append data = acf4 base = acf1;
run;

data acf1;set acf1;
if lag=0 then delete;

data acf1;set acf1;
label var="MA(2) process";

*Plot the ACF graph;

title Sample Autocorrelation Function (ACF) - MA(2) process;

proc sgpanel data = acf1 ;
panelby var;
needle x = lag y = corr / markers
lineattrs = (color = red THICKNESS = 4)
markerattrs = ( symbol=circlefilled 
color = blue size = 6) ;
refline 0 / transparency=0.5   ;

run;
quit;

```
