* -------------------------------------------------------------------------
* Book:         SFE3
* -------------------------------------------------------------------------
* Quantlet:     SFEWienerProcess
* -------------------------------------------------------------------------
* Description:  Simulates the limiting procedure from a binomial
*               process to the Wiener process.
* -------------------------------------------------------------------------
* Usage:        -
* -------------------------------------------------------------------------

* Keywords:     Wiener process, stochastic process, simulation
*--------------------------------------------------------------------------
* Inputs:       dt - Delta t
*               c - Constant c
*               k - Number of Trajectories
* -------------------------------------------------------------------------
* Output:       Plot of Wiener process
* -------------------------------------------------------------------------
* Example:      Simulated Wiener processes with parameters dt=0.25, c=1 and
*				k=3. 
* -------------------------------------------------------------------------
* Notes         Plug in delta t:  1, 0.5, 0.25, ... to see how does
*               the limiting process work. You can change the constant
*               c to get a process with variance c^2 * t.
* -------------------------------------------------------------------------
* Author:       Daniel Traian Pele
* -------------------------------------------------------------------------;
goptions reset=all;

%let dt = 0.01;	*input Delta t;
%let c  = 1; 		*input Constant c;
%let k  = 3;		*input Trajectories k;

*Main calculation;


proc iml;
dt = &dt;
c  = &c;
k  = &k;
l  = 100;
n  = floor(l/dt);
t  = j(n+1,1,0);
i  = (1:n+1)`;
t  = 2*(i-1)*dt;	

call randseed(0); 
z = j(n,k,0);  
call randgen(z, "Uniform");	*Create a matrix of uniform random variables on [0,1];

z  = 2*(z>0.5)-1;
z  = z*c*sqrt(dt);  			*to get finite and non-zero variance;
zz = j(k,1,0);
w  = j(n,k,0);
do i = 2 to n;
w[i,] = w[i-1,]+z[i,];
end;
x = t||(zz||w`)`;			*The matrix x contains the pahts of Wiener process;
create x from x; append from x;
close x;
quit;

data x;set x;
rename col1 = t col2 = w1 col3 = w2 col4 = w3;

* Draw the graph of the Wiener process;

title 'Wiener process with delta = '&dt;
legend label = none value = (h = 1.5 'W1' 'W2' 'W3');
axis1 label  = ('Values of process');
symbol1 i    = line interpol = join c = blue w = 2 ;
symbol2 i    = line interpol = join c = red w = 2;
symbol3 i    = line interpol = join c = green w = 2 ;

proc gplot data = x;
plot w1*t w2*t w3*t /overlay
vaxis = axis1 legend = legend;
run;
quit;