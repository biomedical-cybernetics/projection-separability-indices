function SelectedIndices = PromptIndexSelection()
SelectedIndices = [];
correct = false;

while ~correct
    fprintf('\nAvailable indices:\n');
    fprintf('[1] Projection Separability Indices (PSIs)\n');
    fprintf('[2] Dunn Index (DI)\n');
    fprintf('[3] Davies-Bouldin Index (DB)\n');
    fprintf('[4] Generalized Dunn Index (GDI)\n');
    fprintf('[5] Calinski and Harabasz Index (CH)\n');
    fprintf('[6] Silhouette Index (SIL)\n');
    fprintf('[7] Geometric Separability Index (GSI)\n');
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