import unittest

import pandas as pd
import numpy as np

from projection_separability_index import ProjectionSeparabilityIndex


class TestProjectionSeparabilityIndex(unittest.TestCase):

    def test_perfect_separation(self):
        input_matrix = np.array([[1, 2], [3, 4], [5, 6], [7, 8], [10, 11], [12, 13], [14, 15], [16, 17]])
        input_labels = np.array(
            ['sample1', 'sample1', 'sample1', 'sample1', 'sample2', 'sample2', 'sample2', 'sample2'])
        input_positive = np.array(['sample1'])
        input_formula = 'median'

        expected_psi_p = 0.0286
        expected_psi_roc = 1.0000
        expected_psi_pr = 1.0000
        expected_psi_mcc = 1.0000

        psi = ProjectionSeparabilityIndex(input_matrix, input_labels, input_positive, input_formula)
        actual_psi_p, actual_psi_roc, actual_psi_pr, actual_psi_mcc = psi.calculate()

        self.assertEqual(expected_psi_p, round(actual_psi_p, 4))
        self.assertEqual(expected_psi_roc, round(actual_psi_roc, 4))
        self.assertEqual(expected_psi_pr, round(actual_psi_pr, 4))
        self.assertEqual(expected_psi_mcc, round(actual_psi_mcc, 4))
