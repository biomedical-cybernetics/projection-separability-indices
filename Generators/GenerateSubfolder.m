function SubfolderPath = GenerateSubfolder(folderName)
    if (exist(folderName,'dir')~=7)
        try    
            mkdir(folderName);
            SubfolderPath = folderName;
        catch
            error(sprintf('Oops! impossible to create the subfolder; %s', folderName));
        end
    else
        SubfolderPath = folderName;
    end
end