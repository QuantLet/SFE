%%%%% kernel smoothing routine %%%%%

function [rx rf] = sker(x, y, h, N, f)
% kernel regression smoothing for different kernel functions
% Default parameters
 if (isempty(N))
     N = 100;
 end
 if (isempty(f))
	 f = 'qua';
 end
 
 rn = N;
if (isempty(h))
           message('There is no enough variation in the data. Regression is meaningless.');
end
rh = h;


rx = linspace(min(x), max(x), N);
rf = zeros(0, N, 1);
for k = 1:N
    z     = kern((rx(k) - x) / h, f);
    rf(k) = sum(z .* y) / sum(z);
end

end
