% Loading test data
load(strcat(pwd, "/sample-data/tripartiteswissroll.mat"));

% Processing validity indexes
% Note: trustworthiness 100 means that a null model with 100 iterations will be applied
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'trustworthiness', 1000, 'seed', 100);

% Verbose results
fields = fieldnames(results);
for index=1:numel(fields)
    name = fields{index};
    fprintf('Trustworthiness results for: %s index\n\n', name);

    result = results.(name);
    table = struct2table(result);
    disp(table);
end