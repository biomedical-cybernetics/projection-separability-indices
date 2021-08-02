function tests = ProjectionSeparabilityIndexTest
    tests = functiontests(localfunctions);
end

function TestMulticlassPerfectSeparation(testCase)
	input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample1','sample2','sample2','sample3','sample3','sample4','sample4'}';
    input.positive = {'sample2', 'sample3', 'sample4'};
    input.formula = 'median';
    
    expected.psiP = 0.3333;
    expected.psiROC = 1.0000;
    expected.psiPR = 1.0000;
    expected.psiMCC = 1.0000;
    expected.dataClustered = {[1 2; 3 4], [5 6; 7 8], [10 11; 12 13], [14 15; 16 17]};
    expected.sortedLabels = {'sample1','sample1','sample2','sample2','sample3','sample3','sample4','sample4'}';
    
    [actual.psiP, actual.psiROC, actual.psiPR, actual.psiMCC, actual.dataClustered, actual.sortedLabels] = ProjectionSeparabilityIndex(input.matrix, input.samples, input.positive, input.formula);
    
    verifyEqual(testCase, round(actual.psiP, 4), expected.psiP);
    verifyEqual(testCase, round(actual.psiROC, 4), expected.psiROC);
    verifyEqual(testCase, round(actual.psiPR, 4), expected.psiPR);
    verifyEqual(testCase, round(actual.psiMCC, 4), expected.psiMCC);
    verifyEqual(testCase, actual.dataClustered, expected.dataClustered);
    verifyEqual(testCase, actual.sortedLabels, expected.sortedLabels);
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

function TestMixedSeparation(testCase)
	input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample2','sample1','sample1','sample1','sample2','sample2','sample2','sample1'}';
    input.positive = {'sample1'};
    input.formula = 'median';
    
    expected.psiP = 0.8857;
    expected.psiROC = 0.5625;
    expected.psiPR = 0.5015;
    expected.psiMCC = 0.5000;
    expected.dataClustered = {[3 4; 5 6; 7 8; 16 17], [1 2; 10 11; 12 13; 14 15]};
    expected.sortedLabels = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    
    [actual.psiP, actual.psiROC, actual.psiPR, actual.psiMCC, actual.dataClustered, actual.sortedLabels] = ProjectionSeparabilityIndex(input.matrix, input.samples, input.positive, input.formula);
    
    verifyEqual(testCase, round(actual.psiP, 4), expected.psiP);
    verifyEqual(testCase, round(actual.psiROC, 4), expected.psiROC);
    verifyEqual(testCase, round(actual.psiPR, 4), expected.psiPR);
    verifyEqual(testCase, round(actual.psiMCC, 4), expected.psiMCC);
    verifyEqual(testCase, actual.dataClustered, expected.dataClustered);
    verifyEqual(testCase, actual.sortedLabels, expected.sortedLabels);
end

function TestNoSeparation(testCase)
	input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample2','sample1','sample2','sample1','sample2','sample1','sample2'}';
    input.positive = {'sample1'};
    input.formula = 'median';
    
    expected.psiP = 0.6857;
    expected.psiROC = 0.6250;
    expected.psiPR = 0.6673;
    expected.psiMCC = 0.0000;
    expected.dataClustered = {[1 2; 5 6; 10 11; 14 15], [3 4; 7 8; 12 13; 16 17]};
    expected.sortedLabels = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    
    [actual.psiP, actual.psiROC, actual.psiPR, actual.psiMCC, actual.dataClustered, actual.sortedLabels] = ProjectionSeparabilityIndex(input.matrix, input.samples, input.positive, input.formula);
    
    verifyEqual(testCase, round(actual.psiP, 4), expected.psiP);
    verifyEqual(testCase, round(actual.psiROC, 4), expected.psiROC);
    verifyEqual(testCase, round(actual.psiPR, 4), expected.psiPR);
    verifyEqual(testCase, round(actual.psiMCC, 4), expected.psiMCC);
    verifyEqual(testCase, actual.dataClustered, expected.dataClustered);
    verifyEqual(testCase, actual.sortedLabels, expected.sortedLabels);
end