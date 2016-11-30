* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

***************************************************************************
..................Please input the parameters!.............................
***************************************************************************;

%let S_min 		=	50		;  *Lower Bound of Asset Price S;
%let S_max 		=   150		;  *Upper Bound of Asset Price S;
%let tau_min	=   0.01	;  *Lower Bound of Time to Maturity tau;
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

*Computing theta;


d1 = (log(S/K)+(r-d+sig**2/2)*tau)/(sig*sqrt(tau));
y=(log(S/K)+(r-d-sig**2/2)*tau)/(sig*sqrt(tau));
theta=-((exp(-d#tau)#pdf('Normal',d1)#S#sig)/(2*sqrt(tau)))-(r*K*exp(-r#tau)#cdf('Normal',y));

*Creating frid for 3d surface plot;

S = (shape(S,1))`;
theta = (shape(theta,1))`;
tau = (shape(tau,1))`;
d3d = S||theta||tau;

create d3d from d3d; append from d3d;
close d3d;

quit;


data d3d;set d3d;
rename col1 = S col2 = theta col3 = tau;

*Plot the 3d surface graph;

 title h = 2 f = default 'Theta as function of the time to maturity ' 
h = 3 f = greek '74'x h = 2 f = default ' and the asset price S';


proc g3d data = d3d ;
 plot S*tau = theta/  cbottom = blue ctop = red 
grid zmin=-50 zmax=0 rotate=45 ;
run;
quit;


*The following section creates an animated 3D plot;

/* Designate a GIF file for the G3D output, like below. */
filename anim 'd:theta.gif'; 
** Set the GOPTIONs necessary for the **/
/** animation. **/;
goption reset dev=gifanim gsfmode=replace
border gsfname=anim xpixels=640 ypixels=480 iteration=0 delay=60 gepilog='3B'x
/* add a termination char to the end of the GIF file */
disposal=background; 

proc g3d data = d3d ;
 plot S*tau = theta/  cbottom = blue ctop = red 
grid zmin=-50 zmax=0 rotate = 45 to 350 by 10;
  
run;
quit;


*Open the file 'd:theta.gif' and enjoy the 3D animation;