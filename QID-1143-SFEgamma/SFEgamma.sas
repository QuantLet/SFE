* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEgamma  
* ---------------------------------------------------------------------
* Description:  SFEgamma plots the gamma of a call option
* ---------------------------------------------------------------------
* Usage:        SFEgamma  
* ---------------------------------------------------------------------
* Keywords:     Black Scholes, call, financial, greeks, option, gamma
* --------------------------------------------------------------------
* Inputs:       S_min - Lower Bound of Asset Price S
*               S_max - Upper Bound of Asset Price S
*               tau_min - Lower Bound of Time to Maturity tau
*               tau_max - Upper Bound of Time to Maturity tau
* ---------------------------------------------------------------------
* Output:       plot of the gamma of a call option
* ---------------------------------------------------------------------
* Example:      User inputs [lower, upper] bound of Asset price S like
*               [50,150], [lower, upper] bound of time to maturity tau 
*               like [0.01, 1], then plot of the gamma of a call option 
*               is given.
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------;

goptions reset=all;

***************************************************************************
..................Please input the parameters!.............................
***************************************************************************;

%let S_min 		=	50		;  *Lower Bound of Asset Price S;
%let S_max 		=   150		;  *Upper Bound of Asset Price S;
%let tau_min	=   0.05	;  *Lower Bound of Time to Maturity tau;
%let tau_max 	=	1		;  *Upper Bound of Time to Maturity tau;

* main computation;

proc iml;
S_min = &S_min; S_max = &S_max; tau_min = &tau_min; tau_max = &tau_max;

K = 100;                   *exercise price; 
r = 0   ;                  * interest rate;
sig = 0.25 ;               * volatility;
d = 0;                     * dividend rate;
b = r-d;                   *cost of carry;
steps  =  60;

*Computing tau;

tau = j(steps,steps,0);

do i = 1 to nrow(tau);
tau[i,] = (0:59)*(tau_max-tau_min)/(steps-1) +tau_min;
end;

*Computing S;

S = j(steps,steps,0);
do i = 1 to nrow(tau);
S[,i] = (0:59)`*(-(s_max-s_min)/(steps-1)) +s_max;
end;

*Computing gamma;


d1 = (log(S/K)+(r-d+sig**2/2)*tau)/(sig*sqrt(tau));
gamma = pdf('Normal',d1)/(S#(sig#sqrt(tau)));
*Creating frid for 3d surface plot;

S = (shape(S,1))`;
gamma = (shape(gamma,1))`;
tau = (shape(tau,1))`;
d3d = S||gamma||tau;

create d3d from d3d; append from d3d;
close d3d;

quit;


data d3d;set d3d;
rename col1 = S col2 = gamma col3 = tau;

*Plot the 3d surface graph;

 title h = 2 f = default 'Gamma as function of the time to maturity ' 
h = 3 f = greek '74'x h = 2 f = default ' and the asset price S';


proc g3d data = d3d ;
 plot S*tau = gamma/  cbottom = blue ctop = red 
grid  rotate=45 ;
run;
quit;

*The following section creates an animated 3D plot;

/* Designate a GIF file for the G3D output, like below. */
filename anim 'd:gamma.gif'; 
** Set the GOPTIONs necessary for the **/
/** animation. **/;
goption reset dev=gifanim gsfmode=replace
border gsfname=anim xpixels=640 ypixels=480 iteration=0 delay=60 gepilog='3B'x
/* add a termination char to the end of the GIF file */
disposal=background; 

proc g3d data = d3d ;
 plot S*tau = gamma/  cbottom = blue ctop = red 
grid rotate = 45 to 350 by 10;
  
run;
quit;


*Open the file 'd:gamma.gif' and enjoy the 3D animation;



