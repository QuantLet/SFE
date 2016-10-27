
clear
clc
close all

para = input('[k, mu, sigma, n, sr] (default [0.1,0.1,0.1,50,0.05], press enter): ','s');
if isempty(para)
	k=0.1;  	%reversion rate
	mu=0.1; 	%steady state
	sigma=0.1; 	%volatility
	n=50;      	%time horizon
	sr=0.05;    	%short rate at time t
end
if  sigma<=0
    disp('cir: Specify positive volatility again!');
    disp(' ') ;
    sigma = input('sigma=');
end
if k<0
    disp('cir: Mean reversion rate should be non-negative, please input k again!');
    disp(' ') ;
    k =input('k=');
end
if n<=0
    disp('cir: time must be positive, please input n again!');
    disp(' ') ;
    n =input('n=');
end
  tau  = 1:n;              	% vector of maturities in years
  gam  = sqrt(k^2+2*sigma^2);
  ylim = 2*k*mu/(gam+k);
  g    = 2*gam + (k+gam)*(exp(gam*tau)-1);
  b    = -(2*(exp(gam*tau)-1))./g;
  a    = 2*k*mu/sigma^2*log(2*gam*exp((k+gam)*tau/2)./g);
  p    = exp(a+b*sr);      	% the bond prices
  y    = (-1./tau).*log(p);     % the yields
  w    = [y];
  wlim = [ones(1,max(tau)).*ylim];
  z    = [tau;p;y];
plot(w', 'LineWidth',5)
hold on
plot(wlim', '.r')
hold off
xlabel('Time to Maturity')
ylabel('Yield')
title(sprintf('Yield Curve, CIR Model'))  