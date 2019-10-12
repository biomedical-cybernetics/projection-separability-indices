function indexes = GenerateIndexesValues(SelectedIndexes, ProcessData)
	for mi=1:length(SelectedIndexes)
		CurrentIndex = SelectedIndexes(mi);

		switch CurrentIndex
			case 1
				[indexes.psip, indexes.psiroc, indexes.psipr, ~, ~] = ProjectionSeparabilityIndex(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.PositiveClasses, ProcessData.Dimensions, 'median');
			case 2
				indexes.dn = indexDN(ProcessData.DataMatrix, ProcessData.SampleLabels, 'euclidean');
			case 3
				db = db_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
				indexes.db = 1/(1+db); % Inverting the value
			case 4
				indexes.bz = bezdek_index_n(ProcessData.GeneratedClusters);
			case 5
				indexes.ch = cal_har_k_index(ProcessData.DataMatrix, ProcessData.NumericSampleLabels);
			case 6
				sh = silhouette(ProcessData.DataMatrix, ProcessData.NumericSampleLabels, 'Euclidean');
				indexes.sh = mean(sh); % Getting the mean of the values
			case 7
				indexes.th = thornton(ProcessData.DataMatrix, ProcessData.SampleLabels, ProcessData.UniqueSampleLabels, ProcessData.LenUniqueLabels);
			otherwise
				error('Undefined; this index is not available');
		end
	end
end