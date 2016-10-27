
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFEbinomv_log** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of QuantLet : SFEbinomv_log

Published in : Statistics of Financial Markets

Description : 'Compares the logarithmic density of generated binomial processes with the
logarithmic density of normally distributed random variables.'

Keywords : 'binomial, density, distribution, estimation, graphical representation, kernel,
lognormal, normal, normal-distribution, plot, process, random-number-generation'

See also : SFEBinomp, SFEWienerProcess, SFEbinomv, SFEbinomv

Author : Cindy Lamm, Ying Chen, Christian M. Hafner

Submitted : Sat, June 13 2015 by Lukas Borke

Input: 
- n: number of steps
- k: number of paths
- p: probability of up movement

Example : 'User inputs the parameters n, k, p, then the logarithmic density of generated binomial
processes with the log-normal density is plotted.'

```

![Picture1](SFEbinomv_log-1.png)


### R Code:
```r

graphics.off()
rm(list = ls(all = TRUE))

# Define function
SFEbinomv = function(n, k, p) {
    if (n <= 0) {
        stop("please input n > 0!")
    }
    if (k <= 0) {
        stop("please input k > 0!")
    }
    if (p <= 0 | p >= 1) {
        stop("please choose p in the interval of (0,1)!")
    }
    
    n = floor(n)  # makes sure number of steps is integer
    k = floor(k)  # makes sure number of path is integer
    
    # main computation
    set.seed(0)
    z        = matrix(runif(n * k), n, k)
    z        = ((floor(-z + p)) + 0.5) * 2      # scale ordinary binomial processes
    x        = apply(z, MARGIN = 2, FUN = sum)  # end values of the k binomial processes
    h        = 0.3 * (max(x) - min(x))          # bandwidth used to estimate the density of end values
    xdens    = density(x, bw = h)               # Kernel-based density estimation with specified bandwidth
    trend    = n * (2 * p - 1)
    std      = sqrt(4 * n * p * (1 - p))
    norm     = std * rnorm(k) + trend
    normdens = density(norm, bw = h)
    
    # plot of logs of densities
    plot(as.matrix(xdens$x), log(as.matrix(xdens$y)), type = "l", lwd = 2, 
        col = 4, xlim = c(min(xdens$x, normdens$x), max(xdens$x, normdens$x)), 
        ylim = c(min(log(xdens$y), log(normdens$y)), max(log(xdens$y), log(normdens$y))), 
        main = "Distribution of generated logarithmic binominal processes")
    lines(as.matrix(normdens$x), log(as.matrix(normdens$y)), col = 2, lwd = 2, lty = 2)
    legend("topleft", c("Binomial", "Normal"), col = c(4, 2), lwd = 2, lty = 1:2)
}

# enter parameters as n = 100 (number of steps), k = 100 (number of paths), p = 0.5 (probability of up movement)
SFEbinomv(n = 100, k = 100, p = 0.5) 

```
