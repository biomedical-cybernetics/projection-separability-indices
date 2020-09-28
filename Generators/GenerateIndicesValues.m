function indices = GenerateIndicesValues(SelectedIndices, ProcessData)
	for mi=1:length(SelectedIndices)
		CurrentIndex = SelectedIndices(mi);

		switch CurrentIndex
			case 1
				[indices.PSIP, indices.PSIROC, indices.PSIPR, indices.PSIMCC, ~, ~] = ProjectionSeparabilityIndex(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.PositiveClasses, 'median');
			case 2
				indices.DI = dunn_index(ProcessData.DataMatrix, ProcessData.SampleLabels, 'euclidean');
			case 3
				rawDB = db_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
				indices.DB = 1/(1+rawDB); % Inverting the value
			case 4
				indices.GDI = bezdek_index_n(ProcessData.GeneratedClusters);
			case 5
				indices.CH = cal_har_k_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
			case 6
				indices.SIL = silhouetteIndex(ProcessData.NumericSampleLabels, ProcessData.DataMatrix, ProcessData.LenUniqueLabels);
			case 7
				indices.GSI = thornton(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.UniqueSampleLabels, ProcessData.LenUniqueLabels);
			case 8
				indices.CVDD = cvdd_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
			otherwise
				error('Undefined; this index is not available');
		end
	end
end