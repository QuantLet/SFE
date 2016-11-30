* Reset the working evironment;
goptions reset = all;
proc datasets lib = work nolist kill;
run;

*Input data from the text file volsurfdata2.dat;
*Please make sure to give the right path of the file as below!;
*Change with your own path, like "Root:Folder1Folder2volatility_surface.dat";

proc import datafile = "C:UsersAdministratorDownloadsvolatility_surface.dat"
dbms = tab out = vol  replace;
getnames = no;
run;

data vol;set vol;
rename var1 = Price var2 = Strike var3 = Rate var4 = Time var5 = Value var6 = Class;

data vol;set vol;
mon = Price/Strike;
run;



proc iml;
use vol;
read all into x;

*Define function to compute the implied volatility;

   start  bsvolty(volty) global(strike, time,eq_price, intrate, opt_price,class);
	
   if class = 1 then optprice = blkshclprc(strike, time,eq_price, intrate, volty);
   if class = 0 then optprice = blkshptprc(strike, time,eq_price, intrate, volty);
   diff = -abs(optprice-opt_price);
   return(diff);
	finish;

*Calling NLPLM optimization routine to estimate implied volatility;

	volimp = j(nrow(x),1,0);

	do i = 1 to nrow(x);
			   strike  =  x[i,2];
			   eq_price  =  x[i,1];
			   intrate  =  x[i,3];
			   time  =  x[i,4];
			   opt_price = x[i,5];
			   class = x[i,6];


				volty = 0.3;
				optn = {1 0};
				con = {0.00001,.};
				call NLplm(rc,xres,"bsvolty",volty,optn,con);
				volimp[i,1] = xres[1];
	end;

	*Creating grids for 3d ploting;

	firstmon = 0.8;
	lastmon = 1.2;
	firstmat = 0;
	lastmat = 1;

	stepwidth1 = 0.02;
	stepwidth2 = 1/52;
	
	lengthmon = ceil((lastmon-firstmon)/stepwidth1);
	lengthmat = ceil((lastmat-firstmat)/stepwidth2);

	mon =  j(lengthmat+1,lengthmon+1,0);
	mat  =  j(lengthmat+1,lengthmon+1,0);

	
		do i  =  1 to nrow(mon);
		mon[i,]  =  (0:lengthmon)*(stepwidth1)+firstmon;
		end;

		do i  =  1 to ncol(mat);
		mat[,i]  =  (0:lengthmat)`*(stepwidth2);
		end;

	
	*Compute the implied valility for grid;

		gmon = lengthmon+1;
		gmat = lengthmat+1;
		v = nrow(x);
		
		beta = j(gmat,gmon,0);

		j = 1;

do while(j<gmat+1);
		    k = 1;
		    do while(k<gmon+1);

		        i = 1;
		        XX = j(v,3,0);
			        do while (i<v+1);
			            XX[i,1] = 1;
						XX[i,2] = x[i,7]-mon[j,k];
						XX[i,3] = x[i,4]-mat[j,k];
			            i = i+1;
			        end;


        Y = volimp;

        h1 = 0.1;
        h2 = 0.75;

        W = j(v,v,0); *Kernel matrix;
  
        i = 1;
		        do while(i<v+1);
		            u1 = (x[i,7]-mon[j,k])/h1;
		            u2 = (x[i,4]-mat[j,k])/h2;
		            aa = 15/16*(1-u1**2)**2*(abs(u1) <=  1)/h1;
		            bb = 15/16*(1-u2**2)**2*(abs(u2) <=  1)/h2;
		            W[i,i] = aa*bb;
		            i = i+1;
		        end;
        est = inv(XX`*W*XX)*XX`*W*Y;
        beta[j,k] = est[1,1];
        k = k+1;
		    end;
		    j = j+1;
end;

iv = beta;


ex1 = loc(x[,4]>1);
ex2 = loc(x[,7]<0.8 | x[,7]>1.2);
ex = (ex1||ex2)`;
x[ex,] = .;


mon  =  (shape(mon,1))`;
mat  =  (shape(mat,1))`;
IV =  (shape(iv,1))`;
d3d  =  mon||mat||IV;
d4d = x[,7]||x[,4]||volimp;

create d3d from d3d; append from d3d;
close d3d;
create d4d from d4d; append from d4d;
close d4d;


   quit;

   *Prepare data for 3D graph;

data d3d;set d3d;
rename col1  =  mon col2  =  mat col3  =  iv;

data d4d;set d4d;
rename col1  =  mon col2  =  mat col3  =  iv;


data d3d;set d3d;
group = 1;
cvar = 'blue';
data d4d;set d4d;
group = 0;
cvar = 'red';

proc append data = d4d base = d3d force;
run;

*Plot the 3d graph;


title  'Implied Volatility as function of time to maturity and monyness';

proc g3d data = d3d;
scatter mat*mon =  iv/noneedle
color = cvar
rotate = 45;
 /* Change the axis labels */
   label mat='Time to maturity'
         mon='Monyness'
         iv='Implied Volatility';;
run;
quit;