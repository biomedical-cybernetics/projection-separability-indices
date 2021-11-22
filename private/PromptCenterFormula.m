function SelectedCenterFormula = PromptCenterFormula()
correct = false;

while ~correct
    fprintf('\nPSIs centroid formula:\n');
    fprintf('[1] Median (default)\n');
    fprintf('[2] Mean\n');
    fprintf('[3] Mode\n');
    selected = input('-> ');
    if isempty(selected) || selected == 1
        SelectedCenterFormula = 'median';
        correct = true;
    elseif (selected == 2)
        SelectedCenterFormula = 'mean';
        correct = true;
    elseif (selected == 3)
        SelectedCenterFormula = 'mode';
        correct = true;
    else
        fprintf('\n[x] Invalid value. Please try again\n');
    end
end