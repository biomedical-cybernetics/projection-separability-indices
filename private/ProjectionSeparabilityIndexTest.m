function tests = ProjectionSeparabilityIndexTest
    tests = functiontests(localfunctions);
end

function TestPerfectSeparation(testCase)
	input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    input.positive = {'sample1'};
    input.formula = 'median';
    
    expected.psiP = 0.0286;
    expected.psiROC = 1;
    expected.psiPR = 1;
    expected.psiMCC = 1;
    expected.dataClustered = {[1 2; 3 4; 5 6; 7 8], [10 11; 12 13; 14 15; 16 17]};
    expected.sortedLabels = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    
    [actual.psiP, actual.psiROC, actual.psiPR, actual.psiMCC, actual.dataClustered, actual.sortedLabels] = ProjectionSeparabilityIndex(input.matrix, input.samples, input.positive, input.formula);
    
    verifyEqual(testCase, round(actual.psiP, 4), expected.psiP);
    verifyEqual(testCase, round(actual.psiROC, 4), expected.psiROC);
    verifyEqual(testCase, round(actual.psiPR, 4), expected.psiPR);
    verifyEqual(testCase, round(actual.psiMCC, 4), expected.psiMCC);
    verifyEqual(testCase, actual.dataClustered, expected.dataClustered);
    verifyEqual(testCase, actual.sortedLabels, expected.sortedLabels);
end