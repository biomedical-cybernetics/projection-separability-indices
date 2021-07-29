from scipy.spatial.distance import cdist
from scipy.stats._mannwhitneyu import mannwhitneyu
import numpy as np


class ProjectionSeparabilityIndex:
    def __init__(self, data_matrix, sample_labels, positive_classes, center_formula):
        self.data_matrix = data_matrix
        self.sample_labels = sample_labels
        self.positive_classes = positive_classes
        self.center_formula = center_formula

    def __nchoosek(self, n, k):
        if k == 0:
            r = 1
        else:
            r = n / k * self.__nchoosek(n - 1, k - 1)
        return round(r)

    def __create_line_between_centroids(self, centroid1, centroid2):
        return np.vstack([centroid1, centroid2])

    def __project_points_on_line(self, point, line):
        # centroids
        A = line[0]
        B = line[1]

        # deltas
        AP = point - A
        AB = B - A

        # projection
        projected_point = A + np.dot(AP, AB) / np.dot(AB, AB) * AB

        return projected_point

    def __convert_points_to_one_dimension(self, points):
        for ix in range(points.ndim):
            if np.unique(points[:, ix]).size != 1:
                start_point = np.array(points[np.argmin(points[:, ix], axis=0), :]).reshape(1, points.ndim)
                break

        V = np.zeros(np.shape(points)[0])
        for ix in range(points.ndim):
            V = np.add(V, np.power(points[:, ix] - np.min(start_point[:, ix]), 2))

        V = np.sqrt(V)

        return V

    def calculate(self):
        # obtaining unique sample labels
        unique_labels = np.unique(self.sample_labels);
        number_unique_labels = len(unique_labels);

        # checking range of dimensions
        dimensions_number = self.data_matrix.ndim

        # clustering data according to sample labels
        sorted_labels = np.empty([0], dtype=str)
        data_clustered = list()
        for k in range(number_unique_labels):
            idxes = np.where(self.sample_labels == unique_labels[k])
            sorted_labels = np.append(sorted_labels, self.sample_labels[idxes])
            data_clustered.append(self.data_matrix[idxes])

        n = 0
        m = 1
        if self.center_formula != 'mean' and self.center_formula != 'median' and self.center_formula != 'mode':
            # TODO: warning('your center formula is not valid: median will be applied')
            self.center_formula = 'median'

        pairwise_group_combinations = self.__nchoosek(number_unique_labels, 2)

        mann_whitney_values = np.empty([0])

        for index_group_combination in range(pairwise_group_combinations):
            if self.center_formula == 'median':
                centroid_cluster_1 = np.median(data_clustered[n], axis=0)
                centroid_cluster_2 = np.median(data_clustered[m], axis=0)

            # TODO: mean and mode

            if (centroid_cluster_1 == centroid_cluster_2).all():
                raise RuntimeError('clusters have the same centroid: no line can be traced between them')

            clusters_line = self.__create_line_between_centroids(centroid_cluster_1, centroid_cluster_2);

            clusters_projections = [np.empty([0, dimensions_number])] * 2
            for o in range(np.shape(data_clustered[n])[0]):
                proj = self.__project_points_on_line(data_clustered[n][o], clusters_line)
                clusters_projections[n] = np.vstack([clusters_projections[n], proj])
            for o in range(np.shape(data_clustered[m])[0]):
                proj = self.__project_points_on_line(data_clustered[m][o], clusters_line)
                clusters_projections[m] = np.vstack([clusters_projections[m], proj])

            size_cluster_n = len(data_clustered[n])
            size_cluster_m = len(data_clustered[m])

            cluster_projection_1d = self.__convert_points_to_one_dimension(
                np.vstack([clusters_projections[n], clusters_projections[m]]))

            dp_scores_cluster_1 = cluster_projection_1d[0:size_cluster_n]
            dp_scores_cluster_2 = cluster_projection_1d[size_cluster_n:size_cluster_n + size_cluster_m]

            mw = mannwhitneyu(dp_scores_cluster_1, dp_scores_cluster_2, method="exact")
            mann_whitney_values = np.append(mann_whitney_values, mw.pvalue)

            m = m + 1
            if m > number_unique_labels:
                n = n + 1
                m = n + 1

        psi_p = (np.mean(mann_whitney_values) + np.std(mann_whitney_values)) / (np.std(mann_whitney_values) + 1)

        return psi_p
