* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEgarchest
* ---------------------------------------------------------------------
* Description:  SFEgarchest reads the date, DAX index values, stock
*               prices of 20 largest companies at Frankfurt Stock
*               Exchange (FSE), FTSE 100 index values and stock prices
*               of 20 largest companies at London Stock Exchange (LSE)
*               and estimates various GARCH models for the DAX and
*               FTSE 100 daily return procesess from 1998 to 2007
* ---------------------------------------------------------------------
* Usage:        -
* ---------------------------------------------------------------------
* Keywords:     GARCH, time series, volatility
* ---------------------------------------------------------------------
* Inputs:       none
* ---------------------------------------------------------------------
* Output:       The estimated coefficients of the models
*               Goodness of fit statistics
* ---------------------------------------------------------------------
* Example:      
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------;


* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

*Input data from the text file dax.dat;
*Please make sure to give the right path of the file as below!;

proc import datafile="C:UsersAdministratorDownloadsFSE_LSE.dat"
dbms=tab out=date replace; 
* Change with your own path, like "Root:Folder1Folder2FSE_LSE.dat";
getnames=no;
run;

* The macro estimate_garch has two parameters:
 - dataset - the active dataset containing log-returns
 - n - the number of variables to be modeled, where n goes from 1 to maximum 
 	number of variables in the dataset;
%macro estimate_garch(dataset,n);
   %let dsid = %sysfunc(open(&dataset));
   %if &dsid %then %do;
      %let m = %sysfunc(attrn(&dsid,NVARS));
      %let rc = %sysfunc(close(&dsid));
	%end; 

%if &n>&m %then %put('Too many variables! Please try again!');
%else %do;

%do i = 2 %to &n;
	data &dataset;set &dataset;
	r&i = log(var&i)-lag(log(var&i)); *Compute log-returns;
	run;

	*Estimate GARCH models;
proc autoreg data=&dataset outest=garch ;
  ar_1_garch_1_1   : model r&i = /   nlag=1 garch=(p=1,q=1); *AR(1)-GARCH(1,1);
  ar_1_egarch_1_1  : model r&i = /   nlag=1 garch=(p=1,q=1, type = egarch);*AR(1)-EGARCH(1,1);
  ar_1_tgarch_1_1  : model r&i = /   nlag=1 garch=(p=1,q=1, type = tgarch);*AR(1)-TGARCH(1,1);

run;

data garch(drop=r&i _TYPE_ _STATUS_ _METHOD_ _NAME_ );set garch;
run;

proc append base=results data=garch force;
run;
quit;

%end;

*Print the matrix of the estimated coefficients;
title "GARCH estimates";

proc print data=results;
run;
%end;

* See the output for more detailed results;
%mend;

%estimate_garch(date,3);
