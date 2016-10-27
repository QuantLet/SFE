
proc iml;

* user inputs parameters;
* Please input Spot date t0, Capital V, Floor F and Expiry date Tex;

t0  =   0;
V   =   100000;
F   =   95000;
Tex =   2;

*Please input Spot stock price s0, Interest r, Volatility sig, and Dividend D as: [100, 0.1, 0.3, 0.02]
para2 = c(100, 0.1, 0.3, 0.02) ;

s0 = 100;
r = 0.1;
sig = 0.3;
d = 0.02;
tau = Tex-t0;		    * maturity tau = Tex-t0;
b = r-d;              * costs of carry;

* main computation: Newton's method;

k = 0.001;			*initial exercise price;
t = 100;				* initial difference between two ks;
pi = constant('pi');

do while (t> = 0.00001);						                * acceptable value for difference;
y = (log(s0/k)+(b-1/2*(sig**2))*tau)/(sig*sqrt(tau));      * y for BS ;
yk = -1/(sig*sqrt(tau)*k);                                * FOC of y respect to k;
cdfnyk1 = -exp(-1*y**2/2)*(yk/sqrt(2*pi));                * FOC of PI(-y) respect to k;
cdfnyk2 = -exp(-1*(y+sig*sqrt(tau))**2/2)*(yk/sqrt(2*pi));* FOC of PI(-y-sig*sqrt(tau));


pk = exp(-r*tau)*k*cdf('normal',-1*y)-exp((b-r)*tau)*s0*cdf('normal',-1*y-sig*sqrt(tau));        * BC's put option price; 
pkk = exp(-r*tau)*cdf('normal',-1*y)+exp(-1*r*tau)*k*cdfnyk1-exp((b-r)*tau)*s0*cdfnyk2;  * FOC of put price respect to k;
fk = exp(-d*tau)*s0+pk-V/F*k;                             * equation 2-23 see page 30;
fkk = pkk-V/F;                                            *FOC of equation respect to k;
k0 = k;               * old k;
k = k-fk/fkk;         *new k;
t = k-k0;             *difference; 
end;


print('The exercise price applying NEWTON method  = ') k;

print('The BS put option price  = ') pk;

quit;
