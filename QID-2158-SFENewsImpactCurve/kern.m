% kernel functions
 function y = kern(x, f)
	
	if strcmp(f, 'gau') % gaussian kernel
		y = normpdf(x);
    end
    if strcmp(f, 'qua') % quadric / biweight kernel
		y = 0.9375 .* (abs(x) < 1) .* (1 - x .^ 2) .^ 2;
    end
	if strcmp(f, 'cosi') % cosine kernel
		y = (pi / 4) .* cos((pi/2) .* x) .* (abs(x) < 1);
    end
	if strcmp(f, 'tri') % triweight kernel
		y = 35 / 32 .* (abs(x) < 1) .* (1 - x .^ 2) .^ 3;
    end
    if strcmp(f, 'tria') % triangular kernel
		y = (1 - abs(x)) .* (abs(x) < 1);
    end
    if strcmp(f, 'uni') % uniform kernel
		y = 0.5 .* (abs(x) < 1);
    end
    if strcmp(f, 'spline') % spline kernel
		y = 0.5 .* (exp(-abs(x) ./ sqrt(2))) .* (sin(abs(x) ./ sqrt(2) + pi / 4)); 
    end
	if exist(f) == 0
        y = normpdf(x);
    end
 end