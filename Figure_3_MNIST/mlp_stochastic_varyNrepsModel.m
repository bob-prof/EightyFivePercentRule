function [model, mse, ACC] = mlp_stochastic_varyNrepsModel(model, X, Y, h, Nrep, maxiter, eta)
% Multilayer perceptron
% Input:
%   X: d x n data matrix
%   Y: p x n response matrix
%   h: L x 1 vector specify number of hidden nodes in each layer l
% Ouput:
%   model: model structure
%   mse: mean square error
% Adapted from original by Mo Chen (sth4nth@gmail.com) for 85% rule by
% Robert Wilson bob@arizona.edu

h = [size(X,1);h(:);size(Y,1)];
W = model.W;
L = length(W)+1;

maxiter = min([size(X,2) maxiter]);
mse = zeros(1,maxiter);
for rep = 1:Nrep
    rep
    for iter = 1:maxiter
        Z{1} = X(:,iter);
        %     forward
        for l = 2:L
            Z{l} = sigmoid(W{l-1}'*Z{l-1});
        end
        %     backward
        E = Y(iter)-Z{L};
        mse(iter) = mean(dot(E(:),E(:)));
        for l = L-1:-1:1
            df = Z{l+1}.*(1-Z{l+1});
            dG = df.*E;
            dW = Z{l}*dG';
            W{l} = W{l}+eta*dW;
            E = W{l}*dG;
        end
    end
    
    model.W = W;
    [yy, SCORE] = mlpPred(model, X);
    ACC(rep) = nanmean(abs(Y - double((yy<0.5))))

end
mse = mse(1:iter);
