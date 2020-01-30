clear
clc
close all

%% User inputs parameters

disp('Please input Delta t, Constant c, Trajectories  as: [1, 1, 3]') ;
disp(' ') ;
para = input('[Delta t, Constant c, Trajectories]=');

while length(para) < 3
    disp('Not enough input arguments. Please input in 1 * 3 vector form like [1, 1, 3] or [1 1 3]');
    para=input('[Delta t, Constant c, Trajectories]=');
end

dt = para(1);
c  = para(2);
k  = para(3);
disp(' ') ;

%% Main calculation

l      = 100;
n      = floor(l / dt);
t      = 0 : dt : n * dt;

rng(1); %seed random number generator
z      = rand(n, k); %simulate U[0,1] r.v.'s
z      = 2 * (z > 0.5) - 1;
z      = z * c * sqrt(dt);  %//to get finite and non-zero varinace
zz     = zeros(1, k);
x      = [zz; cumsum(z)];
listik = [t', x];

%% Output

hold on

for j = 1:k
    colors = rand(1, 3);
    plot(listik(:, 1), listik(:, j+1), 'Color', colors, 'Linewidth', 2)
end

title('Wiener process')
xlabel('Time t')
ylabel('Values of process X_t delta')
hold off