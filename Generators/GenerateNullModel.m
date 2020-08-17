function NullModel = GenerateNullModel(NumberOfIterations, SelectedIndices, ProcessData, IndicesValues)
    NumberOfSampleLabels = numel(ProcessData.SampleLabels);
    
    parfor ix=1:NumberOfIterations
        idxs = randperm(NumberOfSampleLabels);

        PermutedData = struct;
        PermutedData.DataMatrix = ProcessData.DataMatrix;
        PermutedData.SampleLabels = ProcessData.SampleLabels(idxs);
        PermutedData.PositiveClasses = ProcessData.PositiveClasses;
        PermutedData.UniqueSampleLabels = ProcessData.UniqueSampleLabels;
        PermutedData.LenUniqueLabels = ProcessData.LenUniqueLabels;
        PermutedData.NumericSampleLabels = GenerateNumericLabels(PermutedData.SampleLabels, PermutedData.UniqueSampleLabels, PermutedData.LenUniqueLabels);
        PermutedData.GeneratedClusters = GenerateClusters(PermutedData.DataMatrix, PermutedData.SampleLabels, PermutedData.UniqueSampleLabels, PermutedData.LenUniqueLabels);
        PermutedData.Dimensions = ProcessData.Dimensions;

        ProcessFields{ix} = PermutedData;
        
        ModelResults(ix) = GenerateIndicesValues(SelectedIndices, ProcessFields{ix});
    end

    IndicesNames = GenerateIndicesNames(SelectedIndices); 

    for ix=1:length(IndicesNames)
        IndexName = IndicesNames{ix};
        IndexValue = IndicesValues.(IndexName);
        IndexPermutations = [ModelResults.(IndexName)];

        if strcmp(IndexName, 'psip')
            PValue = (sum(IndexPermutations < IndexValue)+1)/(NumberOfIterations+1);
        else
            PValue = (sum(IndexPermutations > IndexValue)+1)/(NumberOfIterations+1);
        end

        NullModel.(IndexName).IndexPermutations = IndexPermutations;
        NullModel.(IndexName).MaxValue = max(IndexPermutations);
        NullModel.(IndexName).MinValue = min(IndexPermutations);
        NullModel.(IndexName).MeanValue = mean(IndexPermutations);
        NullModel.(IndexName).StandardDeviation = std(IndexPermutations)/sqrt(NumberOfIterations);
        NullModel.(IndexName).PValue = PValue;
    end
end