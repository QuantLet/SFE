* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

************************************************************************
....................PLEASE INPUT THE PARAMETERS.........................
***********************************************************************;

%let  S		=	230 	;	*Input spot price;
%let  K		= 	210 	;   *Input strike price;
%let  r		=	0.04545 ; 	*Input interest rate; 
%let  b		=	0.04545	;	*Input cost of carry;
%let  sig	=	0.25	;	*Input volatility;
%let  tau	=	0.5		;   *Input maturity;

* main computation;

proc iml;

S = &S; K = &K; r = &r; b = &b; sig = &sig; tau = &tau; pi = constant('pi');

y = ( log(S/K) + (b-(sig**2)/2)*tau )/( sig*sqrt(tau) );
c = exp(-(r-b)*tau)*S*cdf('Normal',y + sig*sqrt(tau)) - exp(-r*tau)*K*cdf('Normal',y);

* Output;

print 'Asset price S =' 			S [label=none];
print 'Strike K=' 					K [label=none];
print 'Interest rate r=' 			r  [label=none];
print 'Costs of carry b=' 			b [label=none];
print 'Volatility sigma=' 			sig [label=none];

print 'Time to expiration tau=' 	tau [label=none];

print 'Price of European Call =' 	C [label=none];

quit;
