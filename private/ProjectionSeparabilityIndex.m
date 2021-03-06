function [psiP, psiROC, psiPR, psiMCC, dataClustered, sortedLabels] = ProjectionSeparabilityIndex(dataMatrix, sampleLabels, positiveClasses, centerFormula)
% ProjectionSeparabilityIndex
%   INPUT Values:
%		- dataMatrix: Data values (type: numeric/double matrix)
%		- sampleLabels: List of sample labels (type: cell array)
%		- positiveClasses: List of positive sample labels (type: cell array)
%		- centerFormula: chosen formula for calculating the centroids (type: char array)
%   OUTPUT Values:
%		- psiP: Mean of Mann-Whitney p-values (type: numeric/double)
%		- psiROC: Mean of Area Under the ROC Curve (AUC) values (type: numeric/double)
%		- psiPR: Mean of Area Under the Precision-Recall Curve (AUPR) values (type: numeric/double)
%		- psiMCC: Mean of Matthews Correlation Coefficient (MCC) values (type: numeric/double)
%		- dataClustered: Created clusters by dividing the sample labels in groups (type: cell array)
%		- sortedLabels: List of sample labels sorted by cluster (type: cell array)

if nargin < 4
	error('Not enough input arguments')
end

% obtaining unique sample labels
uniqueLabels = unique(sampleLabels);
numberUniqueLabels = length(uniqueLabels);

% checking range of dimensions
dimensionsNumber = size(dataMatrix, 2);
if (dimensionsNumber > 0)
	dimsRange = 1:dimensionsNumber;
else
	dimsRange = ':';
end

% clustering data according to sample labels
sortedLabels = [];
for k=1:numberUniqueLabels
	idx = find(ismember(sampleLabels,uniqueLabels{k}));
	sortedLabels = vertcat(sortedLabels,sampleLabels(idx));
	dataClustered{k} = dataMatrix(idx,:);
end

n = 1;
m = 2;
if ~strcmp(centerFormula,'mean') && ~strcmp(centerFormula,'median') && ~strcmp(centerFormula,'mode')
	warning('your center formula is not valid: median will be applied')
	centerFormula = 'median';
end
for l=1:nchoosek(numberUniqueLabels, 2) % number of sample labels combinations
	switch centerFormula
		case 'mean'
			centroidCluster1 = mean(dataClustered{n}(:,dimsRange),1);
			centroidCluster2 = mean(dataClustered{m}(:,dimsRange),1);
		case 'median'
			centroidCluster1 = median(dataClustered{n}(:,dimsRange),1);
			centroidCluster2 = median(dataClustered{m}(:,dimsRange),1);
		case 'mode'
			centroidCluster1 = modeDistribution(dataClustered{n}(:,dimsRange));
			centroidCluster2 = modeDistribution(dataClustered{m}(:,dimsRange));
		otherwise
			error('You must select either mean, median, or mode to calculate the centroids');
	end
	if centroidCluster1 == centroidCluster2
		error('Impossible to continue because clusters have the same centroid: no line can be traced between them');
	end

	clustersLine = createLineBetweenCentroids(centroidCluster1,centroidCluster2);

	for o=1:size(dataClustered{n},1)
		clustersProjection{n}(o,:) = projectPointsOnLine(dataClustered{n}(o,dimsRange),clustersLine);
	end
	for o=1:size(dataClustered{m},1)
		clustersProjection{m}(o,:) = projectPointsOnLine(dataClustered{m}(o,dimsRange),clustersLine);
	end

	clustersProjection1D = convertPointsToOneDimension([clustersProjection{n};clustersProjection{m}]);

	%% Mann-Whitney
	sizeClusterN = size(dataClustered{n},1);
	sizeClusterM = size(dataClustered{m},1);
	mannWhitneyValues{l} = ranksum(clustersProjection1D(1:sizeClusterN),clustersProjection1D(sizeClusterN+1:sizeClusterN+sizeClusterM));

	% sample membership
	sampleLabelsMembership = [sampleLabels(ismember(sampleLabels,uniqueLabels{n}));sampleLabels(ismember(sampleLabels,uniqueLabels{m}))];

	% selecting the possitive class
	for o=1:length(positiveClasses)
		if any(ismember(sampleLabelsMembership,positiveClasses{o}))
			currentPositiveClass = positiveClasses{o};
			break;
		end
	end

	%% AUC & AUPR
	[aucValues{l},auprValues{l}] = computeAUCAUPR(sampleLabelsMembership,[clustersProjection1D(1:sizeClusterN);clustersProjection1D(sizeClusterN+1:sizeClusterN+sizeClusterM)],currentPositiveClass);

	%% MCC
	mccValues{l} = computeMCC(sampleLabelsMembership,[clustersProjection1D(1:sizeClusterN);clustersProjection1D(sizeClusterN+1:sizeClusterN+sizeClusterM)],currentPositiveClass);

	m = m + 1;
	if(m > numberUniqueLabels)
		n = n + 1;
		m = n + 1;
	end
end

% compile all values from the different groups' combinations
allMWPvalues = [mannWhitneyValues{:}];
allAUCROCvalues = [aucValues{:}];
allAUCPRvalues = [auprValues{:}];
allMCCvalues = [mccValues{:}];

% Corrected PSI-P value
psiP = (mean(allMWPvalues) + std(allMWPvalues)) / (1 + std(allMWPvalues));
% Corrected PSI-ROC value
psiROC = mean(allAUCROCvalues) / (1 + std(allAUCROCvalues));
% Corrected PSI-PR value
psiPR = mean(allAUCPRvalues) / (1 + std(allAUCPRvalues));
% Corrected PSI-MCC value
psiMCC = mean(allMCCvalues) / (1 + std(allMCCvalues));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Sub-functions
function modeDist = modeDistribution(distance)
modeDist = [];
for ix=1:size(distance,2)
	[f,xi] = ksdensity(distance(:,ix));
	[~,ind] = max(f);
	modeDist = horzcat(modeDist, xi(ind));
end

function centroidsLine = createLineBetweenCentroids(point1, point2)
centroidsLine = [point1;point2];

function projectedPoints = projectPointsOnLine(point, line)
A = line(1,:);
B = line(2,:);

AP = point - A;
AB = B - A;

projectedPoints = A + dot(AP,AB)/dot(AB, AB) * AB;

function V = convertPointsToOneDimension(points)
% select the point 0 (min value of an axis [where the values are different from one another])
for ix=1:size(points,2)
	if length(unique(points(:,ix))) ~= 1
		startPoint = points(points(:,ix) == min(points(:,ix)),:);
		break;
	end
end

V = 0;
for ix=1:size(points,2)
	V = V + (points(:,ix)-min(startPoint(:,ix))).^2;
end

V = sqrt(V);

function mcc = computeMCC(labels, scores, positiveClass)
% total amount of positive labels
totalPositive = sum(strcmp(labels, positiveClass));
% total amount of negative labels
totalNegative = sum(~strcmp(labels, positiveClass));

% identifying the negative class
negativeClass = unique(labels(~strcmp(labels, positiveClass)));

% sort the scores and obtained the sorted indices
[~, idxs] = sort(scores);

% sort the original labels according to the sorted scores
trueLabels = labels(idxs);

for in=1:2
	% since the position of the clusters is unknown
	% we take as comparison a perfect segregation in both ways
	% positive cluster in the left side, and negative cluster in the right side,
	% and viseversa
	switch in
		case 1
			predictedLabels = [repmat({positiveClass},totalPositive,1);repmat(negativeClass,totalNegative,1)];
		case 2
			predictedLabels = [repmat(negativeClass,totalNegative,1);repmat({positiveClass},totalPositive,1)];
	end

	% clasifiers
	TP = sum(ismember(predictedLabels, positiveClass) & ismember(trueLabels, positiveClass));
	TN = sum(ismember(predictedLabels, negativeClass) & ismember(trueLabels, negativeClass));
	FP = sum(ismember(predictedLabels, positiveClass) & ismember(trueLabels, negativeClass));
	FN = sum(ismember(predictedLabels, negativeClass) & ismember(trueLabels, positiveClass));

	if ((TP == 0 && FP == 0) || (TN == 0 && FN == 0))
		mccVal{in} = 0;
	else
		% compute the Matthews Correlation Coefficient (MCC)
		mccVal{in} = (TP*TN - FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
	end
end
% select the best MCC side
mcc = max([mccVal{:}]);

function [auc, aupr] = computeAUCAUPR(labels, scores, positiveClass)
[~,~,~,auc] = perfcurve(labels, scores, positiveClass);
if auc < 0.5
	auc = 1 - auc;
	flippedScores = 2 * mean(scores) - scores;
	aupr = auprEvaluation(labels, flippedScores, positiveClass);
else
	aupr = auprEvaluation(labels, scores, positiveClass);
end

function aupr = auprEvaluation(labels, scores, positiveClass)
[rec,prec,~,~] = perfcurve(labels, scores, positiveClass, 'xCrit', 'reca', 'yCrit', 'prec');
% rec is the recall, prec is the precision.
% the first value of rec (at recall 0) is NaN (by definition, PRECISION = TP / (FP + TP))
% at recall 0 we have PRECISION = 0/(0 + 0) (we don't have neither TP nor FP)
% if at the first point of recall (prec(2)) the precision is 1, the NaN is changed
% for 1, in the contrary case (in the first point we have a FP), the NaN is changed for 0
if prec(2) == 1
	prec(1) = 1;
else
	prec(1) = 0;
end
aupr = trapz(rec,prec);