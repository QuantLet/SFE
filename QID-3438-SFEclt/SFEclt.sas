* ----------------------------------------------------------------------------
* Book:        SFE3
* ----------------------------------------------------------------------------
* Book:        SFE3
* ----------------------------------------------------------------------------
* Quantlet:    SFEclt
* ----------------------------------------------------------------------------
* Description  SFEclt illustrates the (univariate) Central Limit Theorem
*              (CLT).n*1000 sets of n-dimensional Bernoulli samples are
*              generated and used to approximate the distribution of
*              t = sqrt(n)*(mean(x)-mu)/sigma -> N(0,1). The estimated density
*              (red) of t is shown together with the standard normal (green).
* ------------------------------------------------------------------------------
* Usage:        -
* ------------------------------------------------------------------------------
* Keywords:     Central limit theorem, Binomial, Gaussian
*-------------------------------------------------------------------------------
* Inputs:        p - probability
*                   n - number of trials
*                   rep - number of samples
* ------------------------------------------------------------------------------
* Output:       Plots the CLT estimate for Bernoulli distributed random
*               variables together with the standard normal distribution.
* ------------------------------------------------------------------------------
* Example:      One example is generated with p=0.5, n=35, rep=1000.
* ------------------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ------------------------------------------------------------------------------

goptions reset  = all;
%let p          =      0.5;    *input the probability;
%let n          =      35;     *input the number of triales;
%let rep        =      1000;   *input the number of samples;

*Main computation;

proc iml;

p       = &p;
n       = &n;
rep     = &rep;
matrix  = j(n,rep,0);

call randseed(123); * set random number seed;
call randgen(matrix, "Bernoulli",p);*Create a matrix of Bernoulli random variables with parameter p and n values;

means   = matrix[:,];
mean    = mean(means);
x       = (means-p)`/sqrt(p*(1-p)/n);
create data from x;append from x;
close data;
quit;

data data;set data;
rename col1 = x;
run;

proc kde data = data;*Compute kernel density estimate;
univar x/ out = kde;
run;
quit;

data kde;set kde;
Normal = pdf('Normal',value); *Compute normal density;
run;

* Plot the two distributions;

axis1 label = none;
title 'Asymptotic Distribution';
legend label    = none value = (h = 1.5 'Normal density' 'Estimated density' );
symbol1 i       = line interpol = join c = green w = 2;
symbol2 i       = line interpol = join c = red w = 2;

proc gplot data = kde;
plot
Normal*value
Density*value/ vaxis = axis1 overlay legend = legend1;
run;
quit;