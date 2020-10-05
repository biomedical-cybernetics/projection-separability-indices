% Calinski-Harabasz index
%   MAIN REFERENCE:
%       - T. Calinski and J. Harabasz, “A dendrite method for cluster analysis,” Commun. Stat., vol. 3, no. 1, pp. 1–27, 1974.

function [chK] = CalinskiHarabaszIndex(X,cinds)
% Implements the Calinski and Harabasz cluster index for various clusterings
% 
% Inputs: 
% 
% Written by:
% -- 
% John L. Weatherwax                2008-11-05
% 
% email: wax@alum.mit.edu
% 
% Please send comments and especially bug reports to the
% above email address.
% 
%-----

[n,p] = size(X); 

%--
% 1) compute the between cluster index S_B: 
%--

% get the total sample mean: 
xbar = mean(X); 

uniq_labels = unique(cinds); 
K           = length(uniq_labels);       % <- the number of clusters 

% get the required outer products: 
% 
S_B = zeros( p, p ); 
for jj=1:K,
  tlab = uniq_labels(jj); 
  indj = find( cinds==tlab );               % <- the indices of the samples from class j
  xbarj = mean( X(indj,:) );                % <- the mean of the elements in class j
  nj    = length( indj );                   % <- the number of samples in class j
  
  S_B = S_B + nj * ( xbarj(:)-xbar(:) ) * ( (xbarj(:)-xbar(:)).' ); 
end
S_B = S_B/n; 

%--
% Compute the within class scatter matrix:  
%--

S_W = zeros( p, p ); 
for jj=1:K,
  tlab = uniq_labels(jj); 
  indj = find( cinds==tlab );               % <- the indices of the samples from class j
  xbarj = mean( X(indj,:) );                % <- the mean of the elements in class j
  nj    = length( indj );                   % <- the number of samples in class j
  for ii=1:nj
    S_W = S_W + ( X(indj(ii),:).' - xbarj(:) ) * ( ( X(indj(ii),:).' - xbarj(:) ).' ); 
  end
end
S_W = (1/n)*S_W; 

% compute the index: 
chK = (trace(S_B)/(K-1))/(trace(S_W)/(n-K));