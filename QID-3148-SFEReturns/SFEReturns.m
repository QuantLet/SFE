
clear
clc 
close all

% Read data for FTSE and DAX

DS = load('FTSE_DAX.dat');
D  = [DS(:,1)];                            % date
S  = [DS(:,2:43)];                         % S(t)
s  = [log(S)];                             % log(S(t))
r  = [s(2:end,:) - s(1:(end-1),:)];        % r(t)
n  = length(r);                            % sample size
t  = [1:n];                                % time index, t
format short;

% Estimation of the first order autocorrelation

for i = 1:42;
  yp    = corrcoef(r(1:(length(r)-1),i), r(2:(length(r)),i));
  ys    = corrcoef(r(1:(length(r)-1),i).*r(1:(length(r)-1),i), r(2:(length(r)),i).*r(2:(length(r)),i));
  ya    = corrcoef(abs(r(1:(length(r)-1),i)), abs(r(2:(length(r)),i)));
  zp(i) = [yp(2,1,:)];
  zs(i) = [ys(2,1,:)];
  za(i) = [ya(2,1,:)];
end

% Estimation of skewness

skew = (skewness(r))';

% Estimation of kurtosis

kurt = (kurtosis(r))';

% Estimation of the BJ test statistic for returns

BJ = n * ( skew .* skew / 6 + ( ( kurt - 3 ) .* ( kurt - 3 ) ) / 24 );

% Estimated parameters

Y = [ zp' zs' za' skew kurt BJ ];

disp('First order autocorrelation of the returns,')
disp('First order autocorrelation of the squared returns,')
disp('First order autocorrelation of the absolute returns,')
disp('Skewness & ')
disp('Kurtosis')
disp(Y(:,1:5))

disp(' ')
disp('Bera-Jarque test statistic')
disp(Y(:,6))