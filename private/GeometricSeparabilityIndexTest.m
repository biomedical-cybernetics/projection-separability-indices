function tests = GeometricSeparabilityIndexTest
    tests = functiontests(localfunctions);
end

function TestPerfectSeparation(testCase)
    input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    expSolution = 1;
    actSolution = GeometricSeparabilityIndex(input.matrix, input.samples, NaN, NaN);
    verifyEqual(testCase, expSolution, actSolution);
end

function TestMixedSeparation(testCase)
    input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample2','sample1','sample1','sample1','sample2','sample2','sample2','sample1'}';
    expSolution = 0.625;
    actSolution = GeometricSeparabilityIndex(input.matrix, input.samples, NaN, NaN);
    verifyEqual(testCase, expSolution, actSolution);
end

function TestNoSeparation(testCase)
    input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample2','sample1','sample2','sample1','sample2','sample1','sample2'}';
    expSolution = 0;
    actSolution = GeometricSeparabilityIndex(input.matrix, input.samples, NaN, NaN);
    verifyEqual(testCase, expSolution, actSolution);
end