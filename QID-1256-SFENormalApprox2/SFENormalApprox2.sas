goptions reset=all;

Proc iml;
* main computation;
y  =  0.1*(10:20)`;
b = 0.231641888;
a1= 0.127414796;
a2=-0.142248368;
a3= 0.71070687;
a4=-0.726576013;
a5= 0.530702714;
t  =  1/(1 + b*y);
phi = 1 - (a1*t+a2*t##2+a3*t##3+a4*t##4+a5*t##5)#exp(-y#y/2);
plot = y||phi;
create plot from plot;append from plot;
close plot;
quit;


data plot;set plot;
rename col1 = y col2 = phi ;

*Plot the approximation to normal cdf;

title Approximation to normal cdf b;

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