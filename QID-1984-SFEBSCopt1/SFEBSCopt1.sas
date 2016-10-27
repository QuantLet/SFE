
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

S = &S; K = &K; r = &r; b = &b; sig = &sig; tau = &#964; pi = constant('pi');

y = ( log(S/K) + (b-(sig**2)/2)*tau )/( sig*sqrt(tau) );

*Normal approximation a;

ba = 0.332672527;
t1 = 1/(1 + ba * y);
t2 = 1/(1 + ba *(y+sig*sqrt(tau)));
a1= 0.17401209;
a2= -0.04793922;
a3= 0.373927817;
norma1 = 1-(a1*t1+a2*(t1**2)+a3*(t1**3))*exp(-y*y/2);
norma2 = 1-(a1*t2+a2*(t2**2)+a3*(t2**3))*exp(-(y+sig*sqrt(tau))**2/2);
ca = exp(-(r-b)*tau)*S*norma2 - exp(-r*tau)*K*norma1;

*Normal approximation b;

bb = 0.231641888;
t1 = 1/(1 + bb * y);
t2 = 1/(1 + bb *(y+sig*sqrt(tau)));
a1 = 0.127414796;
a2 = -0.142248368;
a3 = 0.71070687;
a4 = -0.726576013;
a5 = 0.530702714;
normb1 = 1-(a1*t1+a2*(t1**2)+a3*(t1**3)+a4*(t1**4)+a5*(t1**5))*exp(-y**2/2);
normb2 = 1-(a1*t2+a2*(t2**2)+a3*(t2**3)+a4*(t2**4)+a5*(t2**5))*exp(-(y+sig*sqrt(tau))**2/2);
cb = exp(-(r-b)*tau)*S*normb2 - exp(-r*tau)*K*normb1;

*Normal approximation c;

a1= 0.09979268; 
a2= 0.04432014; 
a3= 0.00969920; 
a4=-0.00009862; 
a5= 0.00058155;
t1 = abs(y);
t2 = abs(y+sig*sqrt(tau));
normc1 = 1.0/2.0 - 1.0/( 2.0 * ( (1.0+a1*t1+a2*t1**2+a3*t1**3+a4*t1**4+a5*t1**5)**8 ) );
if y<0 then
    normc1 = 0.5 -normc1;
    else
	normc1 = 0.5 +normc1;	
normc2 = 1.0/2.0 - 1.0/( 2.0 * ( (1.0+a1*t2+a2*t2**2+a3*t2**3+a4*t2**4+a5*t2**5)**8 ) );

if (y+sig*sqrt(tau))<0
	then normc2 = 0.5 - normc2;
    else
	normc2 = 0.5 + normc2;	

cc = exp(-(r-b)*tau)*S*normc2 - exp(-r*tau)*K*normc1;

*Normal approximation d;

n = 0;
sum1 = 0;
sum2 = 0;
do while(n<=12);
	sum1 = sum1 + ( (-1)**n )*y**(2*n+1)/( fact(n)*2**n*(2*n+1) );
	sum2 = sum2 + ( (-1)**n )*(y+sig*sqrt(tau))**(2*n+1)/( fact(n)*2**n*(2*n+1) );
	n = n+1;
end;

normd1 = 0.5 + sum1/sqrt(2*pi);
normd2 = 0.5 + sum2/sqrt(2*pi);
cd = exp(-(r-b)*tau)*S*normd2 - exp(-r*tau)*K*normd1;

* Output;

print 'Price of European Call norm-a =' ca[label = none];

print 'Price of European Call norm-b =' cb[label = none];

print 'Price of European Call norm-c =' cc[label = none];

print ('Price of European Call norm-d =') cd[label = none];

quit; 
