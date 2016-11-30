proc iml;
K	=  	800;   	*Input Strike Price;
S	=	900;   	*Input Spot Price; 
r	=	0.1;	*Input Interest Rate;
tau	=	0.8;	*Input Remaining Time;
P	=	5.4;	*Input Price of European Put;
D	=	2;		*Input Value of all Earnings and Costs Related to Underlying;
C = P-K*exp(-r*tau)+S-D;
print ('Price of the European Call  = ') C;

if ( max( K*exp(-r*tau)-S-D, 0)<= P <= K)
    then print 'SFEPutCall: General arbitrage inequality is not satisfied!';
quit;