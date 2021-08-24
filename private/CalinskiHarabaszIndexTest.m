function tests = CalinskiHarabaszIndexTest
    tests = functiontests(localfunctions);
end

function TestPerfectSeparation(testCase)
    input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    input.numericSamples = findgroups(input.samples);
    input.lenUniqueSamples = numel(unique(input.samples));
    expSolution = 24.3;
    actSolution = CalinskiHarabaszIndex(input.matrix, input.numericSamples);
    verifyEqual(testCase, expSolution, round(actSolution, 4));
end

function TestMixedSeparation(testCase)
    input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample2','sample1','sample1','sample1','sample2','sample2','sample2','sample1'}';
    input.numericSamples = findgroups(input.samples);
    input.lenUniqueSamples = numel(unique(input.samples));
    expSolution = 0.1367;
    actSolution = CalinskiHarabaszIndex(input.matrix, input.numericSamples);
    verifyEqual(testCase, expSolution, round(actSolution, 4));
end

function TestNoSeparation(testCase)
    input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample2','sample1','sample2','sample1','sample2','sample1','sample2'}';
    input.numericSamples = findgroups(input.samples);
    input.lenUniqueSamples = numel(unique(input.samples));
    expSolution = 0.2474;
    actSolution = CalinskiHarabaszIndex(input.matrix, input.numericSamples);
    verifyEqual(testCase, expSolution, round(actSolution, 4));
end