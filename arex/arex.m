
function [a, u, fit, v] = arex(y, x, p, b, c)

if nargin == 4, c = 0; end;
    pp = max([p b]);
    xx = y(pp+1 : length(y));
    z  = x(pp+1 : length(y));
    if pp == 0;
    yy = y
    zz = x;
else
    for i = 1:pp,
    yy(: , pp+1-i) = y(i:length(y) - pp + i-1);
    zz(: , pp+1-i) = x(i:length(x) - pp + i-1);
    end;
end;

zzz = [z zz];
if c == 1,
    c = ones(length(xx),1);
elseif c == 2,
    cc = [ones(length(xx),1) (1:length(xx))'];
else
    cc = [];
end;

if p == 0,
    reg = [cc zzz(:, 1:b+1)];
else
    reg = [cc yy(:, 1:p) zzz(:, 1:b+1)];
end;

[a, u, fit, v] = ols(xx, reg);