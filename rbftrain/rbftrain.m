
function [inp,net,err,rbf] = rbftrain(x,y,clusters,learn,epochs,mMSE,activ)


  if(size(x,1) ~= size(y,1))
  	error('rbftrain: rows(x) <> rows(y)');
  end
  if(clusters<2)
  	error('rbftrain: clusters < 2');
  end
  if((size(learn,2) > 1)||(size(learn,1) ~= 3))
  	error('rbftrain: learn must be (3x1) vector');
  end
  if(sum(learn) <= 0||sum(learn) >= 1)
  	error('rbftrain: each parameter of learn must be from (0,1)');
  end
  if((size(epochs,2) > 1)||(size(epochs,1)~=2))
  	error('rbftrain: epochs must be (2x1) vector');
  end
  if(sum(epochs) < 1)
  	error('rbftrain: epochs < 1');
  end
  if(mMSE <= 0)
  	error('rbftrain: mMSE must be positive');
  end
  if(exist('activ') == 0)
  	activ = 0;
  end
  if((activ~=0)&&(activ~=1))
  	error('rbftrain: activ must be 0 or 1');
  end

% set parameters
  inputs    = size(x,2);      % dimension of the signal
  outputs   = size(y,2);      % number of output units
  samples   = size(x,1);      % number of observations

  interimLR = 1;			% initialize the learning rate
  
% unsupervised learning
%======================

% declare arrays
  clustersOutput   = ones(clusters,1);       % output signal from the cluster nodes
  clustersWeights  = unifrnd(0,1,clusters,inputs);     % centers of the clusters
  trFonDev         = zeros(clusters,1);       % deviance of the transfer function

% normalize
  minx = min(x);
  maxx = max(x);
  miny = min(y);		% used in the supervised learning also
  maxy = max(y);		%		- || -
  if(sum((maxx==minx))>0)
     error('rbftrain: x has a constant variable')
  end
  if(sum((maxy==miny))>0)
     error('rbftrain: y has a constant variable')
  end
  x = (x - repmat(minx,size(x,1),1)) ./ (repmat(maxx,size(x,1),1) - repmat(minx,size(x,1),1));
  y = (y - repmat(miny,size(y,1),1)) ./ (repmat(maxy,size(y,1),1) - repmat(miny,size(x,1),1));
  
% train the clusters
  e1 = 1;
  while(e1<=epochs(1))
    i = 1;
    while(i<=samples)
% find the nearest cluster
      X = repmat(x(i,:),clusters,1);
      clustersOutput = sqrt( sum((clustersWeights - X).*(clustersWeights - X),2) );	% eucl. distance: i-th point from cluster centers
      tmp = (1:clusters) .* (clustersOutput == min(clustersOutput))'; % choose the nearest cluster
      tmp = tmp(find(tmp > 0));
      clusterChamp = tmp(1);			% just in case of multiple minima
      
% update weights of the nearest cluster
      clustersWeights(clusterChamp,:) = clustersWeights(clusterChamp,:) + (interimLR * (x(i,:)-clustersWeights(clusterChamp,:)));
      i = i+1;
    end  % while(i<=samples)

    interimLR = (learn(2) - (learn(2)-learn(1))/max(1,(epochs(1)-1))*(e1-1))  *  interimLR;	%//!!! was above 'clustersWeights[clusterChamp,] = ...'
    if(interimLR == 0)		%// set to a small number ???
      e1 = epochs(1) + 1;
    end
    e1 = e1+1;
  end  % while(e1<=epochs[1])
  
% calculate standard deviation of the transfer function
  c = 1;
  while(c<=clusters)
    W = repmat(clustersWeights(c,:),clusters,1);
    trFonDev(c) = sum(sum((W - clustersWeights).*(W - clustersWeights)));	% sum of distances of the center c from other centres
    trFonDev(c) = sqrt(trFonDev(c) / (clusters-1));
    c = c+1;
  end

% supervised learning
%====================

% declare arrays
  gaussOut          = ones(clusters,1);                     % output of the Gaussian function of each cluster
  outputsWeights    = 2*unifrnd(0,1,outputs,clusters) - 1;  % weights of the output layer
  outWeightsCorrect = ones(outputs,clusters);               % correction weights
  bias              = 2*unifrnd(0,1,outputs,1) - 1;         % bias of each output node
  maxDiff           = -1*ones(epochs(2),outputs);           % max difference of each output node in each epoch
  meanDiff          = zeros(epochs(2),outputs);             % mean          ---  |  |  ---
  MSE               = zeros(epochs(2),1);                   % mean squared error for each epoch
  aMSE              = +Inf;                                 % actual mean squared error

  e2 = 1;
  while(e2<=epochs(2))
    i = 1;
    while(i<=samples)
      outError = 0;			% error of this output unit
      
% calculate the Gaussian output of clusters
      X = repmat(x(i,:),clusters,1);
      clustersOutput = sqrt( sum((clustersWeights - X).*(clustersWeights - X),2) );	% euclidean distance      
      gaussOut = exp( -(clustersOutput ./ trFonDev).^2  );
% calculate output signals and their derivative for each cluster
      G = ones(outputs,1) * (gaussOut)';
      sumOfWeightedInputs = sum(outputsWeights .* G) + bias;	% lin. comb. of the inputs and weights of the output layer
      if(~activ)  % binary sigmoid function
        outputSignal = 1 ./ ( 1+exp(-sumOfWeightedInputs) );
        outSigDeriv  = outputSignal .* (1 - outputSignal);  % first derivative of the output signal
      else       % bipolar sigmoid function
        outputSignal = 2 ./ ( 1+exp(-sumOfWeightedInputs) ) - 1;
        outSigDeriv  = 0.5 * (1 + outputSignal) .* (1 - outputSignal); % first derivative of the output signal
      end

% calculate output errors
      errInfoTerm   = ((y(i,:))' - outputSignal) .* outSigDeriv;
%      
      realErrDiff   = abs((y(i,:))' - outputSignal) .* ((maxy)' - (miny)'); % it was normalized
      outError      = sum(realErrDiff.^2);             % instantaneous SSE (Haykin, 1994)
      
      meanDiff(e2,:)= meanDiff(e2,:) + (realErrDiff)' / samples;
      tmp = realErrDiff > (maxDiff(e2,:))';          % save the max. real error into maxDiff
      if(sum(tmp)>0)
        tmp = (1:outputs) .* tmp;
        ind = tmp(find(tmp>0));
        maxDiff(e2,ind) = (realErrDiff(ind))';
      end

      MSE(e2) = MSE(e2) + outError ./ samples;
% correct weights and bias
      outWeightsCorrect = learn(3) * errInfoTerm * (gaussOut)';
      outputsWeights    = outputsWeights + outWeightsCorrect; % correct the output weights
      bias = bias + learn(3) .* errInfoTerm;  % correct bias 

      i = i+1;
    end  % while(i<=samples)

    if(MSE(e2) < aMSE)
      aMSE = MSE(e2);
    end
    if(aMSE <= mMSE)
      br = e2;
      e2 = epochs(2) + 1;
    end

    e2 = e2 + 1;
  end  % while(e2<=epochs[2])
  
% give some info sprintf('rho is %6.3f',(1+sqrt(5))/2)
  disp(sprintf(' An %.0f - %.0f - %.0f RBF-network',inputs,clusters,outputs));
  disp(sprintf(' training epochs: %.0f - %.0f',epochs(1),epochs(2)));
  disp(sprintf(' clusters learning rates: %.4f - %.4f',learn(2),learn(1)));
  disp(sprintf(' outputs learning rate: %.4f',learn(3)));
  disp(sprintf(' minimum mean squared error: %.3f',mMSE));
  if(~activ)  % binary
    disp(' BINARY sigmoid activation function');
  else       % bipolar
    disp(' BIPOLAR sigmoid activation function');
  end
  if(e2 == epochs(2)+2) % break used
    disp(sprintf(' mMSE reached in the epoch: %5.0f',br));
  else
    disp(sprintf(' minimum MSE reached: %.3f',aMSE));
  end
  

  inp.inputs=inputs;
  inp.clusters = clusters;
  inp.outputs = outputs;
  inp.samples = samples;
  inp.learn = learn;
  inp.epochs = epochs;
  inp.mMSE = mMSE;
  inp.activ = activ;
  net.clustersWeights = clustersWeights;
  net.trFonDev = trFonDev;
  net.outputsWeights = outputsWeights;
  net.bias = bias;
  % (clusters,inputs), (clusters), (outputs,clusters), (outputs)
  err.MSE = MSE;
  err.maxDiff = maxDiff;
  err.meanDiff = meanDiff; % (epochs[2],1), (epochs[2],outputs), (epochs[2],outputs)
  
  rbf.inp.inputs = inputs;
  rbf.inp.clusters = clusters;
  rbf.inp.outputs = outputs;
  rbf.inp.samples = samples;
  rbf.inp.learn = learn;
  rbf.inp.epochs = epochs;
  rbf.inp.mMSE = mMSE;
  rbf.inp.activ = activ;
  rbf.net.clustersWeights = clustersWeights;
  rbf.net.trFonDev = trFonDev;
  rbf.net.outputsWeights = outputsWeights;
  rbf.net.bias = bias;
  % (clusters,inputs), (clusters), (outputs,clusters), (outputs)
  rbf.err.MSE = MSE;
  rbf.err.maxDiff = maxDiff;
  rbf.err.meanDiff = meanDiff; % (epochs[2],1), (epochs[2],outputs), (epochs[2],outputs)

end


