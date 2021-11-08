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
psisApproaches(1) = {'Centroid-based (median)'};
psisCentroidMedian = ProcessValidityIndices(embeddding, species, positives,...
    'Indices', 1,... % only PSI indices
    'Trustworthiness', 0,... % here, 0 means that a null model will not be applied
    'ProjectionType', 'centroid',... % projection approach to be used while computing the PSIs
    'CenterFormula', 'median'); % center formula for calculating the centroids while executing the PSIs

psisApproaches(2) = {'Centroid-based (mean)'};
psisCentroidMean = ProcessValidityIndices(embeddding, species, positives,...
    'Indices', 1,... % only PSI indices
    'Trustworthiness', 0,... % here, 0 means that a null model will not be applied
    'ProjectionType', 'centroid',... % projection approach to be used while computing the PSIs
    'CenterFormula', 'mean'); % center formula for calculating the centroids while executing the PSIs

psisApproaches(3) = {'Centroid-based (mode)'};
psisCentroidMode = ProcessValidityIndices(embeddding, species, positives,...
    'Indices', 1,... % only PSI indices
    'Trustworthiness', 0,... % here, 0 means that a null model will not be applied
    'ProjectionType', 'centroid',... % projection approach to be used while computing the PSIs
    'CenterFormula', 'mode'); % center formula for calculating the centroids while executing the PSIs

psisApproaches(4) = {'LDA-based'};
psisLda = ProcessValidityIndices(embeddding, species, positives,...
    'Indices', 1,... % only PSI indices
    'Trustworthiness', 0,... % here, 0 means that a null model will not be applied
    'ProjectionType', 'lda'); % projection approach to be used while computing the PSIs

T = table();
T = [T; struct2table(psisCentroidMedian)];
T = [T; struct2table(psisCentroidMean)];
T = [T; struct2table(psisCentroidMode)];
T = [T; struct2table(psisLda)];
T.Properties.RowNames = psisApproaches;

disp(T);