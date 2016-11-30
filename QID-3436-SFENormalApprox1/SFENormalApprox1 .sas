* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

Proc iml;
* main computation;
y  =  0.1*(10:20)`; *Estimation points;
b  =  0.332672527;
a1 =  0.17401209;
a2 = -0.04793922;
a3 =  0.373927817;
t  =  1/(1 + b*y);
phi  =  1 - (a1*t+a2*t##2+a3*t##3)#exp(-y#y/2); *Approximation to CDF;
plot = y||phi;
create plot from plot;append from plot;
close plot;
quit;


data plot;set plot;
rename col1 = y col2 = phi ;

*Plot the approximation to normal cdf;

title Approximation to normal cdf a;

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