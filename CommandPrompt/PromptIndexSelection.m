function SelectedIndexes = PromptIndexSelection()
	SelectedIndexes = [];
	correct = false;

	while ~correct
		fprintf('\nAvailable indexes:\n');
		fprintf('[1] Projection Separability Index (PSI)\n');
		fprintf('[2] Dunn Index (DN)\n');
		fprintf('[3] Davies-Bouldin Index (DB)\n');
		fprintf('[4] Bezdek Index (BZ)\n');
		fprintf('[5] Calinski and Harabasz Index (CH)\n');
		fprintf('[6] Silhouette Index (SH)\n');
		fprintf('[7] Thornton Separability Index (TH)\n');
		fprintf('# Select your indexes (range between 1:7)\n');
		SelectedIndexes = input('-> ');
		if isempty(SelectedIndexes)
            SelectedIndexes = 1:7;
            correct = true;
        elseif max(SelectedIndexes) <= 7 && min(SelectedIndexes) >= 1
        	if length(SelectedIndexes) == 1
        		SelectedIndexes = [SelectedIndexes];
        	end
            correct = true;
        else
            fprintf('\n[x] Invalid value. Please try again\n');
        end
	end
end