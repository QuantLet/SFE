*--------------------------------------------------------------------------
* Book:         SFE3
* -------------------------------------------------------------------------
* Quantlet:     SFEpacfma2 
* -------------------------------------------------------------------------
* Description:  Plots the partial autocorrelation function of MA(2) Process
*--------------------------------------------------------------------------
* Usage:        -
*--------------------------------------------------------------------------
* Inputs:       lag - lag value
*               beta1 - value of beta_1
*               beta2 - value of beta_2
*--------------------------------------------------------------------------
* Output:       Plot of the partial autocorrelation function of MA(2) process
* -------------------------------------------------------------------------
* Example:      User inputs the SFEpacfma2 parameters [lag, beta1, beta2] 
*               as [30, 0.5, 0.4], plot of the partial autocorrelation 
*               function of MA(2) process is given.
*--------------------------------------------------------------------------
* Keywords:     PACF, MA, autocorrelation, moving average, partial, stochastic process
* -------------------------------------------------------------------------
* See also:     SFEacfma1, SFEacfma2, SFEacfar1, SFEacfar2, SFEpacfar2, SFEpacfma2, SFEplotma1, SFElikma1
* -------------------------------------------------------------------------
* Author  :     Daniel Traian Pele
*--------------------------------------------------------------------------

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

title Sample Partial Autocorrelation Function (PACF);

proc sgpanel data = acf1 ;
panelby var;
needle x = lag y = partcorr / markers
lineattrs = (color = red THICKNESS = 4)
markerattrs = ( symbol=circlefilled 
color = blue size = 6) ;
refline 0 / transparency=0.5   ;

run;
quit;
