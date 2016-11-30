* ------------------------------------------------------------------------------
* Book          SFE3
* ------------------------------------------------------------------------------
* Quantlet      SFEplotma1
* ------------------------------------------------------------------------------
* Usage:        -
* ------------------------------------------------------------------------------
* Description:  Plots two MA(1) processes                 
* ------------------------------------------------------------------------------
* Inputs:       n1, n2 - lags
*               beta - moving average coefficient
* ------------------------------------------------------------------------------
* Output:       Two realizations of an MA(1) process with MA coefficient  =  beta,
*               random normal innovations and n = n1 (above) and n = n2 (below).
* ------------------------------------------------------------------------------
* Example:      An example is produced for beta = 0.5, n1 = 100 and n2 = 200.  
* ------------------------------------------------------------------------------
* Keywords:     MA, moving average
* ------------------------------------------------------------------------------
* See also:     SFEacfma1, SFEacfma2, SFEacfar1, SFEacfar2, SFEpacfar2, SFEpacfma2, SFEplotbeta1, SFElikma1, SFElikma1
* ------------------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ------------------------------------------------------------------------------

goptions reset = all;

* User input parameters;

%let n1	   =  10;
%let n2    =  20;
%let beta  =  0.5;

*Simulate MA(1) processes;

data ma1;
do t  =  0 to &n1;
eps = rannor(0);			*Generate the Gaussian white noise with n1 observations;
output;
end;

data ma2;
do t  =  0 to &n2;
eps = rannor(0);			*Generate the Gaussian white noise with n2 observations;
output;
end;
data ma1;set ma1;
y  =  eps + &beta * lag(eps);	*Generate the first MA(1) process;

data ma2;set ma2;
y  =  eps + &beta * lag(eps);	*Generate the second MA(1) process;
run;

*Plot the MA(1) graphs;

proc greplay nofs igout = work.gseg;
  delete _all_;
run;
title MA(1) process with &n1 observations h = 1;

symbol i = line interpol = join c = red w = 2;
goptions device = png nodisplay xpixels = 300 ypixels = 200;

proc gplot data = ma1;
plot y*t;
run;
quit;

title MA(1) process with &n2 observations h = 1 ;
goptions device = png nodisplay xpixels = 300 ypixels = 200;
symbol i = line interpol = join c = blue w = 2;

proc gplot data = ma2;
plot y*t;
run;
quit;
goptions device = png display xpixels = 600 ypixels = 500;

proc greplay igout = gseg tc = sashelp.templt nofs;
template = v2;
treplay 1:gplot 2:gplot1;
run;
quit;
