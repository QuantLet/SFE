# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("fExtremes")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Main computation
x = rgpd(100, xi = 0.1)  # generate a generalized pareto distributed variables 
x = sort(x)
n = length(x)
q = "0.01"
k = "10"

message = "      Quantile"
default = q
q = winDialogString(message, default)
q = type.convert(q, na.strings = "NA", as.is = FALSE, dec = ".")

message = "      Excess"
default = k
k = winDialogString(message, default)
k = type.convert(k, na.strings = "NA", as.is = FALSE, dec = ".")

if (k < 8 && k > (n - 1)) warning("SFEhillquantile: excess should be greater than 8 and less than the number of elements.", 
                                  call. = FALSE)
if (q < 0 && q > 1) warning("SFEhillquantile: please give a rational quantile value.", 
                            call. = FALSE)

rest = gpdFit(x, nextremes = k, type = "mle")				# ML-estimation of gamma 
rest = rest@parameter

# the Hill-quantile value
(xest = x[k] + x[k] * (((n/k) * (1 - q))^(-rest$u) - 1))	# Hill-quantil estimation