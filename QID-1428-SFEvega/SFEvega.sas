* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEvega  
* ---------------------------------------------------------------------
* Description:  SFEvega plots the vega of a call option
* ---------------------------------------------------------------------
* Usage:        SFEvega  
* ---------------------------------------------------------------------
* Keywords:     Black Scholes, call, financial, greeks, option, vega
* -------------------------------------------------------------------
* Inputs:       Smin - Lower Bound of Asset Price S
*               Smax - Upper Bound of Asset Price S
*               tauMin - Lower Bound of Time to Maturity tau
*               tauMax - Upper Bound of Time to Maturity tau
* ---------------------------------------------------------------------
* Output:       plot of the vega of a call option
* ---------------------------------------------------------------------
* Example:      User inputs [lower, upper] bound of Asset price S like
*               [50,150], [lower, upper] bound of time to maturity tau 
*               like [0.01, 1], then plot of the vega of a call option 
*               is given.
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------;

* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;
***************************************************************************
..................Please input the parameters!.............................
***************************************************************************;

%let Smin   = 50    ;  *Lower Bound of Asset Price S;
%let Smax   = 150   ;  *Upper Bound of Asset Price S;
%let tauMin	= 0.01  ;  *Lower Bound of Time to Maturity tau;
%let tauMax = 1     ;  *Upper Bound of Time to Maturity tau;

* main computation;

proc iml;
Smin = &Smin; Smax = &Smax; tauMin = &tauMin; tauMax = &tauMax;

K      = 100;                   *exercise price; 
r      = 0   ;                  * interest rate;
sig    = 0.25 ;               * volatility;
d      = 0;                     * dividend rate;
b      = r - d;                   *cost of carry;
steps  = 60;

*Computing tau;

tau = j(steps,steps,0);

do i = 1 to nrow(tau);
tau[i,] = (0:59)*(tauMax-tauMin)/(steps-1) + tauMin;
end;

*Computing S;

S = j(steps,steps,0);
do i = 1 to nrow(tau);
S[,i] = (0:59)`*(-(Smax-Smin)/(steps-1)) + Smax;
end;

*Computing vega;


d1   = (log(S/K)+(r-d+sig**2/2)*tau)/(sig*sqrt(tau));
Vega = S#exp(-d#tau)#pdf('Normal',d1)#sqrt(tau);

*Creating grid for 3d surface plot;

S    = (shape(S,1))`;
vega = (shape(vega,1))`;
tau  = (shape(tau,1))`;
d3d  = S||vega||tau;

create d3d from d3d; append from d3d;
close d3d;

quit;


data d3d;set d3d;
rename col1 = S col2 = vega col3 = tau;

*Plot the 3d surface graph;

 title h = 2 f = default 'Vega as function of the time to maturity ' 
h = 3 f = greek '74'x h = 2 f = default ' and the asset price S';


proc g3d data = d3d ;
 plot S*tau = vega/  cbottom = red ctop = magenta
grid  rotate=45;
run;
quit;

*The following section creates an animated 3D plot;

/* Designate a GIF file for the G3D output, like below. */
filename anim 'd:vega.gif'; 
** Set the GOPTIONs necessary for the **/
/** animation. **/;
goption reset dev=gifanim gsfmode=replace
border gsfname=anim xpixels=640 ypixels=480 iteration=0 delay=60 gepilog='3B'x
/* add a termination char to the end of the GIF file */
disposal=background; 

proc g3d data = d3d ;
 plot S*tau = vega/  cbottom = red ctop = magenta 
grid rotate = 45 to 350 by 10;
  
run;
quit;
*Open the file 'd:vega.gif' and enjoy the 3D animation;
