function Trustworthiness = ApplyTrustworthiness(NumberOfIterations, SelectedIndices, ProcessData, IndicesValues)
NumberOfSampleLabels = numel(ProcessData.SampleLabels);
randGenerator = parallel.pool.Constant(RandStream.getGlobalStream());

parfor ix=1:NumberOfIterations
    stream = randGenerator.Value;
    if (stream.Seed ~= 0)
        stream.Substream = ix;
    end
    idxs = randperm(stream, NumberOfSampleLabels);

    PermutedData = struct;
    PermutedData.DataMatrix = ProcessData.DataMatrix;
    PermutedData.SampleLabels = ProcessData.SampleLabels(idxs);
    PermutedData.PositiveClasses = ProcessData.PositiveClasses;
    PermutedData.UniqueSampleLabels = ProcessData.UniqueSampleLabels;
    PermutedData.LenUniqueLabels = ProcessData.LenUniqueLabels;
    PermutedData.NumericSampleLabels = ProcessData.NumericSampleLabels(idxs);
    PermutedData.GeneratedClusters = GenerateClusters(PermutedData.DataMatrix, PermutedData.SampleLabels, PermutedData.UniqueSampleLabels, PermutedData.LenUniqueLabels);
    PermutedData.Dimensions = ProcessData.Dimensions;

    ProcessFields{ix} = PermutedData;

    ModelResults(ix) = ApplyValidityIndices(SelectedIndices, ProcessFields{ix});
end

IndicesNames = GenerateIndicesNames(SelectedIndices);

for ix=1:length(IndicesNames)
    IndexName = IndicesNames{ix};
    IndexValue = IndicesValues.(IndexName);
    IndexPermutations = [ModelResults.(IndexName)];

    if strcmp(IndexName, 'PSIP')
        PValue = (sum(IndexPermutations < IndexValue)+1)/(NumberOfIterations+1);
    else
        PValue = (sum(IndexPermutations > IndexValue)+1)/(NumberOfIterations+1);
    end

    Trustworthiness.(IndexName).IndexValue = IndexValue;
    Trustworthiness.(IndexName).IndexPermutations = IndexPermutations;
    Trustworthiness.(IndexName).MaxValue = max(IndexPermutations);
    Trustworthiness.(IndexName).MinValue = min(IndexPermutations);
    Trustworthiness.(IndexName).MeanValue = mean(IndexPermutations);
    Trustworthiness.(IndexName).StandardDeviation = std(IndexPermutations)/sqrt(NumberOfIterations);
    Trustworthiness.(IndexName).PValue = PValue;
end