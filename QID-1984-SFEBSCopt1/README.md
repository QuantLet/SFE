
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="887" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEBSCopt1** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEBSCopt1

Published in : Statistics of Financial Markets

Description : 'Computes the Black-Scholes price of a European call option using different
approximations of the normal distribution. Optionally, option parameters may be given interactively
as user input.'

Keywords : 'asset, black-scholes, call, european-option, financial, option, option-price, normal
approximation, approximation, normal-distribution, option'

See also : SFEBSCopt2, SFENormalApprox1, SFENormalApprox2, SFENormalApprox3, SFENormalApprox4

Author : Felix Jung

Author[Matlab] : Christoph Schult

Author[SAS] : Daniel T. Pele

Submitted : Wed, April 02 2014 by Felix Jung

Submitted[Maltab] : Tue, May 17 2016 by Christoph Schult

Submitted[SAS] : Wed, July 02 2014 by Philipp Gschoepf

Example : 'For [spot price, strike price, interest rate]= [230, 210,0.04545], [cost of carry b,
volatility sig, tau]= [0.04545, 0.25, 0.5], the price of the European call option -[a b c d] is
given [30.74261498752455, 30.74158453943994, 30.74351803282866, 30.74157465178894].'

```


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

ReadConsoleInput = function(prompt.message, bounds) {
    input = NA
    while (!is.numeric(input)) {
        input = as.numeric(sub(",", ".", readline(prompt = prompt.message)))
        if (!missing(bounds)) {
            if (length(bounds) > 1) {
                if (input < bounds[1] | input > bounds[2]) {
                  input = NA
                  cat("Error: value must lie between", bounds[1], "and", bounds[2], 
                    "n")
                }
            } else {
                if (input < bounds[1]) {
                  input = NA
                  cat("Error: value must lie at or above", bounds[1], "n")
                }
            }
        }
    }
    return(input)
}

# parameter settings
K   = 210
S   = 230
r   = 0.04545
b   = 0.04545
tau = 0.5
sig = 0.25

# Check whether user wants to use defaults
use.defaults = TRUE
cat("The default option parameters are:n")
cat("S =", S, "n")
cat("K =", K, "n")
cat("r =", r, "n")
cat("b =", b, "n")
cat("tau =", tau, "n")
cat("sig =", sig, "n")

while (TRUE) {
    user.input = readline("Would you like to use these default values (y/n)? ")
    if (!(user.input %in% c("y", "n"))) {
        cat("Invalid input: please use y or n to answer the question.n")
    } else {
        if (user.input == "y") {
            use.defaults = TRUE
        } else {
            use.defaults = FALSE
        }
        break
    }
}

if (use.defaults == FALSE) {
    S   = ReadConsoleInput("Please enter a stock price S: ", bounds = c(0))
    K   = ReadConsoleInput("Please enter a strike price K: ", bounds = c(0))
    r   = ReadConsoleInput("Please enter the risk free rate r: ", bounds = c(0))
    b   = ReadConsoleInput("Please enter the cost of carry b: ", bounds = c(-1, 1))
    sig = ReadConsoleInput("Please enter the stock price volatility sigma: ", bounds = c(0))
    tau = ReadConsoleInput("Please enter the time to maturity tau: ", bounds = c(0))
}

set.seed(0)

# Compute call price from approximation a
y  = (log(S/K) + (b - (sig^2)/2) * tau)/(sig * sqrt(tau))
ba = 0.332672527
t1 = 1/(1 + ba * y)
t2 = 1/(1 + ba * (y + sig * sqrt(tau)))
a1 = 0.17401209
a2 = -0.04793922
a3 = 0.373927817
norma1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3)) * exp(-y * y/2)
norma2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3)) * exp(-(y + sig * sqrt(tau))^2/2)
call.price.a = exp(-(r - b) * tau) * S * norma2 - exp(-r * tau) * K * norma1

# Compute call price from approximation b
bb = 0.231641888
t1 = 1/(1 + bb * y)
t2 = 1/(1 + bb * (y + sig * sqrt(tau)))
a1 = 0.127414796
a2 = -0.142248368
a3 = 0.71070687
a4 = -0.726576013
a5 = 0.530702714
normb1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3) + a4 * (t1^4) + a5 * (t1^5)) * 
    exp(-y^2/2)
normb2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3) + a4 * (t2^4) + a5 * (t2^5)) * 
    exp(-(y + sig * sqrt(tau))^2/2)
call.price.b = exp(-(r - b) * tau) * S * normb2 - exp(-r * tau) * K * normb1

# Compute call price from approximation c
a1 = 0.09979268
a2 = 0.04432014
a3 = 0.0096992
a4 = -9.862e-05
a5 = 0.00058155
t1 = abs(y)
t2 = abs(y + sig * sqrt(tau))
normc1 = 1/2 - 1/(2 * (1 + a1 * t1 + a2 * t1^2 + a3 * t1^3 + a4 * t1^4 + a5 * t1^5)^8)

if (y < 0) {
    normc1 = 0.5 - normc1
} else {
    normc1 = 0.5 + normc1
}

normc2 = 1/2 - 1/(2 * (1 + a1 * t2 + a2 * t2^2 + a3 * t2^3 + a4 * t2^4 + a5 * t2^5)^8)

if (y + sig * sqrt(tau) < 0) {
    normc2 = 0.5 - normc2
} else {
    normc2 = 0.5 + normc2
}

call.price.c = exp(-(r - b) * tau) * S * normc2 - exp(-r * tau) * K * normc1

# Compute call price from approximation d (Taylor expansion)
n    = 0
sum1 = 0
sum2 = 0

while (n <= 12) {
    sum1 = sum1 + (-1)^n * y^(2 * n + 1)/(factorial(n) * 2^n * (2 * n + 1))
    sum2 = sum2 + (-1)^n * (y + sig * sqrt(tau))^(2 * n + 1)/(factorial(n) * 2^n * 
        (2 * n + 1))
    n    = n + 1
}

normd1 = 0.5 + sum1/sqrt(2 * pi)
normd2 = 0.5 + sum2/sqrt(2 * pi)
call.price.d = exp(-(r - b) * tau) * S * normd2 - exp(-r * tau) * K * normd1

# Return option prices
cat("Price of European Call norm-a: ")
print(call.price.a)

cat("Price of European Call norm-b: ")
print(call.price.b)

cat("Price of European Call norm-c: ")
print(call.price.c)

cat("Price of European Call norm-d: ")
print(call.price.d)

```

### MATLAB Code:
```matlab
clear all
close all
clc

format long
% user inputs parameters
disp('Please input spot S, strike K, and interest r as: [230, 210, 0.04545]') ;
disp(' ') ;
para = input('[spot price, strike price, interest rate]=');
while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [230, 210, 0.04545] or [230 210 0.04545]');
    para = input('[spot price, strike price, interest rate] = ');
end

% spot price
S = para(1);

% strike price
K = para(2);

% interest rate
r = para(3);

disp(' ') ;
disp('Please input cost of carry b, and volatility sig, remaining time tau as: [0.04545, 0.25, 0.5]') ;
disp(' ') ;

para2 = input('[cost of carry b, volatility sig, tau]=') ;
while length(para2) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [0.04545, 0.25, 0.5] or [0.04545 0.25 0.5]');
    para2 = input('[cost of carry b, volatility sig, tau] = ');
end

% cost of carry, volatility, remaining time
b   = para2(1);
sig = para2(2);
tau = para2(3);

% main computation
y   = (log(S / K) + (b - (sig^2) / 2) * tau ) / (sig * sqrt(tau));

% norm a
ba     = 0.332672527;
t1     = 1 / (1 + ba * y);
t2     = 1 / (1 + ba *(y + sig * sqrt(tau)));
a1     = 0.17401209;
a2     = -0.04793922;
a3     = 0.373927817;
norma1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3)) * exp(-y .* y / 2);
norma2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3)) * exp(-(y + sig * sqrt(tau))^2 / 2);
ca     = exp(-(r - b) * tau) * S * norma2 - exp(-r * tau) * K * norma1;

% norm b
bb     = 0.231641888;
t1     = 1 / (1 + bb * y);
t2     = 1 / (1 + bb * (y + sig * sqrt(tau)));
a1     = 0.127414796;
a2     = -0.142248368;
a3     = 0.71070687;
a4     = -0.726576013;
a5     = 0.530702714;
normb1 = 1 - (a1 * t1 + a2 * (t1^2) + a3 * (t1^3) + a4 * (t1^4) + a5 * (t1^5)) * exp(-y^2 / 2);
normb2 = 1 - (a1 * t2 + a2 * (t2^2) + a3 * (t2^3) + a4*(t2^4) + a5*(t2^5)) * exp(-(y + sig * sqrt(tau))^2 / 2);
cb     = exp(-(r - b) * tau) * S * normb2 - exp(-r * tau) * K * normb1;

% norm c
a1     = 0.09979268; 
a2     = 0.04432014; 
a3     = 0.00969920; 
a4     = -0.00009862; 
a5     = 0.00058155;
t1     = abs(y);
t2     = abs(y + sig * sqrt(tau));

normc1 = 1.0 / 2.0 - 1.0 / ( 2.0 * ( (1.0 + a1 * t1 + a2 * t1^2 + a3 * t1^3 + a4 * t1^4 + a5 * t1^5)^8 ));
if y < 0
    normc1 = 0.5 - normc1;
else
    normc1 = 0.5 + normc1;	
end

normc2 = 0.5 - 1.0 / (2.0 * ( (1.0 + a1 * t2 + a2 * t2^2 + a3 * t2^3 + a4 * t2^4 + a5 * t2^5)^8 ))
if (y + sig * sqrt(tau)) < 0
    normc2 = 0.5 - normc2;
else
    normc2 = 0.5 + normc2;	
end
cc = exp(-(r - b) * tau) * S * normc2 - exp(-r * tau) * K * normc1;

% norm d
n    = 0;
sum1 = 0;
sum2 = 0;
while n <= 12
    sum1 = sum1 + ((-1)^n) * y^(2 * n + 1)/(factorial(n) * 2^n * (2 * n + 1));
	  sum2 = sum2 + ((-1)^n) * (y + sig * sqrt(tau))^(2 * n + 1) / (factorial(n) * 2^n * (2 * n + 1));
	  n    = n + 1;
end

normd1 = 0.5 + sum1 / sqrt(2 * pi);
normd2 = 0.5 + sum2 / sqrt(2 * pi);

cd = exp(-(r - b) * tau) * S * normd2 - exp(-r * tau) * K * normd1;


% output
disp(' ');
disp('Price of European Call norm-a =')
disp(ca)
disp(' ');
disp('Price of European Call norm-b =')
disp(cb)
disp(' ');
disp('Price of European Call norm-c =')
disp(cc)
disp(' ');
disp('Price of European Call norm-d =')
disp(cd)

```

### SAS Code:
```sas

* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

************************************************************************
....................PLEASE INPUT THE PARAMETERS.........................
***********************************************************************;

%let  S		=	230 	;	*Input spot price;
%let  K		= 	210 	;   *Input strike price;
%let  r		=	0.04545 ; 	*Input interest rate; 
%let  b		=	0.04545	;	*Input cost of carry;
%let  sig	=	0.25	;	*Input volatility;
%let  tau	=	0.5		;   *Input maturity;

* main computation;

proc iml;

S = &S; K = &K; r = &r; b = &b; sig = &sig; tau = &#964; pi = constant('pi');

y = ( log(S/K) + (b-(sig**2)/2)*tau )/( sig*sqrt(tau) );

*Normal approximation a;

ba = 0.332672527;
t1 = 1/(1 + ba * y);
t2 = 1/(1 + ba *(y+sig*sqrt(tau)));
a1= 0.17401209;
a2= -0.04793922;
a3= 0.373927817;
norma1 = 1-(a1*t1+a2*(t1**2)+a3*(t1**3))*exp(-y*y/2);
norma2 = 1-(a1*t2+a2*(t2**2)+a3*(t2**3))*exp(-(y+sig*sqrt(tau))**2/2);
ca = exp(-(r-b)*tau)*S*norma2 - exp(-r*tau)*K*norma1;

*Normal approximation b;

bb = 0.231641888;
t1 = 1/(1 + bb * y);
t2 = 1/(1 + bb *(y+sig*sqrt(tau)));
a1 = 0.127414796;
a2 = -0.142248368;
a3 = 0.71070687;
a4 = -0.726576013;
a5 = 0.530702714;
normb1 = 1-(a1*t1+a2*(t1**2)+a3*(t1**3)+a4*(t1**4)+a5*(t1**5))*exp(-y**2/2);
normb2 = 1-(a1*t2+a2*(t2**2)+a3*(t2**3)+a4*(t2**4)+a5*(t2**5))*exp(-(y+sig*sqrt(tau))**2/2);
cb = exp(-(r-b)*tau)*S*normb2 - exp(-r*tau)*K*normb1;

*Normal approximation c;

a1= 0.09979268; 
a2= 0.04432014; 
a3= 0.00969920; 
a4=-0.00009862; 
a5= 0.00058155;
t1 = abs(y);
t2 = abs(y+sig*sqrt(tau));
normc1 = 1.0/2.0 - 1.0/( 2.0 * ( (1.0+a1*t1+a2*t1**2+a3*t1**3+a4*t1**4+a5*t1**5)**8 ) );
if y<0 then
    normc1 = 0.5 -normc1;
    else
	normc1 = 0.5 +normc1;	
normc2 = 1.0/2.0 - 1.0/( 2.0 * ( (1.0+a1*t2+a2*t2**2+a3*t2**3+a4*t2**4+a5*t2**5)**8 ) );

if (y+sig*sqrt(tau))<0
	then normc2 = 0.5 - normc2;
    else
	normc2 = 0.5 + normc2;	

cc = exp(-(r-b)*tau)*S*normc2 - exp(-r*tau)*K*normc1;

*Normal approximation d;

n = 0;
sum1 = 0;
sum2 = 0;
do while(n<=12);
	sum1 = sum1 + ( (-1)**n )*y**(2*n+1)/( fact(n)*2**n*(2*n+1) );
	sum2 = sum2 + ( (-1)**n )*(y+sig*sqrt(tau))**(2*n+1)/( fact(n)*2**n*(2*n+1) );
	n = n+1;
end;

normd1 = 0.5 + sum1/sqrt(2*pi);
normd2 = 0.5 + sum2/sqrt(2*pi);
cd = exp(-(r-b)*tau)*S*normd2 - exp(-r*tau)*K*normd1;

* Output;

print 'Price of European Call norm-a =' ca[label = none];

print 'Price of European Call norm-b =' cb[label = none];

print 'Price of European Call norm-c =' cc[label = none];

print ('Price of European Call norm-d =') cd[label = none];

quit; 

```
