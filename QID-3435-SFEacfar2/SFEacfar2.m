% user inputs parameters
disp('Please input lag value lag, value of alpha1 a_1, value of alpha_2 a2 as: [30, 0.5 0.4]') ;
disp(' ') ;
para = input('[lag, a1, a2]=');

while length(para) < 3
    disp('Not enough input arguments. Please input in 1*3 vector form like [30, 0.5, 0.4] or [30 0.5 0.4]');
    para=input('[lag, a1, a2]=');
end

lag = para(1);
a1  = para(2);
a2  = para(3);

% main computation
randn('state', 0);                % Start from a known state.
x = randn(10000, 1);              % 10000 Gaussian deviates ~ N(0, 1).
y = filter(1, [1 -a1 -a2], x);    % Create an AR(2) process.
autocorr(y, lag, [], 2);          % Plot the acf with 95% CI