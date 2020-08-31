% This example...

% Loading test data
load(strcat(pwd, "/Examples/tripartiteswissroll.mat"));

% Processing validity indexes
% Note: nullmodel 100 means that a null model with 100 iterations will be applied
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'nullmodel', 100);

% Verbose results
fields = fieldnames(results);
for index=1:numel(fields)
    name = fields{index};
    fprintf('Null model results for: %s index\n\n', name);
    
    result = results.(name);
    table = struct2table(result);
    disp(table);
end