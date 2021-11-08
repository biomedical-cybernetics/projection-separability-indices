% Loading test data
load(strcat(pwd, "/sample-data/applestem.mat"));

% Processing validity indices
% Note: trustworthiness 0 means that no null model will be applied
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses,...
    'Indices', 1:8, 'Trustworthiness', 0, 'CenterFormula', 'median', 'ProjectionType', 'centroid');

% Verbose results
table = struct2table(results);
disp(table);