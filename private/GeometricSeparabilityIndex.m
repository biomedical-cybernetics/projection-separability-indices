% Geometric Separability Index (also known as Thornton index)
%   MAIN REFERENCE:
%       - C. Thornton, “Separability is a Learner’s Best Friend,” Springer, London, 1998, pp. 40–46.

% Matlab code for Geometric Separability Index
% Accepts a p x d  matrix X in which each row is a vector
% of d numeric features (usually norm. into the range 0-1)
% t is a vector of labels (usually +1 or - 1)
% Returns s, a number between 0 and 1, a measure of
% degree to which classes are geometrically separable.
% s is  the fraction of instances whose classification
% label is shared by its nearest neighbour (determined
% on the basis of simple Euclidean distance)

function GSI = GeometricSeparabilityIndex(x, labels, nameLabels, numbLabels)
% GeometricSeparabilityIndex
%   REFERENCE:
%       - Released under MIT License

p = length(labels);
d2 = pdist2(x,x);
[S, I] = sort(d2);
t1 = labels(I(1,:));
t2 = labels(I(2,:));
GSI = sum(strcmp(t1,t2))/p;