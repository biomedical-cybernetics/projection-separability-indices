function ValidityIndexes = ProcessValidityIndexes(DataMatrix, SampleLabels, PositiveClasses)
	% Setting paths
	mainPath = strcat(pwd,'/');
	if (~isdeployed)
	    addpath(strcat(mainPath, 'Generators/'));
	    addpath(strcat(mainPath, 'ValidityIndexes/'));
	    addpath(strcat(mainPath, 'CommandPrompt/'));
	end

	% Setting logger level (true = enable, false = disable)
	logger = true;

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
	Dimensions = GenerateDimensions(DataMatrix);

	%% Selecting indexes to process
	SelectedIndexes = IndexSelection();

	%% Processing the validity indexes
    GenerateLogs(logger, 'Processing validity indexes (CVIs)...');
	for mi=1:length(SelectedIndexes)
		CurrentIndex = SelectedIndexes(mi);

		switch CurrentIndex
			case 1
				[ValidityIndexes.psip, ValidityIndexes.psiroc, ValidityIndexes.psipr, ~, ~] = ProjectionSeparabilityIndex(DataMatrix, SampleLabels, PositiveClasses, Dimensions, 'median');
			case 2
				ValidityIndexes.dn = indexDN(DataMatrix, SampleLabels, 'euclidean');
			case 3
				db = db_index(DataMatrix, NumericSampleLabels);
				ValidityIndexes.db = 1/(1+db); % Inverting the value
			case 4
				ValidityIndexes.bz = bezdek_index_n(GeneratedClusters);
			case 5
				ValidityIndexes.ch = cal_har_k_index(DataMatrix, NumericSampleLabels);
			case 6
				sh = silhouette(DataMatrix, NumericSampleLabels, 'Euclidean');
				ValidityIndexes.sh = mean(sh); % Getting the mean of the values
			case 7
				ValidityIndexes.th = thornton(DataMatrix, SampleLabels, UniqueSampleLabels, LenUniqueLabels);
			otherwise
				error('Undefined; this index is not available');
		end
	end
	
end