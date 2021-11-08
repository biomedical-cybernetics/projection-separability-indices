clear;

% sample data
load fisheriris; % Fisher's 1936 iris data

% selecting positive samples by size
[counts, positives] = groupcounts(species); % Note: this method was introduced in R2019a
[~,idx] = max(counts);
positives(idx) = []; % removing the class with the highest number of samples

% apply dimension reduction with t-SNE
rng default % for reproducibility
embeddding = tsne(meas, 'NumDimensions', 2); % Note: this method was introduced in R2017a

% evaluate separability
results = ProcessValidityIndices(embeddding, species, positives,...
    'Indices', 1:8,... % all indices
    'Trustworthiness', 0,... % here, 0 means that a null model will not be applied
    'ProjectionType', 'centroid',... % projection approach to be used while computing the PSIs
    'CenterFormula', 'median'); % center formula for calculating the centroids while executing the PSIs

disp('Separability results:');
disp(struct2table(results));