* -------------------------------------------------------------------------
* Book:        SFE3
* -------------------------------------------------------------------------
* Quantlet:    SFEoptman
* -------------------------------------------------------------------------
* Description: SFEoptman plots the performances of an insured and of
*              a non-insured portfolio as a function of the stock 
*              price.
* -------------------------------------------------------------------------
* Usage:       -
* -------------------------------------------------------------------------
* Inputs:      Capital - Initial Capital
*              Floor - Minimum Insured Portfolio Value
*              T - Time Horizon in Years
*              i - Interest Rate
*              v - Stock Volatility Sigma
*              d - Continuous Dividend
* -------------------------------------------------------------------------
* Output:      The values of the insured and of the non-insured portfolio 
*              as a functions of the stock price are plotted.
* ---------------------------------------------------------------------
* Keywords:    Portfolio, Black-Scholes
* --------------------------------------------------------------------------
* Example:     An example is produced for the values: capital = 100000,
*              floor = 95000, T = 2, i = 0.1, v = 0.3, d = 0.02.
* -------------------------------------------------------------------------
* Author:      Daniel Traian Pele
* -------------------------------------------------------------------------;
goptions reset = all;


proc iml;

*Please input Capital, Floor, Horizon (years) ;

Capital	 = 		100000;
Floor	 = 		95000;
Horizon  =		 2;

*Please input Interest rate - i , Stock volatility - v, Continuous dividend - d  ;

i  = 0.1;
v  = 0.3;
d  = 0.02;
b  =  i - d;
S  =  100;
start  =  S/2;
stop   =  2*S;
numpassi  =  1000;
step  =  (stop - start)/(numpassi - 1);
Ks = j(numpassi,1,0);

do k  = 1 to numpassi;
Ks[k] = start+step*(k-1);
end;
y  = ((log(S/Ks) + (b - (v**2)/2)*Horizon)/(sqrt(Horizon)*v));
P1 = exp(-i*Horizon)#Ks#(cdf('Normal',-y));
P  =  P1-exp(-(i-b)*Horizon)*S#cdf('Normal',-y-sqrt(Horizon)*v,0,1);
phi  =  exp(-d*Horizon)*S + P - Ks*(capital/floor);
if (min(phi)>0 | max(phi)<0)
   then print ('Extreme value configuration');

tmp  = (phi||Ks);
tmp1 = j(countn(loc(tmp[,1]<0)),2,0);
tmp1 = tmp[loc(tmp[,1]<0),];
infi = tmp1[1,];
tmp2 = j(countn(loc(tmp[,1]> = 0,2,0);
supi = tmp[nrow(tmp),];

aa = j(2,2,0);
aa[1,1] = 1;
aa[2,1] = 1;
aa[1,2] = supi[1,1];
aa[2,2] = infi[1,1];
cc = j(2,1,0);
cc[1,1] = supi[1,2];
cc[2,1] = infi[1,2];
ab = j(2,1,0);
ab = inv(aa)*cc;

K  = ab[1,1];
y  =  (log(S/K) + (b - v/2)*Horizon)/(sqrt(Horizon*v));
P  =  exp(-i*Horizon)*K*cdf('Normal',-y)-exp(-(i-b)*Horizon)*S*cdf('Normal',-y-sqrt(Horizon*v));
Shares  =  Floor/K*exp(-d*Horizon);
Puts    =  Shares*exp(d*Horizon);
sg = j(8,1,0);
do k = 1 to 8;
sg[k,1] = 70+(k-1)*10;
end;
unvPort  =  (capital/S)*Sg*exp(d*Horizon);
verPort  =  Shares*Sg*exp(d*Horizon);
do k = 1 to nrow(verPort);
if verPort[k]<Floor then verPort[k] = Floor;
end;

output = sg||unvPort||verPort;
create output from output;append from output;

quit;

* The dataset output contains data regarding prices and value of insured and non-insured portfolio;

data output;set output;
rename col1 = Stock_Price;
rename col2 = Value_non_insured_portfolio;
rename col3 = Value_insured_portfolio;
run;

*The values of the insured and of the non-insured portfolio 
as a functions of the stock price are plotted;

axis1 label  = none;
legend label = none value = (h = 2 font = swiss   'Value of insured portfolio' 'Value of non-insured portfolio' );
symbol1 i = line line = 2 interpol = join c = blue w = 2;
symbol2 i = line interpol = join c = red w = 2;
proc gplot data = output;
plot 
Value_insured_portfolio*Stock_Price
Value_non_insured_portfolio*Stock_Price/ vaxis = axis1 overlay legend = legend1;
run;
quit;


