goptions reset=all;

* User inputs parameters;
*Please input lag value lag, value of alpha1 a as: 30, 0.9 ;

%let lag	= 30;			
%let a		= 0.9;

data ar;
y = 1;					* The initial value;
do t = 1 to 1000;
y = &a*y+rannor(0);		*Generate the AR(1) process with Gaussian innovations and 1000 observations;
output;
end;
run;



ods graphics on;

* Plot the ACF, PACF;
proc arima data = ar;
identify var = y  nlag=&lag outcov = acf noprint;
run;
quit;



data acf;set acf;
if lag=0 then delete;

data acf;set acf;
label var="AR(1) process";

*Plot the ACF graph;

 title Sample Autocorrelation Function (ACF) -  AR(1) process;

proc sgplot data = acf ;
needle x = lag y = corr / markers
lineattrs = (color = red THICKNESS = 4)
markerattrs = ( symbol=circlefilled 
color = blue size = 6) ;
refline 0 / transparency=0.5   ;

run;
quit;