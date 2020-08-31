function ValidityIndices = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, varargin)
	% ProcessValidityIndices
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
	%		- Struct: IndexName.IndexValue (the number of indices varies according to user preferences)
	%			-> Example: results = ProcessValidityIndices(MyMatrix, MySamples, MyPositiveClasses);
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
	%			-> Example: results = ProcessValidityIndices(MyMatrix, MySamples, MyPositiveClasses);
	%			-> results.psip.MaxValue (access to the maximum value returned by PSI-P index)

	% Setting paths
	mainPath = strcat(pwd,'/');
	if (~isdeployed)
	    addpath(strcat(mainPath, 'Generators/'));
	    addpath(strcat(mainPath, 'ValidityIndices/'));
	    addpath(strcat(mainPath, 'CommandPrompt/'));
	end

	% Setting logger level (true = enable, false = disable)
	logger = true;

	% Checking extra parameters
	if ~isempty(varargin) 
        if mod(length(varargin), 2) ~= 0
            error('Extra parameters must be in a key value format');
		end
		
		option = find(strcmp(varargin, 'seed'));
		if ~isempty(option)
            if ~isa(varargin{option+1}, 'double')
                error('The value of the option seed must be numeric (e.g. 100)');
			end
			seed = RandStream.create('mrg32k3a', 'seed', varargin{option+1});
			RandStream.setGlobalStream(seed);
		end
		
		option = find(strcmp(varargin, 'indices'));
		if ~isempty(option)
            if ~isa(varargin{option+1}, 'double')
                error('The value of the option indices must be numeric (e.g. 1) or a range (e.g. 1:7)');
            end
			preSelectedIndices = varargin{option+1};
		end

		option = find(strcmp(varargin, 'nullmodel'));
		if ~isempty(option)
            if ~isa(varargin{option+1}, 'double')
                error('The value of the option nullmodel must be numeric (e.g. 100)');
            end
			preSelectedNullModel = varargin{option+1};
		end
	end

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

	%% Selecting indices to process
	if exist('preSelectedIndices', 'var') == 1
		SelectedIndices = preSelectedIndices;
	else
		SelectedIndices = PromptIndexSelection();
	end

	%% Selecting if null model will be applied
	if exist('preSelectedNullModel', 'var') == 1
		ApplyNullModel = preSelectedNullModel > 0;
		NumberOfIterations = preSelectedNullModel;
	else
		[ApplyNullModel, NumberOfIterations] = PromptNullModel();
	end

	if ApplyNullModel
		%% Processing null model
   		GenerateLogs(logger, 'Processing null model...');
   		IndicesValues = GenerateIndicesValues(SelectedIndices, OriginData);
		ValidityIndices = GenerateNullModel(NumberOfIterations, SelectedIndices, OriginData, IndicesValues);
	else
		%% Processing validity indices
   		GenerateLogs(logger, 'Processing validity indices...');
		ValidityIndices = GenerateIndicesValues(SelectedIndices, OriginData);	
	end

	GenerateLogs(logger, 'Done.');
end