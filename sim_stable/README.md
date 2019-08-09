[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **sim_stable** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: sim_stable

Published in: Statistics of Financial Markets

Description: ‚Simulates an alpha-stable distribution under parameterisations S1 using the algorithm of Weron (1996)‘

Keywords: ‚Weron, simulation, stable, stable distribution, time-series‘

See also: fractal_hurst, mc_culloch, stab_reg_kw, stable

Author: Daniel T. Pele

Submitted: Wed, November 30, 2016 by Lusine Nazaretyan

Input:
-delta: location parameter
-alpha: stability index
-n: number of observations
-beta: skewness parameter
-gamma: scale parameter

Output:
-data: SAS dataset containing the simulated variable y

Example: ‚An example is generated for a simulated stable distribution S(alpha=1.5, beta=0, delta=0, gamma=1)‘

```

### SAS Code
```sas

* ---------------------------------------------------------------------
* Book:         
* ---------------------------------------------------------------------
* Quantlet:     sim_stable
* ---------------------------------------------------------------------
* Description:  sim_stable simulates an alpha-stable 
*               distribution under parameterisations S1 using the algorithm
*				of Weron (1996).
* ---------------------------------------------------------------------
* Usage:        SAS 9.2, SAS 9.3
* ---------------------------------------------------------------------
* See also:     Weron R. (1996):Correction to: On the Chambers-Mallows-
*				Stuck method for simulating skewed stable random variables
*				 — Res. Rep., Wroclaw University of Technology,Poland.
*----------------------------------------------------------------------
* Keywords:     stable distribution
*----------------------------------------------------------------------
* Inputs:       alpha - stability index
*				beta - skewness parameter
*				gamma - scale parameter
*				delta - location parameter
*				n - number of observations.
* ---------------------------------------------------------------------
* Output:       date- SAS dataset containing the simulated variable y
* ---------------------------------------------------------------------
* Example:      An example is generated for a simulated stable distribution
*				S(alpha=1.5,beta=0,delta=0,gamma=1).
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele    
* ---------------------------------------------------------------------;

* The macro %sim_stable simulates a random variable y under parameterisation S1;

%macro sim_stable(alpha=,beta=,delta=,gamma=,n=);
*If alfa<>1, then use the following code;

%macro s_alpha;
pi=constant('pi');
u=pi*ranuni(0)-pi/2;
ex=ranexp(1);
s_a_b=(1+(&beta**2)*(tan(pi*&alpha/2))**2)**(1/(2*&alpha));
b_a_b=atan(&beta*tan(pi*&alpha/2))/&#945;
x=s_a_b*(sin(&alpha*(u+b_a_b)))/(cos(u)**(1/&alpha))*(cos(u-&alpha*(u+b_a_b))/ex)
**((1-&alpha)/&alpha);
y=&gamma*x+&#948;
%mend;

*If alfa=1, then use the following code;

%macro s_alpha_1;
pi=constant('pi');
u=pi*ranuni(0)-pi/2;
ex=ranexp(1);
x=(2/pi)*(pi/2+&beta*u)*tan(u)-&beta*log(pi/2*ex*cos(u)/(pi/2+&beta*u));
y=&gamma*x+2/pi*&beta*&gamma*log(&gamma)+&#948;
%mend;
%if &alpha=1 %then %do;
	data date(keep=y);            
	%do i=1 %to &n;
	%s_alpha_1;
		output;
	%end;

	run;
%end;
%if &alpha ne 1 %then %do;
data date(keep=y);            
	%do i=1 %to &n;
	%s_alpha;
		output;
	%end;
	run;
%end;

%mend;

*A simulated stable distribution y with the parameters 
alpha=1.5,beta=0,delta=0,gamma=1 and 100 obervations 
is created in the dataset date;
%sim_stable(alpha=1.5,beta=0,delta=0,gamma=1,n=100) ;

```

automatically created on 2018-05-28