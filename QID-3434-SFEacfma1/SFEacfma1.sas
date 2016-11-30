*--------------------------------------------------------------------------
* Book:        SFE3
*--------------------------------------------------------------------------
* Quantlet:    SFEacfma1 
* -------------------------------------------------------------------------
* Description: SFEacfma1 plots the autocorrelation function of MA(1)
*              Process.
*-------------------------------------------------------------------------
* Usage        
* ------------------------------------------------------------------------
* Inputs:
*   			lag   - lag value
*  				alpha - value of alpha_1
* -------------------------------------------------------------------------
* Keywords:     ACF, MA, autocorrelation, moving average, stochastic, process
*				stationary, simulation
* -------------------------------------------------------------------------
* Output:		plot of the autocorrelation function of MA(1) process
*---------------------------------------------------------------------------
* Example:     User inputs the SFEacfma1 parameters lag, alpha as 30, 0.5 and
*              plot of the autocorrelation function of MA(1) process is
*              given.
*--------------------------------------------------------------------------
* Author(s):   Daniel Traian Pele
*--------------------------------------------------------------------------;
goptions reset=all;

* user inputs parameters;
* Please input lag value lag, value of beta1 beta as: 30, 0.5 ;


%let lag	= 30;			
%let b		= 0.5;

data ma;
do t = 1 to 1000;
eps=rannor(0);			*Generate the Gaussian white noise;
output;
end;
data ma;set ma;
y = eps+&b*lag(eps);*Generate the MA(1) process with Gaussian innovations and 1000 observations;
run;


ods graphics on;

* Plot the ACF;
proc arima data = ma;
identify var = y  nlag=&lag outcov = acf noprint;
run;
quit;



data acf;set acf;
if lag=0 then delete;

data acf;set acf;
label var="MA(1) process";

*Plot the ACF graph;

 title Sample Autocorrelation Function (ACF) - MA(1) process;

proc sgplot data = acf ;
needle x = lag y = corr / markers
lineattrs = (color = red THICKNESS = 4)
markerattrs = ( symbol=circlefilled 
color = blue size = 6) ;
refline 0 / transparency=0.5   ;

run;
quit;

