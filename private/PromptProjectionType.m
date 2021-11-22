function SelectedProjectionType = PromptProjectionType()
correct = false;

while ~correct
    fprintf('\nPSIs projection type:\n');
    fprintf('[1] Centroid based (default)\n');
    fprintf('[2] Linear Discriminant Analyses (LDA) based\n');
    selected = input('-> ');
    if isempty(selected) || selected == 1
        SelectedProjectionType = 'centroid';
        correct = true;
    elseif (selected == 2)
        SelectedProjectionType = 'lda';
        correct = true;
    else
        fprintf('\n[x] Invalid value. Please try again\n');
    end
end