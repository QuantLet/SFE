clear all
close all
clc

x    = [0 0 ; 1 0; 0 1; 1 1];
y    = [0 1 1 1];   
bias = 0.5;
p    = 5;

% creating grid
k = 60;
s = -1;
b = 0.05;
r = s : b : 1.95;
q = transpose(r);
w = ones(k^2, 2);

for i = 1 : k
    for j = 1 : k
        w(i + (j - 1)*k, 1) = q(i);
        w(i + (j - 1)*k, 2) = q(j);
    end
end

% main algorithm sigmoid funtion
w4 = zeros(size(w, 1), 1);
i  = 1;
m  = size(x, 1);
while i <= m,    
    w1 = [x(i, 1)*w(:, 1) + x(i, 2)*w(:, 2) - bias];
    w2 = 1./[1 + exp( - p*w1)];
    w3 = [(y(i) - w2).^2];
    w4 = w4 + w3; 
    i  = i + 1;  
end

% reshape results
w4res = reshape(w4, 60, 60);

% define grid
xx       = linspace(-1, 1.95, 60);
yy       = linspace(-1, 1.95, 60);
[XX, YY] = meshgrid(xx, yy);

% plot sigmoid function
figure(1)
plot1 = mesh(XX, YY, w4res, 'LineWidth', 2);
view([70, 30, 40])
set(gca, 'LineWidth', 1.6)
daspect([1 1 1])
xlabel('X', 'FontSize', 16)
ylabel('Y', 'FontSize', 16)
zlabel('Q(w)', 'FontSize', 16)
title('Error surface Q(w)', 'FontSize', 16)
set(gca, 'FontSize', 16)
zlim([0, 3])

% main algorithm for stepwise threshold function
w4 = zeros(size(w, 1), 1);
i  = 1;
m  = size(x, 1);
while i <= m    
    w1            = [x(i, 1)*w(:, 1) + x(i, 2)*w(:, 2) - bias];
    w2            = w1./abs(w1);
    w2(w2 == - 1) = 0;           %replace -1 with 0
    for j = 1 : length(w2)     
        wnan(j) = isnan(w2(j));  %replace NaN with 0
        if wnan(j) == 1
            w2(j) = 0;
        end
    end
    w3 = [(y(i) - w2).^2];
    w4 = w4 + w3; 
    i  = i + 1;  
end

% reshape
w4res = reshape(w4, 60, 60);

% define grid
xx       = linspace(-1, 1.95, 60);
yy       = linspace(-1, 1.95, 60);
[XX, YY] = meshgrid(xx, yy);

% plot stepwise threshold function
figure(2)
plot1 = mesh(XX, YY, w4res, 'LineWidth', 2);
set(gca, 'LineWidth', 1.6)
view([70, 30, 40])
daspect([1 1 1])
xlabel('X', 'FontSize', 16)
ylabel('Y', 'FontSize', 16)
zlabel('Q(w)', 'FontSize', 16)
title('Error surface Q(w)', 'FontSize', 16)
set(gca, 'FontSize', 16)
zlim([0, 3])