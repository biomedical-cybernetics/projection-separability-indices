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
%		Without applying trustworthiness:
%		- Struct: IndexName.IndexValue (the number of indices varies according to user preferences)
%			-> Example: results = ProcessValidityIndices(MyMatrix, MySamples, MyPositiveClasses);
%			-> results.psip (access to PSI-P index value)
%
%		Applying trustworthiness:
%		- Struct: IndexName.TrustworthinessStruct
%			* TrustworthinessStruct:
%				+ IndexPermutations: Values returned by the index (the amount of values varies according to user preferences)
%				+ MaxValue: Maximum value returned by the index (first match)
%				+ MinValue: Minimum value returned by the index (first match)
%				+ MeanValue: Mean of the values returned by the index
%				+ StandardDeviation: Standar deviation obtained from the different values
%				+ PValue: Final p-value obtained after applying the null model
%			-> Example: results = ProcessValidityIndices(MyMatrix, MySamples, MyPositiveClasses, 'indices', 1:8, 'trustworthiness', 1000);
%			-> results.psip.MaxValue (access to the maximum value returned by PSI-P index)

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
			error('The value of the option indices must be numeric (e.g. 1) or a range (e.g. 1:8)');
		end
		preSelectedIndices = varargin{option+1};
	end

	option = find(strcmp(varargin, 'trustworthiness'));
	if ~isempty(option)
		if ~isa(varargin{option+1}, 'double')
			error('The value of the option trustworthiness must be numeric (e.g. 100)');
		end
		preSelectedTrustworthiness = varargin{option+1};
	end
end

% Transforming labels
if isnumeric(SampleLabels)
	Logger(logger, 'Transforming sample labels into character array...');
	SampleLabels = arrayfun(@num2str, SampleLabels, 'UniformOutput', false);
end
if isnumeric(PositiveClasses)
	Logger(logger, 'Transforming positive classes to character array...');
	PositiveClasses = arrayfun(@num2str, PositiveClasses, 'UniformOutput', false);
end

OriginData.DataMatrix = DataMatrix;
OriginData.SampleLabels = SampleLabels;
OriginData.PositiveClasses = PositiveClasses;
OriginData.UniqueSampleLabels = unique(SampleLabels);
OriginData.LenUniqueLabels = length(OriginData.UniqueSampleLabels);
OriginData.NumericSampleLabels = findgroups(OriginData.SampleLabels);
OriginData.GeneratedClusters = GenerateClusters(OriginData.DataMatrix, OriginData.SampleLabels, OriginData.UniqueSampleLabels, OriginData.LenUniqueLabels);
OriginData.Dimensions = GenerateDimensions(OriginData.DataMatrix);

%% Selecting indices to process
if exist('preSelectedIndices', 'var') == 1
	SelectedIndices = preSelectedIndices;
else
	SelectedIndices = PromptIndexSelection();
end

%% Selecting if trustworthiness will be applied
if exist('preSelectedTrustworthiness', 'var') == 1
	Trustworthiness = preSelectedTrustworthiness > 0;
	NumberOfIterations = preSelectedTrustworthiness;
else
	[Trustworthiness, NumberOfIterations] = PromptTrustworthiness();
end

if Trustworthiness
	%% Processing trustworthiness
	Logger(logger, 'Processing trustworthiness...');
	IndicesValues = ApplyValidityIndices(SelectedIndices, OriginData);
	ValidityIndices = ApplyTrustworthiness(NumberOfIterations, SelectedIndices, OriginData, IndicesValues);
else
	%% Processing validity indices
	Logger(logger, 'Processing validity indices...');
	ValidityIndices = ApplyValidityIndices(SelectedIndices, OriginData);
end

Logger(logger, 'Done.');