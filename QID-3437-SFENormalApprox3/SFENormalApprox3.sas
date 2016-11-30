* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFENormalApprox3 
* ---------------------------------------------------------------------
* Description:  SFENormalApprox3 computes numerical approximation to 
*               Normal cdf b
* ---------------------------------------------------------------------
* Usage:        SFENormalApprox3
* ---------------------------------------------------------------------
* Inputs:       none
* ---------------------------------------------------------------------
* Output:       phi - approximation of Normal cdf at different values
* ---------------------------------------------------------------------
* Example:      Estimated normal cdf at that points 1:0.1:2 are given: 
*               [0.8414 0.8643 0.8849 0.9032 0.9192 0.9332 0.9452 
*				0.9554 0.9641 0.9713 0.9773].
*----------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------;

* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

Proc iml;
* main computation;
y  =  0.1*(10:20)`;
a1 = 0.09979268; 
a2 = 0.04432014; 
a3 = 0.00969920; 
a4 =-0.00009862; 
a5 = 0.00058155;
t  = abs(y);
s  = 0.5 - 1/( 2* ( (1+a1*t+a2*t##2+a3*t##3+a4*t##4+a5*t##5)##8 ) ); 

phi = 0.5+s#(-2*(y<0)+1);
plot = y||phi;
create plot from plot;append from plot;
close plot;
quit;


data plot;set plot;
rename col1 = y col2 = phi ;

*Plot the approximation to normal cdf;

title Approximation to normal cdf c;

proc sgplot data  =  plot ;
series x  		  =  y y  =  phi / lineattrs = (color  =  blue THICKNESS  =  2) 
legendlabel       = "Estimated normal cdf";

scatter x         =  y y  =  phi/ 
   markerattrs    = ( symbol=circlefilled color=red size=12 )
legendlabel       = "Estimation Points" ;

yaxis label  =  'Cdf';
xaxis label  = 'x' ;
run;
quit;

proc print data = plot;
run;