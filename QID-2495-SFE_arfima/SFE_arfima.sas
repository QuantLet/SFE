* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEarfima
* ---------------------------------------------------------------------
* Description:  Computes the arfima(p,d,q) time series.
* ---------------------------------------------------------------------
* Usage:        -
* ---------------------------------------------------------------------
* Keywords:		fractional brownian motion, simulation, stochastic,process,
*				Hurst exponent, fractional, gaussian noise, ARFIMA,long memory.
* ---------------------------------------------------------------------
* Inputs:      N - Length of the generated time series
*              AR - coefficients of the AR polynomial
*              MA - coefficients of the MA polynomial
*              d -  fractionally differencing parameter (long memory)
* --------------------------------------------------------------------------
* Output:      ARFIMA(p,d,q) time series
* --------------------------------------------------------------------------
* Example:     Plot two examples with n1=1000, n2=1000, d1=0.4, d2=-04
				p = q = 1, AR = {1}`, MA = {1}`.
* ------------------------------------------------------------------------
* Author:       Daniel Traian Pele
* -----------------------------------------------------------------------;

* Reset the working evironment;
goptions reset  =  all;
proc datasets lib  =  work nolist kill;
run;
proc greplay nofs igout = work.gseg;
  delete _all_;
run;

* Input the parameters;
%let d  = 0.4;  		    *long memory parameter;
%let n	= 1000; 		    *number of observations;
%let p  = 1;			    *Order of AR polynomial;
%let q  = 1;			    *Order of MA polynomial;

%let AR = {1}`;   *AR polynomial coefficients;
%let MA = {1}`;  *MA polynomial coefficients;

%macro arfima(n = , d = , AR = , MA = );
proc iml;

   call farmasim(yt, &d, &AR, &MA, 0, 1, &n);  
   * Generates ARFIMA(p,d,q) process with Gaussian white noise N(0,1);
  t = (1:&n)`;

  plot = t||yt;

  create plot from plot; append from plot;
  close plot;
	
quit;

* The dataset plot contains the ARFIMA process motion Yt;

 data plot;set plot;
 rename col1 = t;
 rename col2 = Yt;
 run;



 *Plot the ARFIMA graph;


 title 'ARFIMA(p='&p', d='&d, q=&q) process with &n observations;


symbol i = line interpol = join c = blue w = 1.5;
goptions device = png nodisplay ;*xpixels = 200 ypixels = 100;

proc gplot data = plot;
plot Yt*t;
run;
quit;



%mend;


%arfima(n = 1000 , d = 0.4, AR = &AR, MA = &MA );  *ARFIMA with d = 0.4;

%arfima(n = 1000 , d = -0.4, AR = &AR, MA = &MA ); *ARFIMA with d = -0.4;

 
* Overlay the two graphs;

goptions device = png display xpixels = 600 ypixels = 800;

proc greplay igout = gseg tc = sashelp.templt nofs;
template = v2;
treplay 1:gplot 2:gplot1 ;
run;
quit;
