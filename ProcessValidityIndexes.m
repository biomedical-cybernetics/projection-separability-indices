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

	OriginData.DataMatrix = DataMatrix;
	OriginData.SampleLabels = SampleLabels;
	OriginData.PositiveClasses = PositiveClasses;
	OriginData.UniqueSampleLabels = unique(SampleLabels);
	OriginData.LenUniqueLabels = length(OriginData.UniqueSampleLabels);
	OriginData.NumericSampleLabels = GenerateNumericLabels(OriginData.SampleLabels, OriginData.UniqueSampleLabels, OriginData.LenUniqueLabels);
	OriginData.GeneratedClusters = GenerateClusters(OriginData.DataMatrix, OriginData.SampleLabels, OriginData.UniqueSampleLabels, OriginData.LenUniqueLabels);
	OriginData.Dimensions = GenerateDimensions(OriginData.DataMatrix);

	%% Selecting indexes to process
	SelectedIndexes = PromptIndexSelection();

	%% Selecting if null model will be applied
	[ApplyNullModel, NumberOfIterations] = PromptNullModel();

	if ApplyNullModel
		%% Processing null model
   		GenerateLogs(logger, 'Processing null model...');
   		IndexesValues = GenerateIndexesValues(SelectedIndexes, OriginData);
		ValidityIndexes = GenerateNullModel(NumberOfIterations, SelectedIndexes, OriginData, IndexesValues);
	else
		%% Processing validity indexes
   		GenerateLogs(logger, 'Processing validity indexes...');
		ValidityIndexes = GenerateIndexesValues(SelectedIndexes, OriginData);	
	end
end