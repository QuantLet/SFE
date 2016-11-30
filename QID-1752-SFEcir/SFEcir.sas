* -------------------------------------------------------------------------
* Book:         SFE
* -------------------------------------------------------------------------
* Quantlet:     SFEcir
* -------------------------------------------------------------------------
* Description:  SFEcir plots the CIR term structure.
* -------------------------------------------------------------------------
* Usage:        - 
* -------------------------------------------------------------------------
* Keywords:     CIR, interest rate, term structure
* -------------------------------------------------------------------------
* Inputs:       Parameters of the CIR model(k,mu,sigma), time horizon,
*               today's short rate.
* -------------------------------------------------------------------------
* Output:       Plot of the CIR term structure.              
* -------------------------------------------------------------------------
* Example:      - 
* -------------------------------------------------------------------------
* Author:      Daniel Traian Pele      
* -------------------------------------------------------------------------;

goptions reset=all;

* user inputs parameters;
* Input k, mu, sigma, n, sr like 0.1,0.1,0.1,50,0.05; 

%let k		=	0.1;	*reversiona rate;
%let mu		=	0.1;	*steady rate;
%let sigma	=	0.1;	*volatility;
%let n		=	50;		*time horizon;
%let sr		=	0.05;	* short rate at time t;

*Main calculation;

proc iml;

	  k	   = &k;
	  mu   = &mu;
	  sigma= &sigma;
	  n	   = &n;
	  sr   = &sr;
	  tau  = (1:n)`;              * vector of maturities in years;
	  gam  = sqrt(k**2+2*sigma**2);
	  ylim = 2*k*mu/(gam+k);
	  g    = 2*gam + (k+gam)*(exp(gam*tau)-1);
	  b    = -(2*(exp(gam*tau)-1))/g;
	  a    = 2*k*mu/sigma**2*log(2*gam*exp((k+gam)*tau/2)/g);
	  p    = exp(a+b*sr);      * the bond prices;
	  y    = (-1/tau)#log(p);   * the yields;
	  w    = y;
	  wlim = tau||j(n,1,1)#ylim;
 plot = w||wlim;
 create plot from plot; append from plot;
 close plot;

quit;


*Plot the graph of CIR process;

data plot;set plot;
rename col1 = yield 
	   col2 = time
	   col3 = lim;

 title 'Yield Curve, CIR Model';


proc sgplot data = plot noautolegend;
series x = time y = yield/lineattrs = (color = blue THICKNESS = 3);
series x = time y = lim/lineattrs = (color = red THICKNESS = 4);

yaxis label = 'Yield' ;
xaxis label = 'Time to Maturity' ;


run;
quit;