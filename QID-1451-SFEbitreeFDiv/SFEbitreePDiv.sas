* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEbitreePDiv
* ---------------------------------------------------------------------
* Description:  SFEbitreePDiv computes European/American option prices
*               using a binomial tree for assets with dividends as a 
*               percentage of the stock price amount.
* ---------------------------------------------------------------------
* Usage:        -
* ---------------------------------------------------------------------
* Keywords:     American, European, binomial, call, option, put, tree
* --------------------------------------------------------------------
* Inputs:       s0 - Stock Price
*               k - Exercise Price
*               i - Interest Rate
*               sig - Volatility
*               t - Time to Expiration
*               n - Number of Intervals
*               type - 0 is American/1 is European
*               flag - 1 is call/0 is Put
*               nodiv - Times of Dividend Payoff
*               tdiv - Time Point of Dividend Payoff
*               pdiv - Dividends as a percentage of the stock price amount
* ---------------------------------------------------------------------
* Output:       binomial trees and price of option
* ---------------------------------------------------------------------
* Example:      User inputs the SFEbitreePDiv parameters
*               [s0, k, i, sig, t, n, type] like
*               [230, 210, 0.04545, 0.25, 0.5, 5, 1],
*               [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as
*               [1, 1, 0.15, 0.01], then call price 28.3836 is shown.
*               [s0, k, i, sig, t, n, type] like
*               [1.50, 1.50, 0.08, 0.2, 0.33, 6, 1],
*               [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as
*               [1, 1, 0.15, 0.01], then call price 0.0794 is shown.
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------;

Goptions reset=all;

** User inputs parameters;
*Please input Price of Underlying Asset s0, 
Exercise Price k, Domestic Interest Rate per Year i;

%let s0		=   230;	 *Price of Underlying Asset s0;
%let k		=   210; 	 *Exercise Price k;
%let i		=   0.04545; *Domestic Interest Rate per Year i;

*Please input Volatility per Year sig, Time to Expiration (Years) t,
Number of steps n, type;

%let sig	=	0.25;	 *Volatility per year sig;
%let t		=	0.5;	 *Time to Expiration (years) t;
%let n		=   5;		 *Number of steps n;
%let type	=	1;		 *Type 0 is American/1 is European;


*Please input option choice, Number of pay outs, time point of dividend payoff;

%let flag	=	0;                 * 1 for call, 0 for put option choice;
%let nodiv	=	1;                 * Times of dividend payoff;
%let tdiv	=	0.15;        	   * Time point of dividend payoff;
%let pdiv 	=	0.01; 			   * Dividends as a percentage of the stock price amount;

*********************************************************************************************;


proc iml;

s0 	 	= 	&s0;               * Stock price;
k  		= 	&k;                * Exercise price;
i		= 	&i;                * Interest rate;
sig	 	= 	&sig;         	   * Volatility;
t    	= 	&t;			       * Time to expiration;
n	 	= 	&n;                * Number of intervals;
type 	= 	&type;             * 0 is American/1 is European;
flag	=	&flag;             * 1 for call, 0 for put option choice;
nodiv	=	&nodiv;            * Times of dividend payoff;
tdiv	=	&tdiv;        	   * Time point of dividend payoff;
pdiv 	=	&pdiv; 			   * Dividends as a percentage of the stock price amount;


*Check conditions;
if s0<=0
    then print('SFEBiTree: Price of Underlying Asset should be positive! 
				Please input again');
   

if k<0 
	then print('SFEBiTree: Exercise price couldnot be negative! 
				Please input again');
    

if sig<0
   then print('SFEBiTree: Volatility should be positive! 
				Please input again');
   
if t<=0
 then print('SFEBiTree: Time to expiration should be positive! 
			Please input again');

if n<1
   then print('SFEBiTree: Number of steps should be at least equal to 1! 
				Please input again');



if pdiv<0
    then print('SFEBiTree: Dividend must be nonnegative! 
				Please input again');

** Main computation;

dt	=  t/n;                                * Interval of step;
u	=  exp(sig*sqrt(dt));                  * Up movement parameter u;
d	=  1/u;                                * Down movement parameter d;
b	=  i;                                  * Costs of carry;
p	=  0.5+0.5*(b-sig**2/2)*sqrt(dt)/sig;   * Probability of up movement;

tdivn  		=  floor(tdiv/t*n-0.0001)+1;
s 			= j(n+1,n+1,1)*s0;
un	    	= j(n+1,1,1)-1;
un[n+1,1] 	= 1;
dm 			= un`;
um		    = j(n+1,1,0);
um[n+1,1]	=1;
m			=1;

do while(m<n+1);

	if m<n then d1 = (j(1,n-m,0))||(j(1,m+1,1)#d)##(0:m);
	else d1 = (j(1,m+1,1)#d)##(0:m);
   
    dm = (dm`||d1`)`; 									  * Down movement dynamics;
	
    if m<n then u1 = (j(1,n-m,1)-1)||((j(1,m+1,1)*u)##do(m, 0, -1));
	else u1 = ((j(1,m+1,1)*u)##do(m, 0, -1));
    um  = (um||u1`);                                       * Up movement dynamics;
    m = m+1;
end;

dm = dm`;
s = s0#um#dm;                                  * Stock price development;

	j = 1;

	do while (j<= nodiv);
		do i = tdivn[j]+1 to n+1;
 		s[,i] = s[,i]*(1-pdiv);
		j  =  j+1;
		end;
	end;


	print 'Stock price ' s[label = none];
	s = s[nrow(s):1,];                                    * Rearrangement;
opt = j(nrow(s), ncol(s),0);

** Option is a american call;

if (flag = 1) & (type = 0) then do; 
    opt[,n+1] = (s[,n+1]-k)#((s[,n+1]-k)>0);  * Determine option values from prices;
    do j = n to 1 by -1;
        * Probable option values discounted back one time step;
        discopt = ((1-p)*opt[1:j,j+1]+p*opt[2:j+1,j+1])*exp(-b*dt);
	
        * Option value is max of current price - X or discopt;
        opt[,j] = ((s[1:j,j]-k)#((s[1:j,j]-k)>=discopt)+
			(discopt)#((s[1:j,j]-k)<discopt))//j(n+1-j,1,0);
    end;

	opt = opt[nrow(opt):1,]; 
	a = opt[n+1,1];

  print 'The price of the American call option at time t_0 is 'a[label = none];
end;
  ** Option is a european call;

if (flag = 1) & (type = 1) then do;  
	
    opt[,n+1] =(s[,n+1]-k)#((s[,n+1]-k)>0) ;   * Determine option values from prices;
	print opt;
    do j = n to 1 by -1;
        * Probable option values discounted back one time step;
        discopt = ((1-p)*opt[1:j,j+1]+p*opt[2:j+1,j+1])*exp(-b*dt);
        * Option value;
        opt[,j] = discopt//j(n+1-j,1,0);
   
	end;

	opt = opt[nrow(opt):1,]; 
	a = opt[n+1,1];


  print 'The price of the European call option at time t_0 is 'a[label = none];
end;
  ** Option is a american put;


if (flag = 0) & (type = 0) then do;  
 
    opt[,n+1] = (-s[,n+1]+k)#((-s[,n+1]+k)>0) ;  * Determine option values from prices;

    do j = n to 1 by -1;
 
        * Probable option values discounted back one time step;
        discopt = ((1-p)*opt[1:j,j+1]+p*opt[2:j+1,j+1])*exp(-b*dt);
        * Option value is max of X - current price or discopt;
        opt[,j] = ((-s[1:j,j]+k)#((-s[1:j,j]+k)>=discopt)+
			(discopt)#((-s[1:j,j]+k)<discopt))//j(n+1-j,1,0);;
    end;

		opt = opt[nrow(opt):1,]; 
	a = opt[n+1,1];
  print 'The price of the American put option at time t_0 is 'a[label=none];

end;
  ** Option is a european put;


if (flag = 0) & (type = 1) then do;                       
    opt[,n+1] = (-s[,n+1]+k)#((-s[,n+1]+k)>0);  * Determine option values from prices;
    do j = n to 1 by -1;
       
        * Probable option values discounted back one time step;
        discopt = ((1-p)*opt[1:j,j+1]+p*opt[2:j+1,j+1])*exp(-b*dt);
        * Option value ;
        opt[,j] = discopt//j(n+1-j,1,0);
	end;

	opt = opt[nrow(opt):1,]; 
	a = opt[n+1,1];
  print 'The price of the European put option at time t_0 is 'a[label=none];
end;
quit;

