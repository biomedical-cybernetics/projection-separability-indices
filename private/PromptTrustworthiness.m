function [ApplyTrustworthiness, NumberOfIterations] = PromptTrustworthiness()
ApplyTrustworthiness = false;
NumberOfIterations = 0;

correct = false;
while ~correct
    fprintf('\nWould you like to apply trustworthiness (null model)?:\n');
    fprintf('[y] Yes\n');
    fprintf('[n] No\n');
    ApplyTrustworthiness = input('-> ', 's');
    if strcmp(ApplyTrustworthiness, 'y')
        ApplyTrustworthiness = true;
        correct = true;
    elseif strcmp(ApplyTrustworthiness, 'n')
        ApplyTrustworthiness = false;
        correct = true;
    else
        fprintf('\n[x] Invalid value. Please try again\n');
    end
end

if ApplyTrustworthiness
    correct = false;
    while ~correct
        fprintf('\nHow many iterations should be applied?:\n');
        fprintf('# Enter a number higher than 0\n');
        NumberOfIterations = input('-> ');
        if NumberOfIterations > 0
            correct = true;
        else
            fprintf('\n[x] Invalid value. Please try again\n');
        end
    end
end