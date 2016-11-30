* ---------------------------------------------------------------------
* Book:         SFE3
* ---------------------------------------------------------------------
* Quantlet:     SFEfbmplot
* ---------------------------------------------------------------------
* Description:  SFE_fBM produces plots and acf of fractional  brownian motion. 
* ---------------------------------------------------------------------
* Usage:        -
* ---------------------------------------------------------------------
* Keywords:		fractional brownian motion, simulation, stochastic process, Hurst exponent
* ---------------------------------------------------------------------
* Inputs:       n - number of observations
*				H - Hurst exponent
* ---------------------------------------------------------------------
* Output:       Plots of fractional brownian motion with 2 different Hurst parameters.
* ---------------------------------------------------------------------
* Example:      Plots of Fractional Brownian Motion, sample size: 1000,
*               Hurst exponents: H1 = 0.2, H2 = 0.8.
* ---------------------------------------------------------------------
* Author:       Daniel Traian Pele
* ---------------------------------------------------------------------

* Reset the working evironment;
goptions reset  =  all;
proc datasets lib  =  work nolist kill;
run;
proc greplay nofs igout = work.gseg;
  delete _all_;
run;


* The macro %fbm generates one dimensional fractional Brownian motion 'W' on t in [0,1] 
 using 'n' grid points;

%macro fbm(H = , n = );

proc iml;
n 		= &n;
H 		= &H;
r 		= j(n+1,1,0);
r[1,1]	= 1;

	do k = 1 to n;
	r[k+1,1]  =  0.5 * ((k+1)**(2*H) - 2*k**(2*H) + (k-1)**(2*H));
	end;

	omega      = j(2*n, 1, 0);

	do k       = 1 to n+1;
	omega[k,1] = r[k,1];
	end;

	do k       = n+2 to 2*n;
	omega[k,1] = r[2*n-(k-2), 1];
	end;

	f    = fft(omega);
 	fft  = j(nrow(omega)/2-1, 3, 0);
    zero = j(nrow(f), 1, 0);
    ff   = f[,1]||(-f[,2])||zero;
    fft  = insert(fft, ff, 1);
        
    

        do k = 1 to nrow(omega)/2-1;

        fft[nrow(omega)/2+1+k, 1] = f[nrow(omega) - nrow(omega)/2-(k-1), 1];
        fft[nrow(omega)/2+1+k, 2] = f[nrow(omega) - nrow(omega)/2-(k-1), 2];

        end;


fft[,3] = fft[,1] + fft[,2];
lambda  = fft[,3] / (2*n);
z       = j(nrow(lambda),1,0);
call randseed(0);
call randgen(z, "Normal");
   g    = fft(sqrt(lambda)#z);
 gft    = j(nrow(lambda)/2-1, 3, 0);
 zero   = j(nrow(g), 1, 0);
 gg     = g[,1]||(-g[,2])||zero;
gft     = insert(gft, gg, 1);
        
  
        do k = 1 to nrow(lambda)/2-1;
        gft[nrow(lambda)/2+1+k, 1] = g[nrow(lambda) - nrow(lambda)/2-(k-1), 1];
        gft[nrow(lambda)/2+1+k, 2] = g[nrow(lambda) - nrow(lambda)/2-(k-1), 2];
        end;

gft[,3]  = gft[,1] + gft[,2];
W 		 = j(nrow(gft),2,0);
W[,2]    = n**(-H) * cusum(gft[,3]); 

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

 *Plot the FBM graph;


 title 'Fractional Brownian Motion with '&n' observations and H'=&H;


symbol i = line interpol = join c = blue w = 1.5;
goptions device = png nodisplay xpixels = 300 ypixels = 200;

proc gplot data = w;
plot wt*t;
run;
quit;
%mend;


%fbm(H = 0.2, n = 1000); *FBM with H = 0.2;

%fbm(H = 0.8, n = 1000); *FBM with H = 0.8;

 
* Overlay the two graphs;

goptions device = png display xpixels = 600 ypixels = 500;

proc greplay igout = gseg tc = sashelp.templt nofs;
template = v2;
treplay 1:gplot 2:gplot1;
run;
quit;
