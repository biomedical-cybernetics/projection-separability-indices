function names = GenerateNumericLabels(SampleLabels, UniqueSampleLabels, LenUniqueLabels)
    names = SampleLabels;
    for ix=1:LenUniqueLabels
        if isempty(str2num(UniqueSampleLabels{ix}))
            names = regexprep(names,strcat('^',UniqueSampleLabels{ix},'$'),num2str(ix));
        else
            names = cellfun(@str2num, names, 'UniformOutput', false);
            break;
        end
    end
    
    try
        names = cell2mat(names);
        if ~isnumeric(names)
            names = str2num(names);
        end
    catch
        names = str2double(names);
    end
    
    if (any(names < 1)) names = names+1; end
end