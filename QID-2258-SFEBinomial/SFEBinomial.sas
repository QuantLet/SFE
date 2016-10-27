
goptions reset=all;
proc iml;

*Please input (Probability p, Number n);
p     = 0.5;
n     = 15;
x     = (0:n)`;
y=pdf('Binomial',x,p,n); *pdf of Binomial distribution;
z=cdf('Binomial',x,p,n); *cdf of Binomial distribution;

data=x||y||z;
create data from data;append from data;
close data;
submit;

data data;set data;
rename col1=x;
rename col2=pdf_Binomial;
rename col3=cdf_Binomial;
run;
proc gchart data=data;                                                                                                                 
   vbar x / sumvar=pdf_Binomial discrete width=10 annotate=data                                                                       
              maxis=axis1 raxis=axis2;                                                                                                  
   axis1 label=('x');                                                                                                                 
   axis2 label=(angle=90 'f(x)');                                                                                                     
   title1 'Binomial distribution';                                                                                           
run;                                                                                                                                    
quit; 

symbol i=line interpol=STEPJR   w=3 c=red;
   axis1 label=('x');                                                                                                                 
   axis2 label=(angle=90 'F(x)');                                                                                                     
   title1 'Binomial distribution';                                                                                           

proc gplot data=data;                                                                                                                 
  plot cdf_Binomial*x/haxis=axis1 vaxis=axis2 ;                                                                                                  
run;                                                                                                                                    
quit; 

endsubmit;

*Please input (Value of x, Probability, Number n);
x1    = 5;
p1    = 0.5;
n1    = 15;
y=pdf('Binomial',x1,p1,n1);
print('Binomial distribution for the specified x, p, n') x1[label=none] p1[label=none] n1[label=none];
print('P(X=x) = f(x) =') y[label=none] ;

z=cdf('Binomial',x1,p1,n1);
print('P(X<=x) = F(x) =') z[label=none];
z1=1-z;
print('P(X>=x) = 1-F(x-1) =') z1[label=none];
v=pdf('Binomial',x1-1,p1,n1);
print('P(X<x) = P(X<=x) - P(X=x) = P(X<=x-1) = F(x-1) =') v[label=none];
y1=1-y;
print('P(X>x) = P(X>=x) - P(X=x) = P(X>=x+1) = 1 - F(x) =') y1[label=none];

quit;
