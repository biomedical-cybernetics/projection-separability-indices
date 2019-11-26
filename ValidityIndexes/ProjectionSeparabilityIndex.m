function [psiPvalue, psiAUC, psiAUPR, dataClustered, sortedLabels] = ProjectionSeparabilityIndex(dataMatrix, sampleLabels, positiveClasses, centerFormula)
	% ProjectionSeparabilityIndex
	%   INPUT Values:
	%		- dataMatrix: Data values (type: numeric/double matrix)
	%		- sampleLabels: List of sample labels (type: cell array)
	%		- positiveClasses: List of positive sample labels (type: cell array)
	%		- centerFormula: chosen formula for calculating the centroids (type: char array)
	%   OUTPUT Values:
	%		- psiPvalue: Mean of Mann-Whitney p-values (type: numeric/double)
	%		- psiAUC: Mean of Area Under the ROC Curve (AUC) values (type: numeric/double)
	%		- psiAUPR: Mean of Area Under the Precision-Recall Curve (AUPR) values (type: numeric/double)
	%		- dataClustered: Created clusters by dividing the sample labels (type: cell array)
	%		- sortedLabels: List of sample labels sorted by cluster (type: cell array)
	
	if nargin < 4
		error('not enough input arguments')
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
		warning('your center formula is not valid; median will be applied')
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
				error('you must select either mean, median or mode in order to calculate the centroids');
		end
		if centroidCluster1 == centroidCluster2
			error('impossible to continue because clusters have the same centroid; no line can be traced between them');
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

	    %% AUC & AUPR
	    sampleLabelsMembership = [sampleLabels(ismember(sampleLabels,uniqueLabels{n}));sampleLabels(ismember(sampleLabels,uniqueLabels{m}))];
	    
	    % selecting the possitive class
	    for o=1:length(positiveClasses)
	        if any(ismember(sampleLabelsMembership,positiveClasses{o}))
	            currentPositiveClass = positiveClasses{o};
	            break;
	        end
	    end

	    [aucValues{l},auprValues{l}] = computeAUCAUPR(sampleLabelsMembership,[clustersProjection1D(1:sizeClusterN);clustersProjection1D(sizeClusterN+1:sizeClusterN+sizeClusterM)],currentPositiveClass);

	    m = m + 1;
	    if(m > numberUniqueLabels)
	        n = n + 1;
	        m = n + 1;
	    end
	end

	psiPvalue = mean([mannWhitneyValues{:}]);
	psiAUC = mean([aucValues{:}]);
	psiAUPR = mean([auprValues{:}]);

	%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	% Sub-functions
	function modeDist = modeDistribution(distance)
		modeDist = [];
		for ix=1:size(distance,2)
			[f,xi] = ksdensity(distance(:,ix));
			[~,ind] = max(f);
			modeDist = horzcat(modeDist, xi(ind));
		end
	end

	function centroidsLine = createLineBetweenCentroids(point1, point2)
	    centroidsLine = [point1;point2];
	end

	function projectedPoints = projectPointsOnLine(point, line)
	    A = line(1,:);
	    B = line(2,:);

	    AP = point - A;
	    AB = B - A;
	    
	    projectedPoints = A + dot(AP,AB)/dot(AB, AB) * AB;
	end

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
	end

	function [auc, aupr] = computeAUCAUPR(labels, scores, positiveClass)
		[~,~,~,auc] = perfcurve(labels, scores, positiveClass);
		if auc < 0.5
			auc = 1 - auc;
			flippedScores = 2 * mean(scores) - scores;
			aupr = auprEvaluation(labels, flippedScores, positiveClass);
		else
			aupr = auprEvaluation(labels, scores, positiveClass);
		end
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
	end
end