function indices = ApplyValidityIndices(SelectedIndices, ProcessData)
for mi=1:length(SelectedIndices)
	CurrentIndex = SelectedIndices(mi);

	switch CurrentIndex
		case 1
			[indices.PSIP, indices.PSIROC, indices.PSIPR, indices.PSIMCC, ~, ~] = ProjectionSeparabilityIndex(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.PositiveClasses, 'median');
		case 2
			indices.DI = DunnIndex(ProcessData.DataMatrix, ProcessData.SampleLabels, 'euclidean');
		case 3
			[rawDB, ~] = DaviesBouldinIndex(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
			indices.DB = 1/(1+rawDB); % Inverting the value
		case 4
			indices.GDI = GeneralizedDunnIndex(ProcessData.GeneratedClusters);
		case 5
			indices.CH = CalinskiHarabaszIndex(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
		case 6
			indices.SIL = SilhouetteIndex(ProcessData.NumericSampleLabels, ProcessData.DataMatrix, ProcessData.LenUniqueLabels);
		case 7
			indices.GSI = GeometricSeparabilityIndex(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.UniqueSampleLabels, ProcessData.LenUniqueLabels);
		case 8
			indices.CVDD = CVDDIndex(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
		otherwise
			error('Undefined; this index is not available');
	end
end