
clear
clc
close all

load ('volsurfdata2.dat')
x          = volsurfdata2;
x(:,7)     = x(:,1)./x(:,2);

Price      = x(:,1);
Strike     = x(:,2);
Rate       = x(:,3);
Time       = x(:,4);
Value      = x(:,5);
Class      = x(:,6);
mon        = x(:,7);

iv         = blsimpv(Price, Strike, Rate, Time, Value,[],[], [],Class);

firstmon   = 0.8;
lastmon    = 1.2;
firstmat   = 0;
lastmat    = 1;

stepwidth  = [0.02 1/52];
lengthmon  = ceil((lastmon-firstmon)/stepwidth(1));
lengthmat  = ceil((lastmat-firstmat)/stepwidth(2));

mongrid    = linspace(0.8,1.2,lengthmon+1);
matgrid    = linspace(0,1,lengthmat+1);

[MON, MAT] = meshgrid(mongrid,matgrid);

gmon       = lengthmon+1;
gmat       = lengthmat+1;
uu         = size(x);
v          = uu(1,1);

beta       = zeros(gmat,gmon);

j          = 1;
while (j<gmat+1);
    k      = 1;
    while (k<gmon+1);

        i  = 1;
        X  = zeros(v,3);
        while (i<v+1);
            X(i,:) = [1,x(i,7)-MON(j,k), x(i,4)-MAT(j,k)];
            i      = i+1;
        end


        Y  = iv;

        h1 = 0.1;
        h2 = 0.75;

        W  = zeros(v,v); %Kernel matrix
  
        i  = 1;
        while (i<v+1);
            u1     = (x(i,7)-MON(j,k))/h1;
            u2     = (x(i,4)-MAT(j,k))/h2;
            aa     = 15/16*(1-u1^2)^2*(abs(u1) <= 1)/h1;
            bb     = 15/16*(1-u2^2)^2*(abs(u2) <= 1)/h2;
            W(i,i) = aa*bb;
            i      = i+1;
        end
        est        = inv(X'*W*X)*X'*W*Y;
        beta(j,k)  = est(1);
        k          = k+1;
    end
        j = j+1;
end

IV      = beta;


ex1     = find(x(:,4)>1);
ex2     = find(x(:,7)<0.8 |x(:,7)>1.2);
ex      = [ex1;ex2];
x(ex,:) = [];

Price   = x(:,1);
Strike  = x(:,2);
Rate    = x(:,3);
Time    = x(:,4);
Value   = x(:,5);
Class   = x(:,6);
mon     = x(:,7);

iv      = blsimpv(Price, Strike, Rate, Time, Value,[],[], [],Class);

surf(MON,MAT,IV)
colormap hsv
alpha(0.3) 

hold on
scatter3(mon, Time,iv, 'filled')
xlabel('Moneyness')
ylabel('Time to Maturity')
zlabel('Implied Volatility')
hold off