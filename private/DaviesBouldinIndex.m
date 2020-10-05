% Davies-Bouldin index
%   MAIN REFERENCE:
%       - D. L. Davies and D. W. Bouldin, “A Cluster Separation Measure,” IEEE Trans. Pattern Anal. Mach. Intell., vol. PAMI-1, no. 2, pp. 224–227, 1979.

function [t,r] = DaviesBouldinIndex(D, cl, C, p, q)
% DB_INDEX Davies-Bouldin clustering evaluation index.
%
% [t,r] = DaviesBouldinIndex(D, cl, C, p, q)
%
%  Input and output arguments ([]'s are optional):  
%    D     (matrix) data (n x dim)
%          (struct) map or data struct
%    cl    (vector) cluster numbers corresponding to data samples (n x 1)
%    [C]   (matrix) prototype vectors (c x dim) (default = cluster means)
%    [p]   (scalar) norm used in the computation (default == 2)
%    [q]   (scalar) moment used to calculate cluster dispersions (default = 2)
% 
%    t     (scalar) Davies-Bouldin index for the clustering (=mean(r))
%    r     (vector) maximum DB index for each cluster (size c x 1)    
% 
% See also  KMEANS, KMEANS_CLUSTERS, SOM_GAPINDEX.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% input arguments

if isstruct(D), 
    switch D.type,
    case 'som_map', D = D.codebook; 
    case 'som_data', D = D.data; 
    end
end

% cluster centroids
[l dim] = size(D);
u = unique(cl); 
c = length(u); 
if nargin <3, 
  C = zeros(c,dim); 
  for i=1:c, 
      me = nanstats(D(find(cl==u(i)),:));
      C(i,:) = me';
  end 
end

u2i = zeros(max(u),1); u2i(u) = 1:c; 
D = som_fillnans(D,C,u2i(cl)); % replace NaN's with cluster centroid values

if nargin <4, p = 2; end % euclidian distance between cluster centers
if nargin <5, q = 2; end % dispersion = standard deviation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% action

% dispersion in each cluster 
for i = 1:c
  ind = find(cl==u(i)); % points in this cluster
  l   = length(ind);
  if l > 0
    S(i) = (mean(sqrt(sum((D(ind,:) - ones(l,1) * C(i,:)).^2,2)).^q))^(1/q);
  else
    S(i) = NaN;
  end
end

% distances between clusters
%for i = 1:c
%  for j = i+1:c
%    M(i,j) = sum(abs(C(i,:) - C(j,:)).^p)^(1/p);
%  end
%end
M = som_mdist(C,p); 

% Davies-Bouldin index
R = NaN * zeros(c);
r = NaN * zeros(c,1);
for i = 1:c
  for j = i+1:c
    R(i,j) = (S(i) + S(j))/M(i,j);
  end
  r(i) = max(R(i,:));
end

t = mean(r(isfinite(r)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Internal functions
%% NOTE: needed for running this index
function [me, st, md, no] = nanstats(D)
%NANSTATS Statistical operations that ignore NaNs and Infs.
%
% [mean, std, median, nans] = nanstats(D)
%
%  Input and output arguments: 
%   D   (struct) data or map struct
%       (matrix) size dlen x dim
%
%   me  (double) columnwise mean
%   st  (double) columnwise standard deviation
%   md  (double) columnwise median
%   no  (vector) columnwise number of samples (finite, not-NaN)

% Contributed to SOM Toolbox vs2, February 2nd, 2000 by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 300798 200900

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check arguments

%(nargchk(1, 1, nargin));  % check no. of input args is correct
(narginchk(1, nargin));  % check no. of input args is correct

if isstruct(D), 
  if strcmp(D.type,'som_map'), D = D.codebook;
  else D = D.data;
  end
end
[dlen dim] = size(D);
me = zeros(dim,1)+NaN;
md = me;
st = me;
no = me;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% computation

for i = 1:dim,
  ind = find(isfinite(D(:, i))); % indices of non-NaN/Inf elements
  n   = length(ind);             % no of non-NaN/Inf elements

  me(i) = sum(D(ind, i)); % compute average
  if n == 0, me(i) = NaN; else me(i) = me(i) / n; end

  if nargout>1, 
    md(i) = median(D(ind, i)); % compute median

    if nargout>2, 
      st(i) = sum((me(i) - D(ind, i)).^2); % compute standard deviation
      if n == 0,     st(i) = NaN;
      elseif n == 1, st(i) = 0;
      else st(i) = sqrt(st(i) / (n - 1));
      end

      if nargout>3, 
        no(i) = n; % number of samples (finite, not-NaN)
      end
    end
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sD = som_fillnans(sD,sM,bmus)
% SOM_FILLNANS Replaces NaNs in the data matrix with values from
%              SOM prototypes.
%
%   sD = som_fillnans(sD,sM, [bmus])
%
%      sD      (struct) data struct
%              (matrix) size dlen x dim
%      sM      (struct) data struct, with .data of size dlen x dim
%              (matrix) size dlen x dim, a matrix from which
%                       the values are taken from directly
%              (struct) map struct: replacement values are taken from
%                       sM.codebook(bmus,:)
%      [bmus]  (vector) BMU for each data vector (calculated if not specified)
%
% See also  SOM_MAKE.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstruct(sD),
  [dlen dim] = size(sD.data);
  nans = find(isnan(sD.data));
else
  [dlen dim] = size(sD);
  nans = find(isnan(sD));
end

if nargin<3,
  bmus = som_bmus(sM,sD);   
end

if isstruct(sM) & strcmp(sM.type,'som_map'),
  sM = sM.codebook(bmus,:);
elseif isstruct(sM),
  sM = sM.data(bmus,:);   
else
  sM = sM(bmus,:);
end
me = mean(sM);

if any(size(sM) ~= [dlen dim]),
  error('Invalid input arguments.')
end

if isstruct(sD),
  sD.data(nans) = sM(nans);
else
  sD(nans) = sM(nans);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Md = som_mdist(D,q,mask,Ne)
% SOM_MDIST Mutual (or pairwise) distance matrix for the given data.
%
%   Md = som_mdist(D,[q],[mask],[Ne])
%
%    Md = som_mdist(D);
%    Md = som_mdist(D,Inf);
%    Md = som_mdist(D,2,Ne);
%
%  Input and output arguments ([]'s are optional):
%   D        (matrix) size dlen x dim, the data set
%            (struct) map or data struct
%   [q]      (scalar) distance norm, default = 2
%   [mask]   (vector) size dim x 1, the weighting mask
%   [Ne]     (matrix) size dlen x dlen, sparse matrix
%                     indicating which distances should be
%                     calculated (ie. less than Infinite)
%
% See also PDIST.

% Copyright (c) 2000 by Juha Vesanto
% Contributed to SOM Toolbox on XXX by Juha Vesanto
% http://www.cis.hut.fi/projects/somtoolbox/

% Version 2.0beta juuso 220800

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mask
if nargin<3, mask = []; end

% the data
if isstruct(D),
  switch D.type,
  case 'som_map', if isempty(mask), mask = D.mask; end, D = D.codebook;
  case 'som_data', D = D.data;
  otherwise, error('Bad first argument');
  end
end
nans = sum(isnan(D),2);
if any(nans>0),
  D(find(nans>0),:) = 0;
  warning('Distances of vectors with NaNs are not calculated.');
end
[dlen dim] = size(D);

% distance norm
if nargin<2 | isempty(q) | isnan(q), q = 2; end

% mask
if isempty(mask), mask = ones(dim,1); end

% connections
if nargin<4, Ne = []; end
if ~isempty(Ne),
  l = size(Ne,1); Ne([0:l-1]*l+[1:l]) = 1; % set diagonal elements = 1
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = mask;
o = ones(dlen,1);
l = dlen;
Md = zeros(dlen);
calculate_all = isempty(Ne);

if ~calculate_all, Md(Ne==0) = Inf; end

for i=1:l-1,
  j=(i+1):l;
  if ~calculate_all, j=find(Ne(i,j))+i; end
  C=D(j,:)-D(i*o(1:length(j)),:);
  switch q,
  case 1,    Md(j,i)=abs(C)*m;
  case 2,    Md(j,i)=sqrt((C.^2)*m); 
  case Inf,  Md(j,i)=max(diag(m)*abs(C),[],2);
  otherwise, Md(j,i)=((abs(C).^q)*m).^(1/q);
  end   
  Md(i,j) = Md(j,i)';
end

Md(find(nans>0),:) = NaN;
Md(:,find(nans>0)) = NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%