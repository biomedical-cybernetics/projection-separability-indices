% This example...


% Loading test data
load(strcat(pwd, "/Examples/applestem.mat"));

% Processing validity indices
% Note: nullmodel 0 means that no null model will be applied
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'nullmodel', 0);

% Verbose results
table = struct2table(results);
disp(table);