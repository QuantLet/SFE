goptions reset=all;

%let p = 	0.25; *probability of up movement;
%let q = 	0.25; *probability of down movement;
%let k = 	5;  * number of trajectories;
%let n = 	100;* number of observations;
%let r = 	%sysevalf(1-&p-&q);	

proc iml;

n =  &n ; 
k =  &k  ;		
p =  &p ;
q = &q; 

* main simulation;
call streaminit(123); 
	u = 1 ;* n of t increments Z_1,...,Z_t take value u;
	d = 1 ;* m of t increments Z_1,...,Z_t take value d;
	t = (1:n)`;
	trend =  t*(p*u-q*d);
	std	 =  sqrt(t*(p*(1-p)+q*(1-q)+2*p*q*u*d));
	s1 =  trend+2*std ;* upper confidence band;
	s2 =  trend-2*std ;* lower confidence band;
	z = j(n,k,0);  
	call randgen(z, "Uniform");	*Create a matrix of uniform random variables on [0,1];
	z = (-1)*(z<q) + (z>(1-p));
	rw = j(n,k,0);				*rw is the trinomial random walk;
	do i = 2 to n;
		rw[i,] = rw[i-1,]+z[i,];
	end;
rw = t||s1||s2||rw||trend;
create rw from rw; append from rw; close rw;
quit;


data rw;set rw;
rename col1 = t col2 = lower col3 = upper col4 = rw1 col5 = rw2 col6 = rw3 col7 = rw4
col8 = rw5 col9 = trend;
run;

*Plot the trinomial processes;

title 'Trinomial processes with p = '&p 'q = '&q 'r = '&r;
legend label = none value = ('RW1' 'RW2' 'RW3' 'RW4' 'RW5' 'Lower' 'Upper' 'Trend' );
axis1 label = none;
symbol1 i = line interpol = join c = blue w = 2;
symbol2 i = line interpol = join c = red w = 2;
symbol3 i = line interpol = join c = green w = 2;
symbol4 i = line interpol = join c = magenta w = 2;
symbol5 i = line interpol = join c = pink w = 2;
symbol6 i = line line = 2 interpol = join c = black w = 2;
symbol7 i = line line = 2 interpol = join c = black w = 2;
symbol8 i = line line = 1 interpol = join c = black w = 2;

proc gplot data = rw;
plot rw1*t rw2*t rw3*t rw4*t rw5*t lower*t upper*t trend*t/overlay
vaxis = axis1 legend = legend;
run;
quit;
