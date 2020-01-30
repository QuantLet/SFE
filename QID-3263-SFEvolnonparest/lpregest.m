function [bhat x]=lpregest(X, Y, p, h)
n     = max(size(X));
x     = (min(X) : (max(X) - min(X))/(100) : max(X))'; 
gridm = max(size(x));
bhat  = zeros(p + 1, gridm);
for i = 1 : gridm
    dm = ones(n, 1);
    xx = X - x(i);
    if p>0
        for j = 1 : p
            dm = [dm (xx).^j];
        end;
    end;
    w          = diag(quadk(xx./h)./h);
    mh         = inv(dm'*w*dm)*dm'*w;
    bhat(:, i) = mh*Y;
end

