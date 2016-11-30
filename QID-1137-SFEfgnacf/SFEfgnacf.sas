* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEfgnacf
* ---------------------------------------------------------------------
* Description:  SFEfgnacf produces plots and acf of fractional gaussian noise.
* ---------------------------------------------------------------------
* Usage:        -
* ---------------------------------------------------------------------
* Keywords:		fractional brownian motion, simulation, stochastic process, Hurst exponent, fractional gaussian noise, acf, autocorrelation
* ---------------------------------------------------------------------
* Inputs:       n - number of observations
*				H - Hurst exponent
* ---------------------------------------------------------------------
* Output:       Plots of fractional brownian motion with 2 different Hurst parameters.
* ---------------------------------------------------------------------
* Example:      Plots and ACFs of fractional gaussian noise with 2 different Hurst parameters and autoccorreletion functions.
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------;

* Reset the working evironment;
goptions reset  =  all;
proc datasets lib  =  work nolist kill;
run;
proc greplay nofs igout = work.gseg;
  delete _all_;
run;


* The macro %fgn generates one dimensional fractional Gaussian noise 'Z' on t in [0,1] 
 using 'n' grid points;

%macro fgn(H = , n = );
goptions reset  =  all;

proc iml;
n 		= &n;
H 		= &H;
r 		= j(n+1,1,0);
r[1,1]	= 1;

	do k = 1 to n;
	r[k+1,1]  =  0.5*((k+1)**(2*H) - 2*k**(2*H) + (k-1)**(2*H));
	end;

	omega      = j(2*n,1,0);

	do k       = 1 to n+1;
	omega[k,1] = r[k,1];
	end;

	do k       = n+2 to 2*n;
	omega[k,1] = r[2*n-(k-2),1];
	end;

	f    = fft(omega);
 	fft  = j(nrow(omega)/2-1,3,0);
    zero = j(nrow(f),1,0);
    ff   = f[,1]||(-f[,2])||zero;
    fft  = insert(fft,ff,1);
        
    

        do k = 1 to nrow(omega)/2-1;

        fft[nrow(omega)/2+1+k,1] = f[nrow(omega)-nrow(omega)/2-(k-1),1];
        fft[nrow(omega)/2+1+k,2] = f[nrow(omega)-nrow(omega)/2-(k-1),2];

        end;


fft[,3] = fft[,1]+fft[,2];
lambda  = fft[,3]/(2*n);
z       = j(nrow(lambda),1,0);
call randseed(0);
call randgen(z, "Normal");
   g    = fft(sqrt(lambda)#z);
 gft    = j(nrow(lambda)/2-1,3,0);
 zero   = j(nrow(g),1,0);
 gg     = g[,1]||(-g[,2])||zero;
gft     = insert(gft,gg,1);
        
  
        do k = 1 to nrow(lambda)/2-1;
        gft[nrow(lambda)/2+1+k,1] = g[nrow(lambda)-nrow(lambda)/2-(k-1),1];
        gft[nrow(lambda)/2+1+k,2] = g[nrow(lambda)-nrow(lambda)/2-(k-1),2];
        end;

gft[,3] = gft[,1]+gft[,2];
W 		= j(nrow(gft),2,0);
W[,2]    =  n**(-H)*cusum(gft[,3]); 

do k = 1 to nrow(w);
w[k,1] = k/nrow(w);
end;

create w from w; append from w;
close w;
	
quit;
* The dataset W contains the fractional brownian motion Wt;

 data w;set w;
 rename col1 = t;
 rename col2 = Wt;
 run;

 data w(drop = Wt);set w;
 fgn = Wt-lag(Wt);		*fgn is the fractional Gaussian noise;
 if fgn =. then delete;
 run;


 *Plot the fgn graph;


 title 'Fractional Gaussian Noise with '&n' observations and H'=&H;


symbol i = line interpol = join c = blue w = 1.5;
goptions device = png nodisplay ;*xpixels = 200 ypixels = 100;

proc gplot data = w;
plot fgn*t;
run;
quit;

*Compute the ACF;

proc arima data = w ;
identify var = fgn  nlag=30 outcov = acf noprint;
run;
quit;


goptions reset  =  all;


*Plot the ACF graph;
 title 'Sample Autocorrelation Function' ;
symbol1 interpol = needle ci = red w=8 cv=blue value=dot                                                                                        
        height=1 ;   
goptions device = png nodisplay ;*xpixels = 200 ypixels = 100;

proc gplot data = acf;
plot corr*lag ;
run;
quit;

%mend;


%fgn(H = 0.2, n = 500); *FGN with H = 0.2;

%fgn(H = 0.8, n = 500); *FGN with H = 0.8;

 
* Overlay the four graphs;

goptions device = png display xpixels = 1200 ypixels = 800;

proc greplay igout = gseg tc = sashelp.templt nofs;
template = l2r2;
treplay 1:gplot 2:gplot1 3:gplot2 4:gplot3;
run;
quit;
