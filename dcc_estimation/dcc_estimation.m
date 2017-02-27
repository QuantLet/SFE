
function[coeff, eta] = dcc_estimation(X)

dim_ = size(X,2); % dimensionality of the process

%%%%%% First step - estimate univariate GARCHes (1, 1 )
spec = garchset('P', 1, 'Q', 1, 'C', 0, 'Display', 'off'); % set 'Display' to 'off' to suppress the optimisation details

    uni_omega = zeros(1, dim_);
    uni_alpha = zeros(1, dim_);
    uni_beta  = zeros(1, dim_);
    for k = 1:dim_
         [coeff,~,~,~,~,~] = garchfit(spec, X(:,k));
         uni_omega(k) = coeff.K;
         uni_alpha(k) = coeff.ARCH;
         uni_beta(k)  = coeff.GARCH;
    end

%%%%%% Second step, using univariate GARCH parameters, estimate DCC
%%%%%% parameters

%%%%%% Optimisation specification
x0 = [.49 .49]; % start values
lb = [0  0];   % lower boundaries
ub = [1  1];  % higher boundaries

% constraint inequality matrix
C_A = [1 1 ];     
C_b = 1;      % a+b<1

options = optimset('MaxFunEvals', 1000, 'MaxIter', 400,  'TolFun', 1e-12, 'GradObj', ...
    'off', 'TolCon', 1e-12, 'TolX', 1e-12, 'Display','off', 'Algorithm','interior-point', ...
    'Diagnostics' , 'off', 'MaxSQPIter', 800);
[coeff, ~, ~, ~, ~, ~, ~] = fmincon(@(var_params)llh_gen_mgarch(X, var_params, uni_omega, uni_alpha, uni_beta), x0, C_A, C_b, [],[], lb, ub, [], options);
[~, eta, ~, ~, ~] = llh_gen_mgarch(X, coeff, uni_omega, uni_alpha, uni_beta);
coeff = [uni_omega uni_alpha uni_beta coeff];
      
end
