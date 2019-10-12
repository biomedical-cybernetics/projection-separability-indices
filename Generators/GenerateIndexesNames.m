function IndexesNames = GenerateIndexesNames(SelectedIndexes)
	SupportedIndexes = {'psi', 'dn', 'db', 'bz', 'ch', 'sh', 'th'};
	SelectedIndexes = SupportedIndexes(SelectedIndexes);

	if any(ismember(SelectedIndexes, 'psi'))
		SelectedIndexes(ismember(SelectedIndexes, 'psi')) = [];
		SelectedIndexes = horzcat({'psip', 'psiroc', 'psipr'}, SelectedIndexes);
	end

	IndexesNames = SelectedIndexes;
end