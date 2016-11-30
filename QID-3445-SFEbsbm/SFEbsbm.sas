*--------------------------------------------------------------------------
* Book:         SFE3
* -------------------------------------------------------------------------
* Quantlet:     SFEbsbm
* -------------------------------------------------------------------------
* Description:  SFEbsbm plots BS price as a function of a Brownian Motion
*               S_t
*--------------------------------------------------------------------------
* Usage:        
*--------------------------------------------------------------------------
* Inputs:        S0	 - initial price;
*				 K	 - strike price;
*				 r	 - interest rate;
*				 si	 - sigma; 
*				 tau - maturity.
*--------------------------------------------------------------------------
* Output:       Plot of the Call Black-Scholes price as a function of a
*               Brownian Motion S_t
* -------------------------------------------------------------------------
* Keywords:     Black Scholes, brownian motion, call, put, option
* -------------------------------------------------------------------------
* Example:      The plot is generated for the following parameter values:
*               S0=100, K=110, r=0.05, si=0.3, tau=0.02
*--------------------------------------------------------------------------
* Author  :     Daniel Traian Pele
*--------------------------------------------------------------------------;

* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

***************************************************************************;
* **************Please input the parameters!********************************
***************************************************************************;

%let S0		= 100; 	*Input initial price;
%let K		= 110;	*Input strike price;
%let r		= 0.05;	*Input interest rate;
%let si		= 0.3;	*Input sigma; 
%let tau	= 0.02;	*Input maturity;

proc iml;

* set parameters;
S0   = &S0;
K 	 = &K;
r 	 = &r;
si   = &si;
tau  = &tau;

* Black-Scholes formula for European call price with b  =  r
(costs of carry  =  risk free interest rate 
-> the underlying pays no continuous dividend);

start blsprice(S, K, r, sigma, tau);

	if tau = 0 then t = 1;
	else t = 0;

	y     =  (log(S/K) + (r - sigma**2 / 2) * tau)/(sigma * sqrt(tau) + t);
	cdfn  =  cdf('Normal', y + sigma * sqrt(tau));

	if t = 0 then tl  =  1;
	else tl  =  0;
	    Call  =  S * (cdfn * tl + t) - K * exp(-r * tau) * cdf('Normal', y) * tl + t;
	    Put  =  K * exp(-r * tau) * (cdf('Normal', -y)) * tl + t - S * (cdf('Normal', -y - sigma * sqrt(tau)) * tl + t);
		CallPut = j(1,2,0);
		CallPut[1,1] = Call;
		CallPut[1,2] = Put;
	return(CallPut);

finish;

* main computation;
n   = 1000;
t   =  (1:n)`/ n;
dt  = t[2] - t[1];
Wt1 = j(nrow(t),1,0);
call randgen(Wt1,'Normal');
Wt  = cusum(Wt1);
St  =  S0 * exp((r - 0.5 * si ) * dt + si * sqrt(dt) * Wt);
CallPut =  j(nrow(St),2,0);

*Calculate Black Scholes prices as a function of S;

do i  =  1 to nrow(St);
CallPut[i,]  =   blsprice(St[i,1], K, r, si, tau);
end;

callput = t||st||callput;
create callput from callput; append from callput;
close callput;
quit;


data callput;set callput;
rename col1 = t col2 = St col3 = Call col4 = Put;

*Plot the Black Scholes call price ;

title Black-Scholes call price;

proc sgplot data  =  callput ;
series x  =  t y  =  Call/lineattrs  =  (color  =  blue THICKNESS  =  2);

yaxis label  =  'C(s,tau)';
xaxis label = 't' ;

run;
quit;

*Plot the Brownian motion ;

title Brownian motion;

proc sgplot data  =  callput ;
series x  =  t y  =  St/lineattrs  =  (color  =  red THICKNESS  =  2 );

yaxis label  =  'S(t)';
xaxis label='t' ;

run;
quit;
