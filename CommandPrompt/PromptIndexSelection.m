function SelectedIndices = PromptIndexSelection()
	SelectedIndices = [];
	correct = false;

	while ~correct
		fprintf('\nAvailable indices:\n');
		fprintf('[1] Projection Separability Index (PSI)\n');
		fprintf('[2] Dunn Index (DN)\n');
		fprintf('[3] Davies-Bouldin Index (DB)\n');
		fprintf('[4] Bezdek Index (BZ)\n');
		fprintf('[5] Calinski and Harabasz Index (CH)\n');
		fprintf('[6] Silhouette Index (SH)\n');
		fprintf('[7] Thornton Separability Index (TH)\n');
		fprintf('[8] Cluster Validity Density-involved Distance (CVDD)\n');
		fprintf('# Select your indices (range between 1:7)\n');
		SelectedIndices = input('-> ');
		if isempty(SelectedIndices)
            SelectedIndices = 1:8;
            correct = true;
        elseif max(SelectedIndices) <= 8 && min(SelectedIndices) >= 1
        	if length(SelectedIndices) == 1
        		SelectedIndices = [SelectedIndices];
        	end
            correct = true;
        else
            fprintf('\n[x] Invalid value. Please try again\n');
        end
	end
end