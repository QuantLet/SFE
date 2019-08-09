# clear variables and close windows
rm(list=ls(all=TRUE))
graphics.off()


# input parameters
n    = 1000;
a    = 2;
b    = 0;
M    = 11;
seed = 12;
y    = NULL;

# main computation
y[1] = seed;
i    = 2;

while (i<=n){
    y[i]=(a*y[i-1]+b)%%M; # modulus
    i=i+1;
}

y = y/M;

# output
plot(y[1:(n-2)],y[2:(n-1)],col="black", xlab=c(expression(U*bold(scriptstyle(atop(phantom(1),(i-1)))))), 
     ylab=c(expression(U*bold(scriptstyle(atop(phantom(1),i))))), xlim=c(0,1.2),ylim=c(0,1))
