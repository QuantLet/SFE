%% clear all variables and console 
clear
clc

%% close windows
close all

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
Data       = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);
Data       = Data(:,{'Date','DAX30','FTSE100'});

%% log-returns
Vrbls     = table2array(Data(:,{'DAX30','FTSE100'}));
ret       = diff(log(Vrbls(:,1)));   
ret(:, 2) = diff(log(Vrbls(:,2)));   

%% estimated parameters of a multivariate GARCH model
[Par, L, Ht, likelihoods, stdresid, stderrors, A, B, scores] = full_bekk_mvgarch(ret,1,1);

%% print output
format long
Par
L

%% the estimated variance and covariance processes
n = numel(Ht); % number of array elements in Ht
H = Ht(1:n)';
H = reshape(H,4,n/4)';

%% plot
subplot(3,1,1) 
plot(Data.Date(2:end),H(:,1))
title('DAX')

subplot(3,1,2)
plot(Data.Date(2:end),H(:,2))
title('Covariance')

subplot(3,1,3)
plot(Data.Date(2:end),H(:,4));
title('FTSE 100')

% Remark: the quantlet uses the following functions shown below (please save them as separate .m files):
% fattailed_garch, fattailed_garchlikelihood, garchcore, hessian_2sided,
% vech, scalar_bekk_mvgarch_likelihood, ivech, full_bekk_mvgarch_likelihood,
% full_bekk_mvgarch, scalar_bekk_mvgarch

%% -------------------------------------------------------------------------
function [parameters, likelihood, stderrors, robustSE, ht, scores] = fattailed_garch(data , p , q , errors, startingvals, options)

    t = size(data,1);
    if nargin<6
        options=[];
    end

    if strcmp(errors,'NORMAL') || strcmp(errors,'STUDENTST') || strcmp(errors,'GED')
       if strcmp(errors,'NORMAL') 
          errortype = 1;
       elseif strcmp(errors,'STUDENTST') 
          errortype = 2;
       else
          errortype = 3;
       end
    else
       error('error must be one of the three strings NORMAL, STUDENTST, or GED');
    end

    if size(data,2) > 1
       error('Data series must be a column vector.')
    elseif isempty(data)
       error('Data Series is Empty.')
    end

    if (length(q) > 1) || any(q < 0)
       error('Q must ba a single positive scalar or 0 for ARCH.')
    end

    if (length(p) > 1) || any(p <  0)
       error('P must be a single positive number.')
    elseif isempty(p)
       error('P is empty.')
    end

    if isempty(q) || q==0
       q = 0;
       m = p;
    else
       m  =  max(p,q);   
    end

    if nargin<=4 || isempty(startingvals)
       alpha  = .15*ones(p,1)/p;
       beta   = .75*ones(q,1)/q;
       omega  = (1-(sum(alpha)+sum(beta)))*cov(data);  % set the uncond = to its expection
       if strcmp(errors,'STUDENTST')
          nu  = 30;
       elseif strcmp(errors,'GED')
          nu = 1.7;
       else
          nu = [];
       end
    else
       omega = startingvals(1);
       alpha = startingvals(2:p+1);
       beta  = startingvals(p+2:p+q+1);
       if strcmp(errors,'STUDENTST')
          nu  = startingvals(p+q+2);
       elseif strcmp(errors,'GED')
          nu = startingvals(p+q+2);
       else
          nu=[];
       end
    end

    UB   = [];     
    sumA = [-eye(1+p+q); ...
            0  ones(1,p)  ones(1,q)];
    sumB = [zeros(1+p+q,1); 1];                          

    if (nargin <= 5) || isempty(options)
       options  =  optimset('fmincon');
       options  =  optimset(options , 'TolFun'      , 1e-006);
       options  =  optimset(options , 'Display'     , 'iter');
       options  =  optimset(options , 'Diagnostics' , 'on');
       options  =  optimset(options , 'LargeScale'  , 'off');
       options  =  optimset(options , 'MaxFunEvals' , 400*(2+p+q));
    end

    sumB = sumB - [zeros(1+p+q,1); 1]*2*optimget(options, 'TolCon', 1e-6);

    if strcmp(errors,'STUDENTST')
       LB             = zeros(1,p+q+2);
       LB(length(LB)) = 2.1;
       n              = size(sumA,1);
       sumA           = [sumA'; zeros(1,n)]';
    elseif strcmp(errors,'GED')
       LB             = zeros(1,p+q+2);
       LB(length(LB)) = 1.1;
       n              = size(sumA,1);
       sumA           = [sumA';zeros(1,n)]';
    else
       LB = [];
    end

    if errortype == 1
       startingvals = [omega ; alpha ; beta];
    else
       startingvals = [omega ; alpha ; beta; nu];
    end

    % Estimate the parameters.
    stdEstimate = std(data,1);  
    data        = [stdEstimate(ones(m,1)) ; data];  
    T           = size(data,1);

    [parameters, ~, EXITFLAG, ~, ~, ~] =  fmincon('fattailed_garchlikelihood', startingvals ,sumA  , sumB ,[] , [] , LB , UB,[],options, data, p , q, errortype, stdEstimate^2, T);

    if EXITFLAG<=0
       fprintf(1,'Not Sucessful! \n')
    end

    parameters(parameters    <  0) = 0;          
    parameters(parameters(1) <= 0) = realmin;    
    hess = hessian_2sided('fattailed_garchlikelihood',parameters,data,p,q,errortype, stdEstimate^2, T);
    [likelihood, ht]=fattailed_garchlikelihood(parameters,data,p,q,errortype, stdEstimate^2, T);
    likelihood=-likelihood;
    stderrors=hess^(-1);

    if nargout > 4
       h                = max(abs(parameters/2),1e-2)*eps^(1/3);
       hplus            = parameters+h;
       hminus           = parameters-h;
       likelihoodsplus  = zeros(t,length(parameters));
       likelihoodsminus = zeros(t,length(parameters));
       for i=1:length(parameters)
          hparameters          = parameters;
          hparameters(i)       = hplus(i);
          [~, ~, indivlike]    = fattailed_garchlikelihood(hparameters,data,p,q,errortype, stdEstimate^2, T);
          likelihoodsplus(:,i) = indivlike;
       end
       for i = 1:length(parameters)
          hparameters           = parameters;
          hparameters(i)        = hminus(i);
          [~, ~, indivlike]     = fattailed_garchlikelihood(hparameters,data,p,q,errortype, stdEstimate^2, T);
          likelihoodsminus(:,i) = indivlike;
       end
       scores   = (likelihoodsplus-likelihoodsminus)./(2*repmat(h',t,1));
       scores   = scores-repmat(mean(scores),t,1);
       B        = scores'*scores;
       robustSE = stderrors*B*stderrors;
    end
end
%
% Author's Comments
%
% PURPOSE:
%     FATTAILED_GARCH(P,Q) parameter estimation with different error distributions, the NOrmal, The T, 
%           and the Generalized Error Distribution
% 
% USAGE:
%     [parameters, likelihood, stderrors, robustSE, ht, scores] = fattailed_garch(data , p , q , errors, startingvals, options)
% 
% INPUTS:
%     data: A single column of zero mean random data, normal or not for quasi likelihood
% 
%     P: Non-negative, scalar integer representing a model order of the ARCH 
%       process
% 
%     Q: Positive, scalar integer representing a model order of the GARCH 
%       process: Q is the number of lags of the lagged conditional variances included
%       Can be empty([]) for ARCH process
% 
%     error:  The type of error being assumed, valid types are:
%            'NORMAL' - Gaussian Innovations
%            'STUDENTST' - T-distributed errors
%            'GED' - General Error Distribution
%  
%     startingvals: A (1+p+q) (plus 1 if STUDENTT OR GED is selected for the nu parameter) vector of starting vals.
%       If you do not provide, a naieve guess of 1/(2*max(p,q)+1) is used for the arch and garch parameters,
%       and omega is set to make the real unconditional variance equal
%       to the garch expectation of the expectation.
% 
%     options: default options are below.  You can provide an options vector.  See HELP OPTIMSET
% 
% OUTPUTS:
%     parameters : a [1+p+q X 1] column of parameters with omega, alpha1, alpha2, ..., alpha(p)
%                  beta1, beta2, ... beta(q)
% 
%     likelihood = the loglikelihood evaluated at he parameters
% 
%     robustSE = QuasiLikelihood std errors which are robust to some forms of misspecification(see White 94)
% 
%     stderrors = the inverse analytical hessian, not for quasi maximum liklihood
% 
%     ht = the estimated time varying VARIANCES
% 
%     scores = The numberical scores(# fo params by t) for M testing   
% 
% 
% COMMENTS:
%   GARCH(P,Q) the following(wrong) constratins are used(they are right for the (1,1) case or any Arch case
%     (1) Omega > 0
%     (2) Alpha(i) >= 0 for i = 1,2,...P
%     (3) Beta(i)  >= 0 for i = 1,2,...Q
%     (4) sum(Alpha(i) + Beta(j)) < 1 for i = 1,2,...P and j = 1,2,...Q
%     (5) nu>2 of Students T and nu>1 for GED
%
%   The time-conditional variance, H(t), of a GARCH(P,Q) process is modeled 
%   as follows:
%
%     H(t) = Omega + Alpha(1)*r_{t-1}^2 + Alpha(2)*r_{t-2}^2 +...+ Alpha(P)*r_{t-p}^2+...
%                    Beta(1)*H(t-1)+ Beta(2)*H(t-2)+...+ Beta(Q)*H(t-q)
%
%   Default Options
%   
%   options  =  optimset('fmincon');
%   options  =  optimset(options , 'TolFun'      , 1e-003);
%   options  =  optimset(options , 'Display'     , 'iter');
%   options  =  optimset(options , 'Diagnostics' , 'on');
%   options  =  optimset(options , 'LargeScale'  , 'off');
%   options  =  optimset(options , 'MaxFunEvals' , '400*numberOfVariables');
%
%
%  uses fFATTAILED_GARCHLIKELIHOOD and GARCHCORE.  You should MEX, mex 'path\garchcore.c', the MEX source 
%  The included MEX is for R12 Windows and was compiled with VC++6. It
%  gives a 10-15 times speed improvement
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function [LLF, h, likelihoods] = fattailed_garchlikelihood(parameters , data , p , q, errortype, stdEstimate, T)

    [r,c]=size(parameters);
    if c>r
        parameters=parameters';
    end

    parameters(parameters <= 0) = realmin;

    if errortype ~=1;
        nu = parameters(p+q+2);
        parameters = parameters(1:p+q+1);
    end

    if isempty(q)
        m=p;
    else
        m  =  max(p,q);   
    end

    h   = garchcore(data,parameters,stdEstimate^2,p,q,m,T);
    Tau = T-m;
    t   = (m + 1):T;
    if errortype == 1
        LLF = sum(log(h(t))) + sum((data(t).^2)./h(t));
        LLF = 0.5 * (LLF  +  (T - m)*log(2*pi));
    elseif errortype == 2
        LLF = Tau*gammaln(0.5*(nu+1)) - Tau*gammaln(nu/2) - Tau/2*log(pi*(nu-2));
        LLF = LLF - 0.5*sum(log(h(t))) - ((nu+1)/2)*sum(log(1 + (data(t).^2)./(h(t)*(nu-2)) ));
        LLF = -LLF;
    else
        Beta = (2^(-2/nu) * gamma(1/nu)/gamma(3/nu))^(0.5);
        LLF  = (Tau * log(nu)) - (Tau*log(Beta)) - (Tau*gammaln(1/nu)) - Tau*(1+1/nu)*log(2);
        LLF  = LLF - 0.5 * sum(log(h(t))) - 0.5 * sum((abs(data(t)./(sqrt(h(t))*Beta))).^nu);
        LLF  = -LLF;
    end

    if nargout >1
        if nargout > 2
            if errortype == 1
                likelihoods = 0.5 * ((log(h(t))) + ((data(t).^2)./h(t)) + log(2*pi));
                likelihoods = -likelihoods;
            elseif errortype == 2
                likelihoods = gammaln(0.5*(nu+1)) - gammaln(nu/2) - 1/2*log(pi*(nu-2))...
                    - 0.5*(log(h(t))) - ((nu+1)/2)*(log(1 + (data(t).^2)./(h(t)*(nu-2)) ));
                likelihoods = -likelihoods;
            else
                Beta        = (2^(-2/nu) * gamma(1/nu)/gamma(3/nu))^(0.5);
                likelihoods = (log(nu)/(Beta*(2^(1+1/nu))*gamma(1/nu))) - 0.5 * (log(h(t))) ...
                    - 0.5 * ((abs(data(t)./(sqrt(h(t))*Beta))).^nu);
                likelihoods = -likelihoods;
            end
        end
        h = h(t);
    end
end
% 
% Author's Comments
% 
% PURPOSE:
%     Likelihood for fattailed garch estimation
% 
% USAGE:
%     [LLF, h, likelihoods] = fattailed_garchlikelihood(parameters , data , p , q, errortype, stdEstimate, T)
% 
% INPUTS:
%     parameters:   A vector of GARCH process aprams of the form [constant, arch, garch]
%     data:         A set of zero mean residuals
%     p:            The lag order length for ARCH
%     q:            The lag order length for GARCH
%     m:            The max of p and q
%     error:        The type of error being assumed, valid types are:
%                   1 if 'NORMAL'
%                   2 if 'STUDENTST' 
%                   3 if 'GED' 
%     stdEstimate:  The std deviation of the data
%     T:             Length of data
% 
% OUTPUTS:
%     LLF:          Minus 1 times the log likelihood
%     h:            Time series of conditional volatilities
%     likelihoods   Time series of likelihoods
% 
% COMMENTS:
%     This is a helper function for garchinmean
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function h = garchcore(data,parameters,covEst,p,q,m,T)

    h      = zeros(size(data));
    h(1:m) = covEst;
    for t = (m + 1):T
       h(t) = parameters' * [1 ; data(t-(1:p)).^2;  h(t-(1:q)) ];
    end
end
% Author's Comments
% 
% PURPOSE:
%     Forward recursion to construct h's
% 
% USAGE:
%     h=garchcore(data,parameters,covEst,p,q,m,T);
% 
% INPUTS:
%     See garchlikelihood
% 
% OUTPUTS:
%     See garchlikelihood
% 
% COMMENTS:
%     Helper function part of UCSD_GARCH toolbox. Used if you do not use the MEX file.
%     You should use the MEX file.
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function H = hessian_2sided(f,x,varargin)

    try
        feval(f,x,varargin{:});
    catch
        error('There was an error evaluating the function.  Please check the arguements.');
    end

    n  = size(x,1);
    fx = feval(f,x,varargin{:});

    % Compute the stepsize (h)
    h  = eps.^(1/3)*max(abs(x),1e-2);
    xh = x+h;
    h  = xh-x;    
    ee = sparse(1:n,1:n,h,n,n);

    % Compute forward and backward steps
    gp = zeros(n,1);
    for i = 1:n
        gp(i) = feval(f,x+ee(:,i),varargin{:});
    end
    gm = zeros(n,1);
    for i = 1:n
        gm(i) = feval(f,x-ee(:,i),varargin{:});
    end

    H  = h*h';
    Hm = H;
    Hp = H;
    % Compute "double" forward and backward steps
    for i = 1:n
        for j       = i:n
            Hp(i,j) = feval(f,x+ee(:,i)+ee(:,j),varargin{:});
            Hp(j,i) = Hp(i,j);
            Hm(i,j) = feval(f,x-ee(:,i)-ee(:,j),varargin{:});
            Hm(j,i) = Hm(i,j);        
        end
    end

    % Compute the hessian
    for i = 1:n
        for j=i:n
            H(i,j) = (Hp(i,j)-gp(i)-gp(j)+fx+fx-gm(i)-gm(j)+Hm(i,j))/H(i,j)/2;
            H(j,i) = H(i,j);
        end
    end
end
% 
% Author's Comments
%
% PURPOSE: 
%      Computes 2-sided finite difference Hessian
%
% USAGE:  
%      H = hessian_2sided(func,x,varargin)
%
% INPUTS:
%      func         - function name, fval = func(x,varargin)
%      x            - vector of parameters (n x 1)
%      varargin     - optional arguments passed to the function
%
% OUTPUTS:
%      H            - finite differnce, 2-sided hessian
%
% COMMENTS:
%      Code originally from COMPECON toolbox [www4.ncsu.edu/~pfackler]
%      documentation modified to fit the format of the Ecoometrics Toolbox
%      by James P. LeSage, Dept of Economics
%      University of Toledo
%      2801 W. Bancroft St,
%      Toledo, OH 43606
%      jlesage@spatial-econometrics.com
%
% Further modified (to do 2-sided numerical derivs, rather than 1)
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function trandformeddata = vech(x)

    trandformeddata = x(logical(tril(ones(size(x)))));
end
% 
% Author's Comments
% 
% PURPOSE:
%        Transform a k by k matrix into a vector of size k*(k+1)/2 by 1, complements ivech
% 
% USAGE:
%      transformeddata=vech(data)
% 
% 
% INPUTS:
%      data:   A k by k matrix
% 
% 
% OUTPUTS:
%      transformeddata - a k*(k+1)/2 by 1 vector for the form
%        [data(1,1) data(2,1) ... data(k,1)
%        data(2,2)...data(k,2)...data(k,k)]'
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function [LLF,likelihoods,Ht]=scalar_bekk_mvgarch_likelihood(parameters,errors,p,q,k,k2,t)

    %The first k(k+1)/2 parameters are C, the next p are A, and the next q are B
    C = parameters(1:(k2));
    A = parameters(k2+1:k2+p);
    B = parameters(k2+p+1:k2+p+q);

    C     = ivech(C);
    C     = tril(C);
    const = C*C';

    uncond = cov(errors);
    
    % for starting up, both ee' and H have expectation uncond.  We can leverage this to help the loops.
    m       = max(p,q);
    eeprime = zeros(k,k,t+m);
    Ht      = zeros(k,k,t+m);
    for i = 1:m
        eeprime(:,:,i) = uncond;
        Ht(:,:,i)      = uncond;
    end
    LLF         = 0;
    errors      = [repmat(sqrt(diag(uncond))',m,1);errors];
    likelihoods = zeros(t+m,1);
    for i = m+1:t+m;
        Ht(:,:,i) = const;
        for j = 1:p
             Ht(:,:,i) = Ht(:,:,i)+A(j)*(errors(i-j,:))'*(errors(i-j,:))*A(j);
        end
        for j = 1:q
             Ht(:,:,i) = Ht(:,:,i)+B(j)*Ht(:,:,i-j)*B(j);
        end
        likelihoods(i) = k*log(2*pi)+(log(det(Ht(:,:,i)))+errors(i,:)*Ht(:,:,i)^(-1)*errors(i,:)');
        LLF            = LLF + likelihoods(i);
    end
    LLF         = 0.5*(LLF);
    likelihoods = 0.5*likelihoods(m+1:t+m);
    Ht          = Ht(:,:,m+1:t+m);
    if isnan(LLF)
        LLF = 1e6;
    end
end
%
% Author's Comments
% 
% PURPOSE:
%      To Estimate a scalar BEKK multivariate GARCH likelihood.
% 
% 
% USAGE:
%      [LLF,likelihoods,Ht]=scalar_bekk_mvgarch_likelihood(parameters,errors,p,q,k,k2,t);
% 
% 
% INPUTS:
%      parameters - a k*(k+1)/2 + p +q vector of model parameters of the form
%                   [ivech(C);(A(1));...;(A(p));(B(1)); ...(B(q))]
%      errors     - A zeromean t by k martix of residuals
%      p          - The lag length of the innovation process
%      q          - The lag length of the AR process
%      k          - The number of data series
%      k2         - k*k
%      t          - the length of the data series
% 
% 
% OUTPUTS:
%      LLF           - The loglikelihood of the function at the optimum
%      Ht            - A k x k x t 3 dimension matrix of conditional covariances
%      likelihoods   - A t by 1 vector of individual likelihoods
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function transformeddata = ivech(data)

    t               = size(data,1);
    sizeout         = (-1+sqrt(1+8*t))/2;
    transformeddata = zeros(sizeout);
    index           = 1;

    for i = 1:sizeout
        for j = i:sizeout
            transformeddata(j,i) = data(index);
            index                = index + 1;
        end
    end
end
%
% Author's Comments
%
% PURPOSE:
%     Transform a vector in to a lower triangular matrix for use by MVGARCH, complements vech
% 
% USAGE:
%     transformeddata=ivech(data)
% 
% INPUTS:
%     data:   A m by 1 vector to be transformed to a square k by k matrix.  
%            M must ba solution to the equation k^1+k-2*m=0
% 
% OUTPUTS:
%     transformeddata - a k by k lower matrix of the form 
% 
% COMMENTS:
%        [ data(1)   0           0   ...      0
%          data(2) data(k+1)     0   ...      0
%          data(3) data(k+2) data(2k) 0 ...   0
%              ...   ....      . ...    ....
%          data(k) data(2k-1) ...     data(m-1)    data(m) ]
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function [LLF,likelihoods,Ht] = full_bekk_mvgarch_likelihood(parameters,errors,p,q,k,k2,t)

    %The first k(k+1)/2 parameters are C, the next p are A, and the next q are B
    C = parameters(1:(k2));
    A = parameters(k2+1:k2+k*k*p);
    B = parameters(k2+k*k*p+1:k2+k*k*p+k*k*q);
    
    tempA = zeros(k,k,p);
    tempB = zeros(k,k,p);
    
    for i = 1:p
        tempA(:,:,i) = reshape(A((k*k*(i-1)+1):(k*k*i)),k,k);
    end
    for i = 1:q
        tempB(:,:,i) = reshape(B((k*k*(i-1)+1):(k*k*i)),k,k);
    end
    A = tempA;
    B = tempB;

    C     = ivech(C);
    C     = tril(C);
    const = C*C';

    uncond = cov(errors);
    % for starting up, both ee' and H have expectation uncond. We can leverage this to help the loops.
    m       = max(p,q);
    eeprime = zeros(k,k,t+m);
    Ht      = zeros(k,k,t+m);
    for i=1:m
        eeprime(:,:,i) = uncond;
        Ht(:,:,i)      = uncond;
    end

    LLF         = 0;
    errors      = [repmat(sqrt(diag(uncond))',m,1);errors];
    likelihoods = zeros(t+m,1);
    for i = m+1:t+m;
        Ht(:,:,i) = const;
        for j = 1:p
            Ht(:,:,i) = Ht(:,:,i) + A(:,:,j)*(errors(i-j,:))'*(errors(i-j,:))*A(:,:,j)';
        end
        for j = 1:q
            Ht(:,:,i)=Ht(:,:,i) + B(:,:,j)*Ht(:,:,i-j)*B(:,:,j)';
        end
        likelihoods(i) = k*log(2*pi)+(log(det(Ht(:,:,i)))+errors(i,:)*Ht(:,:,i)^(-1)*errors(i,:)');
        LLF            = LLF + likelihoods(i);
    end
    LLF         = 0.5*(LLF);
    likelihoods = 0.5*likelihoods(m+1:t+m);
    Ht          = Ht(:,:,m+1:t+m);
    if isnan(LLF)
        LLF = 1e6;
    end
end
%
% Author's Comments
%
% PURPOSE:
%      To Estimate a full BEKK multivariate GARCH likelihood.
% 
% USAGE:
%      [LLF,likelihoods,Ht]=full_bekk_mvgarch_likelihood(parameters,errors,p,q,k,k2,t);
% 
% INPUTS:
%      parameters - a k*(k+1)/2 + k^2 *p +k^2*q vector of model parameters of the form
%                   [ivech(C);reshape(A(1),k*k,1);...;reshape(A(p),k*k,1);reshape(B,k*k,1); ...
%                     reshape(B(q),k*k,1)]
%      errors     - A zeromean t by k martix of residuals
%      p          - The lag length of the innovation process
%      q          - The lag length of the AR process
%      k          - The number of data series
%      k2         - k*k
%      t          - the length of the data series
% 
% OUTPUTS:
%      LLF           - The loglikelihood of the function at the optimum
%      Ht            - A k x k x t 3 dimension matrix of conditional covariances
%      likelihoods   - A t by 1 vector of individual likelihoods
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function [parameters, loglikelihood, Ht, likelihoods, stdresid, stderrors, A, B, scores]  = full_bekk_mvgarch(data,p,q, BEKKoptions)

    % need to try and get some smart startgin values
    if size(data,2) > size(data,1)
        data = data';
    end

    [t, k] = size(data);
    k2     = k*(k+1)/2;

    scalaropt          = optimset('fminunc');
    scalaropt          = optimset(scalaropt,'TolFun',1e-1,'Display','iter','Diagnostics','on','DiffMaxChange',1e-2);
    startingparameters = scalar_bekk_mvgarch(data,p,q,scalaropt);
    CChol              = startingparameters(1:(k*(k+1))/2);
    % C=ivech(startingparameters(1:(k*(k+1))/2))*ivech(startingparameters(1:(k*(k+1))/2))';
    newA = [];
    newB = [];
    for i = 1:p
        newA = [newA diag(ones(k,1))*startingparameters(((k*(k+1))/2)+i)];
    end
    for i = 1:q
        newB = [newB diag(ones(k,1))*startingparameters(((k*(k+1))/2)+i+p)]; 
    end
    newA               = reshape(newA,k*k*p,1);
    newB               = reshape(newB,k*k*q,1);
    startingparameters = [CChol;newA;newB];

    if nargin<=3 || isempty(BEKKoptions)
        options=optimset('fminunc');
        options.Display='iter';
        options.Diagnostics='on';
        options.TolX=1e-4;
        options.TolFun=1e-4;
        options.MaxFunEvals=5000*length(startingparameters);
        options.MaxIter=5000*length(startingparameters);   
    else
        options=BEKKoptions;
    end
    parameters = fminunc('full_bekk_mvgarch_likelihood',startingparameters,options,data,p,q,k,k2,t);

    [loglikelihood,likelihoods,Ht] = full_bekk_mvgarch_likelihood(parameters,data,p,q,k,k2,t);
    loglikelihood                  = -loglikelihood;
    likelihoods                    = -likelihoods;

    % Standardized residuals
    stdresid=zeros(size(data));
    for i = 1:t
        stdresid(i,:) = data(i,:)*Ht(:,:,i)^(-0.5);
    end

    % Std Errors
    if nargout>=6
        A                = hessian_2sided('full_bekk_mvgarch_likelihood',parameters,data,p,q,k,k2,t);
        h                = max(abs(parameters/2),1e-2)*eps^(1/3);
        hplus            = parameters+h;
        hminus           = parameters-h;
        likelihoodsplus  = zeros(t,length(parameters));
        likelihoodsminus = zeros(t,length(parameters));
        for i = 1:length(parameters)
            hparameters          = parameters;
            hparameters(i)       = hplus(i);
            [~, indivlike]       = full_bekk_mvgarch_likelihood(hparameters,data,p,q,k,k2,t);
            likelihoodsplus(:,i) = indivlike;
        end
        for i = 1:length(parameters)
            hparameters           = parameters;
            hparameters(i)        = hminus(i);
            [~, indivlike]        = full_bekk_mvgarch_likelihood(hparameters,data,p,q,k,k2,t);
            likelihoodsminus(:,i) = indivlike;
        end
        scores    = (likelihoodsplus-likelihoodsminus)./(2*repmat(h',t,1));
        B         = cov(scores);
        A         = A/t;
        stderrors = A^(-1)*B*A^(-1)*t^(-1);
    end
end
%
% Author's Comments
% 
% PURPOSE:
%      To Estimate a full BEKK multivariate GARCH model.  ****SEE WARNING AT END OF HELP FILE****
% 
% 
% USAGE:
%      [parameters, loglikelihood, Ht, likelihoods, stdresid, stderrors, A, B, scores]  = full_bekk_mvgarch(data,p,q,options);
% 
% 
% INPUTS:
%      data          - A t by k matrix of zero mean residuals
%      p             - The lag length of the innovation process
%      q             - The lag length of the AR process
%      options       - (optional) Options for the optimization(fminunc)
% 
% OUTPUTS:
%      parameters    - A (k*(k+1))/2+p*k^2+q*k^2 vector of estimated parameteters. F
%                         or any k^2 set of Innovation or AR parameters X, 
%                         reshape(X,k,k) will give the correct matrix
%                         To recover C, use ivech(parmaeters(1:(k*(k+1))/2)
%      loglikelihood - The loglikelihood of the function at the optimum
%      Ht            - A k x k x t 3 dimension matrix of conditional covariances
%      likelihoods   - A t by 1 vector of individual likelihoods
%      stdresid      - A t by k matrix of multivariate standardized residuals
%      stderrors     - A numParams^2 square matrix of robust Standad Errors(A^(-1)*B*A^(-1)*t^(-1))
%      A             - The estimated inverse of the non-robust Standard errors
%      B             - The estimated covariance of teh scores
%      scores        - A t by numParams matrix of individual scores
% -------------------------------------------------------------------------

%% -------------------------------------------------------------------------
function [parameters, loglikelihood, Ht, likelihoods, stdresid, stderrors, A, B, scores] = scalar_bekk_mvgarch(data,p,q,BEKKoptions)

    % need to try and get some smart startgin values
    if size(data,2) > size(data,1)
        data=data';
    end

    [t, k]                     = size(data);
    garchmat                   = zeros(k,1+p+q);
    options                    = optimset('fmincon');
    options.TonCon             = 1e-3;
    options.Display            = 'off';
    options.Diagnostics        = 'off';
    options.LargeScale         = 'off';
    options.LevenbergMarquardt = 'on';
    
    for i = 1:k
        temparam      = fattailed_garch(data(:,i),p,q,'NORMAL',[],options);
        garchmat(i,:) = temparam';
    end

    A      = mean(garchmat(:,2:p+1));
    B      = mean(garchmat(:,p+2:p+q+1));
    C      = cov(data);
    alpha0 = sqrt(A);
    beta0  = sqrt(B);

    StartC = C*(1-sum(alpha0.^2)-sum(beta0.^2));
    CChol  = chol(StartC)';
    warning off
    startingparameters = [vech(CChol);alpha0;beta0];

    k2 = k*(k+1)/2;
    if nargin<=3 || isempty(BEKKoptions)
        options             = optimset('fminunc');
        options.Display     = 'iter';
        options.Diagnostics = 'on';
    else
        options = BEKKoptions;
    end

    parameters                     = fminunc('scalar_bekk_mvgarch_likelihood',startingparameters,options,data,p,q,k,k2,t);
    [loglikelihood,likelihoods,Ht] = scalar_bekk_mvgarch_likelihood(parameters,data,p,q,k,k2,t);
    loglikelihood                  = -loglikelihood;
    likelihoods                    = -likelihoods;
    stdresid                       = zeros(size(data));
    for i = 1:t
        stdresid(i,:) = data(i,:)*Ht(:,:,i)^(-0.5);
    end

    % Std Errors
    if nargout>=6
        A                = hessian_2sided('scalar_bekk_mvgarch_likelihood',parameters,data,p,q,k,k2,t);
        h                = max(abs(parameters/2),1e-2)*eps^(1/3);
        hplus            = parameters+h;
        hminus           = parameters-h;
        likelihoodsplus  = zeros(t,length(parameters));
        likelihoodsminus = zeros(t,length(parameters));
        for i = 1:length(parameters)
            hparameters=parameters;
            hparameters(i)=hplus(i);
            [~, indivlike]       = scalar_bekk_mvgarch_likelihood(hparameters,data,p,q,k,k2,t);
            likelihoodsplus(:,i) = indivlike;
        end
        for i = 1:length(parameters)
            hparameters           = parameters;
            hparameters(i)        = hminus(i);
            [~, indivlike]        = scalar_bekk_mvgarch_likelihood(hparameters,data,p,q,k,k2,t);
            likelihoodsminus(:,i) = indivlike;
        end
        scores    = (likelihoodsplus-likelihoodsminus)./(2*repmat(h',t,1));
        B         = cov(scores);
        A         = A/t;
        stderrors = A^(-1)*B*A^(-1)*t^(-1);
    end
end
% 
% Author's Comments
% 
% PURPOSE:
%      To Estimate a scalar BEKK multivariate GARCH model.  ****SEE WARNING AT END OF HELP FILE****
% 
% 
% USAGE:
%      [parameters, loglikelihood, Ht, likelihoods, stdresid, stderrors, A, B, scores]  = scalar_bekk_mvgarch(data,p,q,options);
% 
% 
% INPUTS:
%      data          - A t by k matrix of zero mean residuals
%      p             - The lag length of the innovation process
%      q             - The lag length of the AR process
%      options       - (optional) Options for the optimization(fminunc)
% 
% 
% OUTPUTS:
%      parameters    - A (k*(k+1))/2+p+q vector of estimated parameteters. 
%                         To recover C, use ivech(parmaeters(1:(k*(k+1))/2)
%      loglikelihood - The loglikelihood of the function at the optimum
%      Ht            - A k x k x t 3 dimension matrix of conditional covariances
%      likelihoods   - A t by 1 vector of individual likelihoods
%      stdresid      - A t by k matrix of multivariate standardized residuals
%      stderrors     - A numParams^2 square matrix of robust Standad Errors(A^(-1)*B*A^(-1)*t^(-1))
%      A             - The estimated inverse of the non-robust Standard errors
%      B             - The estimated covariance of the scores
%      scores        - A t by numParams matrix of individual scores
% -------------------------------------------------------------------------


