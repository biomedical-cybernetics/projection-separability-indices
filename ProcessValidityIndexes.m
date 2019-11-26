function ValidityIndexes = ProcessValidityIndexes(DataMatrix, SampleLabels, PositiveClasses)
	% ProcessValidityIndexes
	% 	LICENCE:
	%		- Released under MIT License
	%	COPYRIGHT:
	%		- Aldo Acevedo, Sara Ciucci, MingJu Kuo, Claudio Duran, and Carlo Vittorio Cannistraci
	%   INPUT Values:
	%		- DataMatrix: Data values (type: numeric/double matrix)
	%		- SampleLabels: List of sample labels (type: cell array)
	%		- PositiveClasses: List of positive sample labels (type: cell array)
	%   OUTPUT Values:
	%		Without applying a Null Model:
	%		- Struct: IndexName.IndexValue (the number of indexes varies according to user preferences)
	%			-> Example: results = ProcessValidityIndexes(MyMatrix, MySamples, MyPositiveClasses);
	%			-> results.psip (access to PSI-P index value)
	%		
	%		Applying a Null Model:
	%		- Struct: IndexName.NullModelStruct
	%			* NullModelStruct:
	%				+ IndexPermutations: Values returned by the index (the amount of values varies according to user preferences)
	%				+ MaxValue: Maximum value returned by the index (first match)
	%				+ MinValue: Minimum value returned by the index (first match)
	%				+ MeanValue: Mean of the values returned by the index
	%				+ StandardDeviation: Standar deviation obtained from the different values
	%				+ PValue: Final p-value obtained after applying the null model
	%			-> Example: results = ProcessValidityIndexes(MyMatrix, MySamples, MyPositiveClasses);
	%			-> results.psip.MaxValue (access to the maximum value returned by PSI-P index)

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