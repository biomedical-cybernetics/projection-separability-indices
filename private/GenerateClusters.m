function [GeneratedClusters, NumberOfClusters, SortedLabels] = GenerateClusters(DataMatrix, SampleLabels, UniqueSampleLabels, LenUniqueLabels)
    SortedLabels = [];
    for k=1:LenUniqueLabels
        idx = find(ismember(SampleLabels, UniqueSampleLabels{k}));
        SortedLabels = vertcat(SortedLabels, SampleLabels(idx));
        GeneratedClusters{k} = DataMatrix(idx,:);
    end
    NumberOfClusters = length(GeneratedClusters);
end