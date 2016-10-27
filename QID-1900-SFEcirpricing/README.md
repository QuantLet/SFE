
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="887" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEcirpricing** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEcirpricing

Published in : Statistics of Financial Markets

Description : Calculates a price of a bond using CIR model.

Keywords : asset, cir, interest-rate, simulation, implied-volatility, bond, price, Black, financial

See also : SFECIRmle, SFEscomCIR, SFEsimCIR, SFEcir, SFEsimVasi

Author : Awdesch Melzer, Li Sun

Author[Matlab] : Li Sun

Submitted : Thu, September 27 2012 by Dedy Dwi Prastyo

Input : 'Parameters of the CIR model (a, b, sigma), time to maturity (in years), risk free rate at
time t.'

Output : Bond price

Example : 'For [a, b, sigma, tau, r] = [0.221, 0.020, 0.055, 0.250, 0.020] a bond price of 0.995 is
calculated.'

```


### R Code:
```r

# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Parameters of the CIR model (a, b, sigma)
a     = 0.221
b     = 0.02
sigma = 0.055

tau = 0.25  # time to maturity (in years)
r   = 0.02  # risk free rate at time t

# Main computation
phi = sqrt(a^2 + 2 * sigma^2)
g   = 2 * phi + (a + phi) * (exp(phi * tau) - 1)
B   = (2 * (exp(phi * tau) - 1))/g
A   = 2 * a * b/sigma^2 * log(2 * phi * exp((a + phi) * tau/2)/g)

Bondprice = exp(A - B * r)
print(paste("Bond price = ", Bondprice))

```

### MATLAB Code:
```matlab

clear
clc
close all

%% User inputs parameters

disp('Please input [a, b, sigma, tau, r] as: [0.221, 0.020, 0.055, 0.250, 0.020]');
disp(' ');
para=input('[a, b, sigma, tau, r] =');

while length(para) < 5
  disp('Not enough input arguments. Please input in 1*5 vector form like [0.221, 0.020, 0.055, 0.250, 0.020]');
  para=input('[a, b, sigma, tau, r] as =');
end

a=para(1);
b=para(2);
sigma=para(3);
tau=para(4);
r=para(5);

%% Main computation

phi  = sqrt(a^2+2*sigma^2);
g    = 2*phi + (a+phi)*(exp(phi*tau)-1);
B    = (2*(exp(phi*tau)-1))./g;
A    = 2*a*b/sigma^2*log(2*phi*exp((a+phi)*tau/2)./g);

Bondprice = exp(A-B*r);

disp('Bond price =')
disp(Bondprice)
 
```
