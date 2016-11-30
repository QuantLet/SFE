* -------------------------------------------------------------------------
* Book:         SFE3
* -------------------------------------------------------------------------
* Quantlet:     SFEpacfar2 
* -------------------------------------------------------------------------
* Description:  Plots the particial autocorrelation function of AR(2) Process
* -------------------------------------------------------------------------
* Usage:        -
* -------------------------------------------------------------------------
* Inputs:       lag - lag value
*               a1 - value of alpha_1
*               a2 - value of alpha_2
* -------------------------------------------------------------------------
* Output:       Plot of the autocorrelation function of AR(2) process      
* -------------------------------------------------------------------------
* Example:      User inputs the SFEacfar2 parameters [lag, a1, a2] as 
*               [30, 0.5, 0.4], plot of the partial autocorrelation 
*               function of AR(2) process is given.
*--------------------------------------------------------------------------
* Keywords:     PACF, AR, autocorrelation, autoregressive, partial, stochastic process
* -------------------------------------------------------------------------
* See also:     SFEacfma1, SFEacfma2, SFEacfar1, SFEacfar2, SFEpacfar2, SFEpacfma2, SFEplotma1, SFElikma1
* -------------------------------------------------------------------------
* Author  :     Daniel Traian Pele
*------------------------------------------------------------------------

goptions reset=all;

* user inputs parameters
* Please input lag value lag, value of beta1, value of beta2 as: [30, 0.5, 0.4]; 

%let lag	= 30;
%let a1	= 0.5;
%let a2	= 0.4;


* main computation;
proc iml;
call randseed(0); 
z = j(10000,4,0);  
call randgen(z, "Normal");	*Generate the Gaussian white noise with 10000 observations;

y = z;  

do i = 3 to 10000;

y[i,] = z[i,] + &a1*y[i-1,] + &a2*y[i-2,]; *Generate the AR(2) process;

end;

create ar from y; append from y;
close ar;
quit;

data ar; set ar;
rename col1 = y1 col2=y2 col3=y3 col4=y4;

*Compute the PACF;

proc arima data = ar ;
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
label var="AR(2) process" ;

*Plot the PACF graph;

title Sample Partial Autocorrelation Function (PACF);

proc sgpanel data = acf1 ;
panelby var;
needle x = lag y = partcorr / markers
lineattrs = (color = red THICKNESS = 4)
markerattrs = ( symbol=circlefilled 
color = blue size = 6) ;
refline 0 / transparency=0.5 ;

run;
quit;
