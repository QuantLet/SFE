
* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

Proc iml;
* main computation;
y  	=  0.1*(10:20)`; *Estimation points;
k  	= nrow(y); 
sum = j(nrow(y),1,0) ;
pi  = constant('pi');
n   = 0;

do while (n<(k+1));
	sum = sum + ( (-1)**n )*y##(2*n+1)/( fact(n)*2**n*(2*n+1) );
	n   = n+1;
end;

phi  = 0.5 + sum/sqrt(2*pi);
plot = y||phi;

create plot from plot;append from plot;
close plot;
quit;


data plot;set plot;
rename col1 = y col2 = phi ;

*Plot the approximation to normal cdf;

title Approximation to normal cdf d;

proc sgplot data  =  plot ;
series x  =  y y  =  phi / lineattrs = (color  =  blue THICKNESS  =  2) 
legendlabel = "Estimated normal cdf";

scatter x  =  y y  =  phi/ 
   markerattrs=( symbol=circlefilled color=red size=12 )
legendlabel = "Estimation Points" ;

yaxis label  =  'Cdf';
xaxis label = 'x' ;
run;
quit;

proc print data = plot;
run;
