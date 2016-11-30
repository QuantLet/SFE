* Computation of the kurtosis of GARCH(1,1) processes;

proc iml;

	
   XDiv = do(0, 0.3, 0.01);
   YDiv = do(0, 0.3, 0.01);
   X = repeat(XDiv, 31);
   X = shape(X, 31*31);
   Y = repeat(YDiv, 31);
   Y = shape(T(Y),31*31);

   kurtosis = 3 + 6*(x##2) /(1-y##2-2*x#y-3*x##2);

   plot = x||y||kurtosis;

   create plot from plot; append from plot;
   close plot;

   quit;

* Plot of the kurtosis of GARCH(1,1) processes;

 data plot;set plot;
 rename col1 = alpha col2 = beta col3 = Kurtosis;

 title 'Kurtosis of the GARCH(1,1) process ' ;


proc g3d data = plot ;
 plot alpha*beta = kurtosis/  cbottom = red ctop = blue
grid  rotate = 45;
label  alpha = 'Alpha'
		beta ='Beta';
run;
quit;

*The following section creates an animated 3D plot;

/* Designate a GIF file for the G3D output, like below. */

filename anim 'd:kurtosis.gif'; 
** Set the GOPTIONs necessary for the animation. **/;

goption reset dev=gifanim gsfmode=replace
border gsfname=anim xpixels=640 ypixels=480 iteration=0 delay=60 gepilog='3B'x
/* add a termination char to the end of the GIF file */
disposal=background; 

proc g3d data = plot;
 plot alpha*beta = kurtosis/  cbottom = red ctop = blue 
grid rotate = 45 to 350 by 10;
  
run;
quit;
*Open the file 'd:kurtosis.gif' and enjoy the 3D animation;