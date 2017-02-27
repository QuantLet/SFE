function [ llh, eta, Q, Q_start, D2] = llh_gen_mgarch( X, var_params, uni_omega, uni_alpha, uni_beta)
 
dim_     = size(X,2);         % dimensionality of the process
nobs     = size(X,1);         % length of the series 
H_start  = (X' * X)/ nobs; 
D2_start = diag(H_start);     % unconditional variance column vector
st_X     = X ./ repmat((sqrt(D2_start(:)))', nobs, 1); % standardised time series
Q_start  = (st_X' * st_X)/nobs; % unconditional correlation matrix
 
Q        = zeros(dim_);
D2       = zeros(dim_);
epsilon  = zeros(dim_,1); % D^(-1/2)*X
eta      = zeros(nobs, dim_); % residuals

a = var_params(1);
b = var_params(2);

llh2 = 0;
          
for i = 1:nobs
      if i == 1
            Q  = (1 - a - b)*Q_start + a*0 + b*Q_start;
            D2 = uni_omega(:) + uni_alpha(:).*0 + uni_beta(:).*D2_start;
      else
            
            Q  = (1 - a - b)*Q_start + a*(epsilon*epsilon') + b*Q;
            D2 = uni_omega(:) + uni_alpha(:).*(X(i-1,:))'.^2 + uni_beta(:).*D2;
      end
            R = diag(sqrt(diag(Q)))Q/diag(sqrt(diag(Q)));
            H = diag(sqrt(D2))*R*diag(sqrt(D2));
            epsilon   = diag(sqrt(D2)) (X(i,:))';
            eta(i, :) = (sqrtm(H)(X(i, :))');           
            eta(eta <- 38) = -38; % truncation of extreme etas, can be changed
            eta(eta > 38)  = 38;
            llh2 = llh2 + log(det(H))/2;
            
            
end
            
pdf_eta = normpdf(eta);

%if eta converges to zero:
pdf_eta(pdf_eta<1e-50) = 1e-50;
                            
llh1 = - sum(sum(log(pdf_eta)));
llh  = llh1 + llh2; % llh consists of two components, as in Lee-Long (2009)

end
