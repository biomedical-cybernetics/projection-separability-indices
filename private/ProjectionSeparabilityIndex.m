function [psiP, psiROC, psiPR, psiMCC, dataClustered, samplesClustered] = ProjectionSeparabilityIndex(dataMatrix, sampleLabels, positiveClasses, projectionType, centerFormula)
% ProjectionSeparabilityIndex
%   INPUT Values:
%		- dataMatrix: Data values (type: numeric/double matrix)
%		- sampleLabels: List of sample labels (type: cell array)
%		- positiveClasses: List of positive sample labels (type: cell array)
%		- projectionType: Base approach for projecting the points (options: centroid or lda)
%		- centerFormula: chosen formula for calculating the centroids (type: char array)
%   OUTPUT Values:
%		- psiP: Mean of Mann-Whitney p-values (type: numeric/double)
%		- psiROC: Mean of Area Under the ROC Curve (AUC) values (type: numeric/double)
%		- psiPR: Mean of Area Under the Precision-Recall Curve (AUPR) values (type: numeric/double)
%		- psiMCC: Mean of Matthews Correlation Coefficient (MCC) values (type: numeric/double)
%		- dataClustered: Created groups by dividing the sample labels in groups (type: cell array)
%		- samplesClustered: Grouped sample labels (type: cell array)

if nargin < 4
	error('Not enough input arguments')
end

if (~strcmp(projectionType, 'centroid') && ~strcmp(projectionType, 'lda'))
	warning('your projection type <%s> is not valid: centroid will be used by default', projectionType);
	projectionType = 'centroid';
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

% grouping data according to sample labels
for k=1:numberUniqueLabels
	idx = find(ismember(sampleLabels,uniqueLabels{k}));
	samplesClustered{k} = sampleLabels(idx);
	dataClustered{k} = dataMatrix(idx,:);
end

pairwiseGroupCombinations = nchoosek(1:numberUniqueLabels, 2);
for l=1:size(pairwiseGroupCombinations, 1)
	idxGroupA = pairwiseGroupCombinations(l, 1);
	dataGroupA = dataClustered{idxGroupA}(:,dimsRange);
	samplesGroupA = samplesClustered{idxGroupA};
	sizeGroupA = size(dataGroupA,1);

	idxGroupB = pairwiseGroupCombinations(l, 2);
	dataGroupB = dataClustered{idxGroupB}(:,dimsRange);
	samplesGroupB = samplesClustered{idxGroupB};
	sizeGroupB = size(dataGroupB,1);

	if strcmp(projectionType, 'centroid')
		projectedPoints = centroidBasedProjection(dataGroupA, dataGroupB, centerFormula);
	elseif strcmp(projectionType, 'lda')
		projectedPoints = ldaBasedProjection([dataGroupA;dataGroupB], [samplesGroupA;samplesGroupB]);
	else
		error('invalid projection type <%s>', projectionType);
	end

	dpScores = convertPointsToOneDimension(projectedPoints);
	dpScoresGroupA = dpScores(1:sizeGroupA);
	dpScoresGroupB = dpScores(sizeGroupA+1:sizeGroupA+sizeGroupB);

	%% Mann-Whitney
	mannWhitneyValues{l} = ranksum(dpScoresGroupA,dpScoresGroupB);

	% sample membership
	sampleLabelsMembership = [samplesGroupA;samplesGroupB];

	% selecting the possitive class
	for o=1:length(positiveClasses)
		if any(ismember(sampleLabelsMembership,positiveClasses{o}))
			currentPositiveClass = positiveClasses{o};
			break;
		end
	end

	%% AUC & AUPR
	[aucValues{l},auprValues{l}] = computeAUCAUPR(sampleLabelsMembership,dpScores,currentPositiveClass);

	%% MCC
	mccValues{l} = computeMCC(sampleLabelsMembership,dpScores,currentPositiveClass);
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
function projection = centroidBasedProjection(dataGroupA, dataGroupB, centerFormula)
if (~strcmp(centerFormula,'mean') && ~strcmp(centerFormula,'median') && ~strcmp(centerFormula,'mode'))
	warning('your center formula <%s> is not valid: median will be applied', centerFormula);
	centerFormula = 'median';
end

switch centerFormula
	case 'mean'
		centroidA = mean(dataGroupA,1);
		centroidB = mean(dataGroupB,1);
	case 'median'
		centroidA = median(dataGroupA,1);
		centroidB = median(dataGroupB,1);
	case 'mode'
		centroidA = modeDistribution(dataGroupA);
		centroidB = modeDistribution(dataGroupB);
	otherwise
		error('You must select either mean, median, or mode to calculate the centroids');
end
if centroidA == centroidB
	error('Impossible to continue because groups have the same centroid: no line can be traced between them');
end

centroidsLine = createLineBetweenCentroids(centroidA,centroidB);
pairwiseData = [dataGroupA; dataGroupB];

projection = zeros(size(pairwiseData, 1), size(pairwiseData, 2));
for ox=1:size(pairwiseData, 1)
	projection(ox, :) = projectPointOnLine(pairwiseData(ox, :),centroidsLine);
end

function projection = ldaBasedProjection(pairwiseData, pairwiseSamples)
Mdl = fitcdiscr(pairwiseData, pairwiseSamples, 'DiscrimType','linear');
[W, LAMBDA] = eig(Mdl.BetweenSigma, Mdl.Sigma);
lambda = diag(LAMBDA);
[~, SortOrder] = sort(lambda, 'descend');
W = W(:, SortOrder);
mu = mean(pairwiseData);
% projecting data points onto the first discriminant axis
centered = bsxfun(@minus, pairwiseData, mu);
projection = centered * W(:,1)*transpose(W(:,1));
projection = bsxfun(@plus, projection, mu);

function modeDist = modeDistribution(distance)
modeDist = [];
for ix=1:size(distance,2)
	[f,xi] = ksdensity(distance(:,ix));
	[~,ind] = max(f);
	modeDist = horzcat(modeDist, xi(ind));
end

function centroidsLine = createLineBetweenCentroids(point1, point2)
centroidsLine = [point1;point2];

function projectedPoint = projectPointOnLine(point, line)
A = line(1,:);
B = line(2,:);

AP = point - A;
AB = B - A;

projectedPoint = A + dot(AP,AB)/dot(AB, AB) * AB;

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
	% since the position of the groups is unknown
	% we take as comparison a perfect segregation in both ways
	% positive group in the left side, and negative group in the right side,
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