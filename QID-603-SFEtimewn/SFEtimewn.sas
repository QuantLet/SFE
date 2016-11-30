* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEtimewn
* ---------------------------------------------------------------------
* Description:  Simulates and plots a normaly distributed white noise process
* ---------------------------------------------------------------------
* Usage:        SFEtimewn
* ---------------------------------------------------------------------
* Keywords:     white noise, normal, distribution, simulation, stochastic process
* ----------------------------------------------------------------------
* Inputs:       none
* ---------------------------------------------------------------------
* Output:       y - time series of a simulated normaly distributed
*               white noise process
*               plot of the time series y
* ---------------------------------------------------------------------
* Example:      
* ---------------------------------------------------------------------
* Author:  		Daniel Traian Pele
* ---------------------------------------------------------------------

goptions reset=all;

* generate white noise;

%let n = 1000;  *Number of observations;

data wn;
	do t = 1 to &n;
		wn = rannorm(0);
		output;
	end;
run;

*Plot the white noise;
title Simulated Gaussian white noise;

proc sgplot data   =   wn ;
series x = t  y = wn/ lineattrs = (color = blue THICKNESS = 2) ;
yaxis label = 'White noise';
xaxis label = 'Time';
run;
quit;