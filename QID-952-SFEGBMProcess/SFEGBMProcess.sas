
goptions reset = all;

**********************************************************************
*Please input method type as: 1 - Direct Integration, 2 - Euler Scheme.
**********************************************************************;

%let method	  = 	2;	*By default the method of Direct Integration. Put 2 for Euler Scheme;	


**********************************************************************
*Please input parameters! 
**********************************************************************;

%let x0		  =   0.84; *Input intial value;
%let mu  	  =   0.02; *Input mean;
%let sigma 	  =   0.01; *Input sigma;
%let obs	  =   1000; *Input number of observations;

*Main computation;

proc iml;
n 		= 1;
x0 		= &x0;
mu 		= &#956;
sigma 	= &#963;
delta 	= 1/&obs;

t = (0:floor(n/delta))`;
x = j(nrow(t),1,0);
no = j(nrow(t)-1,1,0);

call randgen(no, "Normal");  *Generate random normal numbers;
no = no*sqrt(delta);


*Compute Geometric Brownian Motion by Direct Integration;
if &method = 1 then do;
    x  = ( x0||(x0 * exp(cusum((mu - 0.5*sigma**2)*delta + sigma*no )))`)`;
end;
*Compute Geometric Brownian Motion by Euler Scheme;
if &method = 2 then do;
x[1,1] = x0;
do i = 2 to nrow(t);
    x[i,1]  =  x[i-1,1] + mu*x[i-1,1]*delta + sigma*x[i-1,1]*no[i-1,1];
end;
end;

x = x||t;
*create dataset GBM;

create gbm from x; append from x;
close gbm;

if &method=1 then  vmethod='Direct Integration Method';
else vmethod='Euler Scheme Method';

call symput ('vmethod',vmethod);
quit;


*Plot the graph of Geometric Brownian Motion;

data gbm;set gbm;
rename col1  =  GBM 
	   col2  =  t;

title Geometric Brownian Motion using &vmethod;

proc sgplot data  =  gbm;
series x  =  t y  =  gbm/lineattrs  =  (color  =  blue THICKNESS  =  1.5);
yaxis label  =  'Values of process';
run;
quit;
