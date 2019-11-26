% Silhouette index
%   MAIN REFERENCE:
%       - P. J. Rousseeuw, "Silhouettes: A graphical aid to the interpretation and validation of cluster analysis," J. Comput. Appl. Math., vol. 20, pp. 53–65, Nov. 1987.

function [ Gs ] = silhouetteIndex(id , data , nClusters)
% Summary Calculates the global silhouette value for a clustering algorithm
% USAGE [GS] = silhouetteIndex(Idx , data) 
% Reference : Color Segmentation Using Improved MountainClustering
% Technique Version-2 Nk Verma

N = length(data);
Nm = zeros(1,nClusters);
Sm = zeros(1,nClusters);

% Finding no. of points in each cluster
for i = 1:N
    Nm(str2num(id(i))) = Nm(str2num(id(i))) +1; 
end    

s = silhouette(data,id);
for i=1:N
    Sm(str2num(id(i))) = Sm(str2num(id(i)))+s(i);
end

Sm = Sm./Nm;

% Calculating Gs
Gs = sum(Sm)/nClusters;

end