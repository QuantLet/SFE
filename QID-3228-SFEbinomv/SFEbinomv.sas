
goptions reset=all;
*************************************************
**** enter parameters as                    *****
**** number of steps:            n = 100    *****
**** number of path:             k = 1000    *****
**** probability of up movement: p = 0.5    *****
*************************************************;

%let n 	= 100;		*Input number of steps;
%let k 	= 1000;	*Input number of path;
%let p 	= 0.5;		*Input probability of up movement;

* main computation;

proc iml;
 
n =  &n ; 
k =  &k  ;		
p =  &p ; 

* main simulation;

call randseed(123);
trend  =  n*(2*p - 1);
std  =  sqrt(4*n*p*(1-p));
z = j(n,k,0);  
call randgen(z, "Uniform");	*Create a matrix of uniform random variables on [0,1];
z =  ((floor(-z+p))+0.5)*2 ;  
 rw = j(n,k,0);
do i = 2 to n;
rw[i,] = rw[i-1,]+z[i,];
end;
x = rw[nrow(rw),]`;
norm = j(k,1,0);

call randgen(norm, "Normal");	*Create a matrix of normal random variables;
norm = std*norm+trend;
x = x||norm;			  		*x contains the binomial random walk;

create data from x;append from x;
close data;

quit;
data data;set data;
rename col1 = x col2 = norm;


proc kde data = data;*Compute kernel density estimate;
univar x/ out = density_x  ;
 
run;
quit;

proc kde data = data;*Compute kernel density estimate;
univar norm/ out = density_y  ;
 
run;
quit;

data density_x;set density_x;
rename value = x density = f_x;
data density_y;set density_y;
rename value = y density = f_y;

data kde(keep = x f_x y f_y);merge density_x density_y;
run;

*Plot the density of generated binomial processes with the normal density;

title 'Generated binomial processes';
legend label = none value = ('Normal' 'Binomial' );
axis1 label = none;
symbol1 i = line line = 2 interpol = join c = blue w = 2;
symbol2 i = line interpol = join c = red w = 2;

proc gplot data = kde;
plot f_y*y f_x*x /overlay vaxis = axis1 legend = legend;

run;
quit;
