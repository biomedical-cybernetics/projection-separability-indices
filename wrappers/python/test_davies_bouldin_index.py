import unittest
import numpy as np

from davies_bouldin_index import DaviesBouldinIndex


class TestSilhouetteIndex(unittest.TestCase):

    def test_perfect_separation(self):
        input_matrix = np.array([[1, 2], [3, 4], [5, 6], [7, 8], [10, 11], [12, 13], [14, 15], [16, 17]])
        input_labels = np.array(
            ['sample1', 'sample1', 'sample1', 'sample1', 'sample2', 'sample2', 'sample2', 'sample2'])
        expected_value = 0.4444444444444444
        actual_value = DaviesBouldinIndex.calculate(input_matrix, input_labels)
        self.assertEqual(expected_value, actual_value)


if __name__ == '__main__':
    unittest.main()