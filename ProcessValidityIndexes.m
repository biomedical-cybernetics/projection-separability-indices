function ValidityIndexes = ProcessValidityIndexes(DataMatrix, SampleLabels, PositiveClasses, Dimensions)
	% Setting paths
	mainPath = strcat(pwd,'/');
	if (~isdeployed)
	    addpath(strcat(mainPath, 'Generators/'));
	    addpath(strcat(mainPath, 'ValidityIndexes/'));
	end

	% Setting logger level (true = enable, false = disable)
	logger = false;

	% Transforming labels
	if isnumeric(SampleLabels)
	    GenerateLogs(logger, 'Transforming sample labels into character array...');
	    SampleLabels = arrayfun(@num2str, SampleLabels, 'UniformOutput', false);
	end
	if isnumeric(PositiveClasses)
	    GenerateLogs(logger, 'Transforming positive classes to character array...');
	    PositiveClasses = arrayfun(@num2str, PositiveClasses, 'UniformOutput', false);
	end

	UniqueSampleLabels = unique(SampleLabels);
	LenUniqueLabels = length(UniqueSampleLabels);
	NumericSampleLabels = GenerateNumericLabels(SampleLabels, UniqueSampleLabels, LenUniqueLabels);

	GeneratedClusters = GenerateClusters(DataMatrix, SampleLabels, UniqueSampleLabels, LenUniqueLabels);

	%% Processing the validity indexes
    GenerateLogs(logger, 'Processing validity indexes (CVIs)...');
	[ValidityIndexes.psip, ValidityIndexes.psiroc, ValidityIndexes.psipr, ~, ~] = ProjectionSeparabilityIndex(DataMatrix, SampleLabels, PositiveClasses, Dimensions, 'median');
	ValidityIndexes.dn = indexDN(DataMatrix, SampleLabels, 'euclidean');
	db = db_index(DataMatrix, NumericSampleLabels);
	ValidityIndexes.db = 1/(1+db); % Inverting the value
	ValidityIndexes.bz = bezdek_index_n(GeneratedClusters);
	ValidityIndexes.ch = cal_har_k_index(DataMatrix, NumericSampleLabels);
	sh = silhouette(DataMatrix, NumericSampleLabels, 'Euclidean');
	ValidityIndexes.sh = mean(sh); % Getting the mean of the values
	ValidityIndexes.th = thornton(DataMatrix, SampleLabels, UniqueSampleLabels, LenUniqueLabels);
end