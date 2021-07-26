import unittest

import pandas as pd
import numpy as np

from geometrical_separability_index import GeometricalSeparabilityIndex


class TestGeometricalSeparabilityIndex(unittest.TestCase):

    def test_perfect_separation(self):
        input_matrix = np.array([[1, 2], [3, 4], [5, 6], [7, 8], [10, 11], [12, 13], [14, 15], [16, 17]])
        input_labels = np.array(
            ['sample1', 'sample1', 'sample1', 'sample1', 'sample2', 'sample2', 'sample2', 'sample2'])
        expected_value = 1
        actual_value = GeometricalSeparabilityIndex.calculate(input_matrix, input_labels)
        self.assertEqual(expected_value, actual_value)

    def test_mixed_separation(self):
        input_matrix = np.array([[1, 2], [3, 4], [5, 6], [7, 8], [10, 11], [12, 13], [14, 15], [16, 17]])
        input_labels = np.array(
            ['sample2', 'sample1', 'sample1', 'sample1', 'sample2', 'sample2', 'sample2', 'sample1'])
        expected_value = 0.625
        actual_value = GeometricalSeparabilityIndex.calculate(input_matrix, input_labels)
        self.assertEqual(expected_value, actual_value)

    def test_no_separation(self):
        input_matrix = np.array([[1, 2], [3, 4], [5, 6], [7, 8], [10, 11], [12, 13], [14, 15], [16, 17]])
        input_labels = np.array(
            ['sample1', 'sample2', 'sample1', 'sample2', 'sample1', 'sample2', 'sample1', 'sample2'])
        expected_value = 0.0
        actual_value = GeometricalSeparabilityIndex.calculate(input_matrix, input_labels)
        self.assertEqual(expected_value, actual_value)


if __name__ == '__main__':
    unittest.main()
