function [ApplyNullModel, NumberOfIterations] = PromptNullModel()
	ApplyNullModel = false;
	NumberOfIterations = 0;
	
	correct = false;
	while ~correct
		fprintf('\nWould you like to apply a null model?:\n');
		fprintf('[y] Yes\n');
		fprintf('[n] No\n');
		ApplyNullModel = input('-> ', 's');
		if strcmp(ApplyNullModel, 'y')
            ApplyNullModel = true;
            correct = true;
        elseif strcmp(ApplyNullModel, 'n')
            ApplyNullModel = false;
            correct = true;
        else
            fprintf('\n[x] Invalid value. Please try again\n');
        end
	end

	if ApplyNullModel
		correct = false;
		while ~correct
			fprintf('\nHow many iteration should be applied?:\n');
			fprintf('# Enter a number higher than 0\n');
			NumberOfIterations = input('-> ');
			if NumberOfIterations > 0
	            correct = true;
	        else
	            fprintf('\n[x] Invalid value. Please try again\n');
	        end
		end
	end
end