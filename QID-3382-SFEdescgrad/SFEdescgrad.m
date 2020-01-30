clear all
close all
clc

x     = [0 0; 1 0; 0 1; 1 1];
y     = [0 1 0 1];
bias  = 0.5;
p     = 5;
epoch = 8;
activ = 1;
k     = 60;
s     = -1;
b     = 0.05;
r     = s : b : 1.95;
q     = transpose(r);
w     = ones(k^2, 2);
for i = 1 : k
    for j = 1 : k
        w(i + (j - 1)*k, 1) = q(i);
        w(i + (j - 1)*k, 2) = q(j);
    end
end;

w4    = zeros(size(w, 1), 1);
i     = 1;
activ = 1;
m     = size(x, 1); 
while i <= m,   
    w1 = [x(i, 1)*w(:, 1) + x(i, 2)*w(:, 2) - bias];
    if activ == 1
        w2 = 1./[1 + exp(-p*w1)];
        if activ == 0
            w2 = w1/abs(w1);
            w2(w2 == [NaN; -1]) = [0; 0];
        end
        w3 = [(y(i) - w2).^2];
        w4 = w4 + w3;
    end
    i = i + 1;  
end

w4res    = reshape(w4, 60, 60);
xx       = linspace(-1, 1.95, 60);
yy       = linspace(-1, 1.95, 60);
[XX, YY] = meshgrid(xx, yy);
res      = surf(XX, YY, w4res, 'LineWidth', 2);
alpha(0)
set ( gca, 'ydir', 'reverse')
title('Error Surface: Learning weights') ; 
set(gca, 'FontSize', 16);

aa = [w w4];
w  = [-0.7 0.7;];                             %initial weights 
e  = 1;                                       %initializes epochs
aa = zeros(1, 3);
while (e <= epoch)
    sumerro = 0;
    sumgrad = 0;
    m       = size(x, 1);
    i       = 1;
    while i <= m                               %calculates for each weight
        inp     = (sum(w.*[x(i, :); ]) - bias); %the error function Q(w)
        activ   = 1./[1 + exp(-p*inp)];        %activation function
        deriv   = activ*(1 - activ);           %derivative of activation function
        erro    = (y(i) - activ);                
        sqerr   = erro.^2;                     %squared error
        sumerro = sumerro + sqerr;        
        grad    = 2.*erro.*deriv.*[x(i, :); ];  %gradient
        sumgrad = sumgrad + grad ;             %sum up gradients
        i       = i + 1;
    end
    bb = [w sumerro];
    w  = w + sumgrad;                          %corrects weights
    aa = [aa; bb];
    d1 = aa(2 : size(aa, 1), 1);
    d2 = aa(2 : size(aa, 1), 2);
    d3 = aa(2 : size(aa, 1), 3);

    hold on
    plot3(d2', d1', d3', '-ro', 'LineWidth', 2)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    hold off

    e = e + 1;                                  %next training period
end