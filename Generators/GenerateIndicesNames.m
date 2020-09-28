function IndicesNames = GenerateIndicesNames(SelectedIndices)
	SupportedIndices = {'PSI', 'DI', 'DB', 'GDI', 'CH', 'SIL', 'GSI', 'CVDD'};
	SelectedIndices = SupportedIndices(SelectedIndices);

	if any(ismember(SelectedIndices, 'PSI'))
		SelectedIndices(ismember(SelectedIndices, 'PSI')) = [];
		SelectedIndices = horzcat({'PSIP', 'PSIROC', 'PSIPR'}, SelectedIndices);
	end

	IndicesNames = SelectedIndices;
end