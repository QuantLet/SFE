goptions reset=all;

*Input parameters;
%let var2 		= 2.5  	;  * The initial value of variance;
%let n 			= 1000 	;  * The number of observations;
%let arch0 		= 0.5 	;  * The intercept from the variance equation;
%let alpha 		= 0.5 	;  * The parameter of eps(t-1);


*Specify ARCH settings and simulate ARCH(1) process;



   data arch;
      eps0   = &var2;
      do t= -500  to &n ;
              /* ARCH(1) with normally distributed residuals */
         sigma = &arch0 + &alpha*eps0**2 ;
         eps = sqrt(sigma) * rannor(0) ;
         y =  eps;
         eps0 = eps;
         if t > 0 then output;
      end;
   run;

proc iml;
	use arch;
	read all var{y} into y;
	n = &n;
	k = 16;
	theta = (0:15)`*0.05+0.1;
	l1 = j(k,1,1);

	*Determine the log-likelihood values;
	i = 1;
	do while (i<=k);
	
	 a = theta[i]; 
	 omega = 1-a;
	 l = 0;
	 t = 2;
			do while (t<=n);
			 
			   l=l-0.5*log(omega+a*y[t-1,1]**2)-0.5*y[t,1]**2/(omega+a*y[t-1,1]**2);*exact Log likelihood ;
			   t=t+1;
			end;
	l1[i,1] = l;
	i = i+1;
	end;

	plot = theta||l1;

	create plot from plot; append from plot;
	close plot;

	quit;


*Plot the log-likelihood;
data plot; set plot;
rename col1 = alpha col2 = llike ;

proc sort data = plot; by descending llike;
data _null_;set plot;
if _n_ = 1;
call symput('max',alpha);
run;

proc sort data = plot;by alpha;
label llike = "Log-likelihood";


title Likelihood function of an ARCH(1) process with alpha=&alpha;

proc sgplot data   =   plot ;
series x   =   alpha y   =   llike/ lineattrs   =   (color   =   blue THICKNESS   =   3 ) ;
yaxis label   =  'Log-Likelihood';
xaxis label   =  'Alpha';
refline &max / axis=x lineattrs = (color = red pattern=dash THICKNESS   =   4);
run;
quit;