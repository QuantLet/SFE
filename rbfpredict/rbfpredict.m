
function [netOut] = rbfpredict(x,rbf,miny,maxy)


% set parameters

  if(sum(miny >= maxy) > 0)
     error('rbfpredict: miny >= maxy');
  end

  samples          = size(x,1);               % number of observations
  clustersWeights  = rbf.net.clustersWeights; % centers of the clusters
  trFonDev         = rbf.net.trFonDev;        % deviance of the transfer function
  outputsWeights   = rbf.net.outputsWeights;  % weights of the output layer
  bias             = rbf.net.bias;            % bias of each output node
  activ            = rbf.inp.activ;           % activation function
  clusters         = size(clustersWeights,1); % number of clusters used in rbfnet
  inputs           = size(clustersWeights,2); % dimension of the signal of the net
  outputs          = size(outputsWeights,1);  % number of output units
  
  if(inputs~=size(x,2))
  	error('rbfpredict: columns(x) <> dimension of the input of rbfnet')
  end
  if(outputs~=size(miny,1))
  	error('rbfpredict: rows(miny) <> dimension of the output of rbfnet')
  end
  if(outputs~=size(maxy,1))
  	error('rbfpredict: rows(maxy) <> dimension of the output of rbfnet')
  end

  outputSignal = ones(samples,outputs);	% normalized output of the network
  
% normalize
  minx = min(x);
  maxx = max(x);
  if(sum((maxx==minx))>0)
  	error('rbftest: x has a constant variable')
  end
  x = (x - repmat(minx,size(x,1),1)) ./ (repmat(maxx,size(x,1),1) - repmat(minx,size(x,1),1));

  i = 1;
  while(i<=samples)
% calculate the Gaussian output of clusters
    X = repmat(x(i,:),clusters,1);
    clustersOutput = sqrt( sum((clustersWeights - X).*(clustersWeights - X),2) );	% euclidean distance      
    gaussOut = exp( -(clustersOutput ./ trFonDev).^2  );
% calculate output signals of each cluster
    G = ones(outputs,1) * (gaussOut)';
    sumOfWeightedInputs = sum(outputsWeights .* G,2) + bias;	% lin. comb. of the inputs and weights of the output layer
    if(~activ) % binary sigmoid function
      outputSignal(i,:) = 1 ./ ( 1+exp(-sumOfWeightedInputs) );
    else   % bipolar sigmoid function
      outputSignal(i,:) = 2 ./ ( 1+exp(-sumOfWeightedInputs) ) - 1;
    end
 
    i = i+1;
  end % while(i<=samples)

  netOut = miny + outputSignal * (maxy - miny);		% real output of the network

end