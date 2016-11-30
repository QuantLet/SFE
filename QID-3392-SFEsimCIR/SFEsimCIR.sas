* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

* user inputs parameters;
%let n		=	100;	*Input number of obeservations;
%let beta	=	0.1;	*Input beta;
%let gamma	=	0.01;	*Input gamma;
%let m		=	1;		*Input mean;

*Main calculation;

proc iml;
n  		=  &n;
beta    =  &#946;
gamma   =  &#947;
m       =  &m;

* simulates a mean reverting square root process around m;
  delta  =  0.1;
  x      = j(n,1,0);
  index  = (1:n)`;
  x[1,1] = m; 
  x      = x||index; 

do i = 2 to nrow(x);
	x[i,1] = x[i-1,1]+beta*(m - x[i-1,1])*delta + gamma*sqrt(delta*abs(x[i-1,1]))*rannor(0);
end;

create x from x; append from x;
close x;

quit;

*Plot the graph of CIR process;

data x;set x;
rename col1 = x 
	   col2 = i;
title 'Simulated CIR process';

proc sgplot data = x;
series x         = i y = x/lineattrs = (color = blue THICKNESS = 2);
yaxis label      = 'Values of process';
run;
quit;