* -------------------------------------------------------------------------
* Book:         SFE3
* -------------------------------------------------------------------------
* Quantlet:     SFElognormal
* -------------------------------------------------------------------------
* Description:  SFElognormal plots the normal and log normal 
*               distributions
*--------------------------------------------------------------------------
* Usage:        -
*--------------------------------------------------------------------------
* Keywords:     normal, lognormal, density
* -------------------------------------------------------------------------
* Inputs:       none
*--------------------------------------------------------------------------
* Output:       Plots comparing normal and lognormal densities          
* -------------------------------------------------------------------------
* Example:      
*--------------------------------------------------------------------------
* Author  :    Daniel Traian Pele
*--------------------------------------------------------------------------

* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

* Create the data for plotting the two distributions;
data plot;
do t = -5 to 15 by 0.1;
normal = pdf('normal',t);
output; end;

do i =  0.01 to 15 by 0.1;
lognormal = pdf('lognormal',i);
output; end;
run;

*Plot the densities;

title Normal and Log Normal Distribution;

proc sgplot data   =   plot;
series x   =   t  y   =   normal/ lineattrs   =   (color   =   blue THICKNESS   =   2 );
series x = i y = lognormal/lineattrs   =   (color   =   red THICKNESS   =   2 pattern = dash) ;
yaxis label   =  'Density';
xaxis label   =  'Value';
run;
quit;
