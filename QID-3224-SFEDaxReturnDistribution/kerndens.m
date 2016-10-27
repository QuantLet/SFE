function [xg fh] = kerndens(x, h, N, f)

n  = size(x,1);   %number of observations
xr = diff([min(x), max(x)]);
ng = 400;
xg = (xr + 7 * h) * (0:(ng - 1)) / (ng - 1) + min(x) - 3.5 * h;
fk = zeros(ng,n);
for (j = 1:n)
  fk(:, j) = kern((xg - x(j)) / h, f) / (n * h); %Gaussian kernel
end
fh = sum(fk'); %Kernel density estimate

fh = fh';

end