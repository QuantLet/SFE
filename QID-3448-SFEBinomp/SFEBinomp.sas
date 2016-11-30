goptions reset = all;

%let p 	 = 0.6; * Input the probability of positive step being realised;
%let k 	 = 3;  * Input the number of trajectories;
%let n   = 100;* Input the number of observations;

proc iml;

n =  &n ; 
k =  &k  ;		
p =  &p ; 

* main simulation;

call streaminit(123);
t 	 =  (1:n)`;
trend  =  t*(2*p - 1);
std  =  sqrt(4*t*p*(1-p));
s_1  =  trend + 2*std; 		* upper confidence band;
s_2  =  trend - 2*std;		* lower confidence band;
z = j(n,k,0);  
call randgen(z, "Uniform");	*Create a matrix of uniform random variables on [0,1];
z = p-1+z;                 	*Create a matrix of uniform random variables on [p-1,p];

z  = (z > 0)*1;			

z  = z*2 - 1;					* z = 1 with p, z = -1 with 1-p; 
rw = j(n,k,0);				*rw is the ordinary random walk;
do i = 2 to n;
	rw[i,] = rw[i-1,]+z[i,];
end;
rw = t||s_1||s_2||rw||trend;
create rw from rw; append from rw; close rw;
quit;

*plot of the binomial processes;

data rw;set rw;
rename col1 = t col2 = lower col3 = upper col4 = rw1 col5 = rw2 col6 = rw3 col7 = trend;
run;
title 'Binomial processes with p = '&p;
legend label = none value = ('RW1' 'RW2' 'RW3' 'Lower' 'Upper' 'Trend' );
axis1 label = none;
symbol1 i = line interpol = join c = blue w = 2;
symbol2 i = line interpol = join c = red w = 2;
symbol3 i = line interpol = join c = green w = 2;
symbol4 i = line line = 2 interpol = join c = black w = 2;
symbol5 i = line line = 2 interpol = join c = black w = 2;
symbol6 i = line interpol = join c = black w = 2;


proc gplot data = rw;
plot rw1*t rw2*t rw3*t lower*t upper*t trend*t/overlay
vaxis = axis1 legend = legend;
run;
quit;