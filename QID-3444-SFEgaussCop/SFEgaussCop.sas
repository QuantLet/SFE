* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEgaussCop
* ---------------------------------------------------------------------
* Description:  Plots pdf, cdf and corresponding contour plots of Gaussian copula.
* ---------------------------------------------------------------------
* Usage:        -
* ---------------------------------------------------------------------
* Keywords:     Copula, Gaussian, density, distribution
* ---------------------------------------------------------------------
* Inputs:
* -----------------------------------------------------------------------
* Output:      Plots pdf, cdf and corresponding contour plots of Gaussian copula.
* -----------------------------------------------------------------------
* Example:     The plots are generated for the following parameter value
*              of Gaussian copula: rho=0.5 . 
* ---------------------------------------------------------------------
* Author:    Daiel Traian Pele
* ---------------------------------------------------------------------;

* Reset the working evironment;
goptions reset = all;

proc datasets lib = work nolist kill;
run;
 

ods graphics on;
data corr;			* The correlation matrix;
					* The default value of rho is 0.5;
input COL1 COL2 ;
cards;
1 0.5
0.5 1
;
run;

*Simulate normal copula and plot pdf and contour plot;
proc copula ;
   var Y1-Y2;
   define cop normal (corr=corr);
   simulate cop /
            ndraws     = 1000
            seed       = 1234
            outuniform = normal_unifdata
            plots      = (
                          distribution =  pdf );
run;


*Simulate normal copula and plot cdf and contour plot;
proc copula ;
   var Y1-Y2;
   define cop normal (corr=corr);
   simulate cop /
            ndraws     = 1000
            seed       = 1234
            outuniform = normal_unifdata
            plots      = (
                          distribution =  cdf );
run;


ods graphics off;