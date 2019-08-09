[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **hillgp1** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet: hillgp1

Published in: Statistics of Financial Markets

Description: Hill estimator for the GP1 model.

Keywords: generalized-pareto-model, hill-estimator

See also: SFEhillquantile

Author: Awdesch Melzer

Submitted: Thu, January 23 2014 by Awdesch Melzer
Submitted[Matlab]: Thu, December 22 2016 by Lily Medina

Input: x- data vector, k- integer, number of upper extremes

Output: alpha- scalar, estimated shape parameter, sigma- scalar, estimated scale parameter

```

### MATLAB Code
```matlab


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

```

automatically created on 2018-05-28