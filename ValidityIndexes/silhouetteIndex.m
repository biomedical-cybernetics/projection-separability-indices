function [ Gs ] = silhouetteIndex(id , data , nClusters)
% Summary Calculates the global silhouette value for a clustering algorithm
% USAGE [GS] = global_silhouette(Idx , data) 
% Reference : Color Segmentation Using Improved MountainClustering
% Technique Version-2 Nk Verma

N = length(data);
Nm = zeros(1,nClusters);
Sm = zeros(1,nClusters);

% Finding no. of points in each cluster
for i = 1:N,
    Nm(id(i)) = Nm(id(i)) +1; 
end    

s = silhouette(data,id);
for i=1:N,
    Sm(id(i)) = Sm(id(i))+s(i);
end

Sm = Sm./Nm;

% Calculating Gs
Gs = sum(Sm)/nClusters;

end