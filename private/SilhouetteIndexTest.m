function tests = SilhouetteIndexTest
    tests = functiontests(localfunctions);
end

function TestPerfectSeparation(testCase)
	input.matrix = [1 2; 3 4; 5 6; 7 8; 10 11; 12 13; 14 15; 16 17];
    input.samples = {'sample1','sample1','sample1','sample1','sample2','sample2','sample2','sample2'}';
    input.numericSamples = findgroups(input.samples);
    input.lenUniqueSamples = numel(unique(input.samples));
    expSolution = 0.8068;
    actSolution = SilhouetteIndex(input.numericSamples, input.matrix, input.lenUniqueSamples);
    verifyEqual(testCase, expSolution, round(actSolution, 4));
end