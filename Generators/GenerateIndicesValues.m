function indices = GenerateIndicesValues(SelectedIndices, ProcessData)
	for mi=1:length(SelectedIndices)
		CurrentIndex = SelectedIndices(mi);

		switch CurrentIndex
			case 1
				[indices.psip, indices.psiroc, indices.psipr, ~, ~] = ProjectionSeparabilityIndex(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.PositiveClasses, 'median');
			case 2
				indices.dn = indexDN(ProcessData.DataMatrix, ProcessData.SampleLabels, 'euclidean');
			case 3
				db = db_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
				indices.db = 1/(1+db); % Inverting the value
			case 4
				indices.bz = bezdek_index_n(ProcessData.GeneratedClusters);
			case 5
				indices.ch = cal_har_k_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
			case 6
				indices.sh = silhouetteIndex(ProcessData.NumericSampleLabels, ProcessData.DataMatrix, ProcessData.LenUniqueLabels);
			case 7
				indices.th = thornton(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.UniqueSampleLabels, ProcessData.LenUniqueLabels);
			otherwise
				error('Undefined; this index is not available');
		end
	end
end