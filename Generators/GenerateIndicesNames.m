function IndicesNames = GenerateIndicesNames(SelectedIndices)
	SupportedIndices = {'psi', 'dn', 'db', 'bz', 'ch', 'sh', 'th'};
	SelectedIndices = SupportedIndices(SelectedIndices);

	if any(ismember(SelectedIndices, 'psi'))
		SelectedIndices(ismember(SelectedIndices, 'psi')) = [];
		SelectedIndices = horzcat({'psip', 'psiroc', 'psipr'}, SelectedIndices);
	end

	IndicesNames = SelectedIndices;
end