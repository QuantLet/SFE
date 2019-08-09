
function [alpha, sigma] = hillgp1 (x, k)
  n0 = size (x,1);
  x  = log(sort(x.*(x > 0)));
  n  = size (x,1);
  if(n < 2)
      error('Data set must have at least 2 positive elements')
  end
  
  if (k < 2)
    warning(k < 2, 'Hill estimator requires at least two exceedances')
    k = 2;
  end
  if (k > n)
    warning (k > n, 'k is larger than the number of positive data points')
    k = n;
  end
  alpha = 1 / (mean (x ((n-k+2):n)) - x (n-k+1));
  sigma = exp (x (n-k+1)) * (k/n0).^(1/alpha);
  end
