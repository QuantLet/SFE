* ------------------------------------------------------------------------------
* Book          SFE3
* ------------------------------------------------------------------------------
* Quantlet      SFEacfar2
* ------------------------------------------------------------------------------
* Usage:        -
* ------------------------------------------------------------------------------
* Inputs:       lag - lag value
*               a1  - alpha_1
*               a2  - alpha_2
* ------------------------------------------------------------------------------
* Output:       Plot of the ACF for an AR(2) process.
* ------------------------------------------------------------------------------
* Description:  SFEacfar2 asks interactively for the beta and lag parameter for 
*               an AR(2) process and plots the autocorrelation function of AR(2) 
*               process.               
* ------------------------------------------------------------------------------
* Example:      -  
* ------------------------------------------------------------------------------
* Keywords:     AR, ACF, autocorrelation, autoregressive,  process, stochastic,
*				stationarity, simulation
* ------------------------------------------------------------------------------
* See also:     SFEacfma1, SFEacfma2, SFEacfar1, SFEacfar2, SFEpacfar2, 
*               SFEpacfma2, SFEplotma1, SFElikma1, SFElikma1
* ------------------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ------------------------------------------------------------------------------;

goptions reset=all;

* user inputs parameters
* Please input lag value lag, value of beta1, value of beta2 as: [30, 0.5, 0.4]; 

%let lag	= 30;
%let a1  	= 0.5;
%let a2 	= 0.4;


* main computation;
proc iml;
call randseed(0); 
z = j(10000,1,0);  
call randgen(z, "Normal");	*Generate the Gaussian white noise with 10000 observations;

y = z;  

do i = 3 to 10000;

y[i,1] = z[i,1] + &a1*y[i-1,1] + &a2*y[i-2,1]; *Generate the AR(2) process;

end;

create ar from y; append from y;
close ar;
quit;

data ar; set ar;
rename col1 = y;
*Compute the ACF;

proc arima data = ar ;
identify var = y  nlag = &lag outcov = acf noprint;
run;
quit;



data acf; set acf;
if lag = 0 then delete;

data acf;set acf;
label var = "AR(2) process";

*Plot the ACF graph;

 title Sample Autocorrelation Function (ACF)- AR(2) process;

proc sgplot data = acf  ;
needle x = lag y = corr / markers
lineattrs = (color = red THICKNESS = 4)
markerattrs = ( symbol=circlefilled 
color = blue size = 6) ;
refline 0 / transparency=0.5   ;

run;
quit;

