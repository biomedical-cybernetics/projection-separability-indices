import warnings
import numpy as np
from scipy import stats
from sklearn import metrics


class ProjectionSeparabilityIndex:
    def __init__(self, data_matrix, sample_labels, positive_classes=None, center_formula='median'):
        self.data_matrix = data_matrix
        self.sample_labels = sample_labels
        self.center_formula = center_formula
        if positive_classes is not None:
            self.positive_classes = positive_classes
        else:
            self.__set_positive_classes()

    # noinspection PyMethodMayBeStatic
    def __set_positive_classes(self):
        positives, positions = np.unique(self.sample_labels, return_inverse=True)
        max_pos = np.bincount(positions).argmax()
        positives = np.delete(positives, max_pos)
        self.positive_classes = positives

    # noinspection PyMethodMayBeStatic
    def __mode_distribution(self, data_clustered):
        mode_dist = np.empty([0])
        for ix in range(data_clustered.ndim):
            kde = stats.gaussian_kde(data_clustered[:, ix])
            xi = np.linspace(data_clustered.min(), data_clustered.max(), 100)
            p = kde(xi)
            ind = np.argmax([p])
            mode_dist = np.append(mode_dist, xi[ind])
        return mode_dist

    # noinspection PyMethodMayBeStatic
    def __nchoosek(self, n, k):
        if k == 0:
            r = 1
        else:
            r = n / k * self.__nchoosek(n - 1, k - 1)
        return round(r)

    # noinspection PyMethodMayBeStatic
    def __create_line_between_centroids(self, centroid1, centroid2):
        line = np.vstack([centroid1, centroid2])
        return line

    # noinspection PyMethodMayBeStatic
    def __project_points_on_line(self, point, line):
        # centroids
        a = line[0]
        b = line[1]

        # deltas
        ap = point - a
        ab = b - a

        # projection
        projected_point = a + np.dot(ap, ab) / np.dot(ab, ab) * ab

        return projected_point

    # noinspection PyMethodMayBeStatic
    def __convert_points_to_one_dimension(self, points):
        start_point = None
        for ix in range(points.ndim):
            if np.unique(points[:, ix]).size != 1:
                start_point = np.array(points[np.argmin(points[:, ix], axis=0), :]).reshape(1, points.ndim)
                break

        if start_point is None:
            raise RuntimeError('impossible to set projection starting point')

        v = np.zeros(np.shape(points)[0])
        for ix in range(points.ndim):
            v = np.add(v, np.power(points[:, ix] - np.min(start_point[:, ix]), 2))

        v = np.sqrt(v)

        return v

    # noinspection PyMethodMayBeStatic
    def __compute_mannwhitney(self, scores_c1, scores_c2):
        mw = stats.mannwhitneyu(scores_c1, scores_c2, method="exact")
        return mw

    # noinspection PyMethodMayBeStatic
    def __compute_auc_aupr(self, labels, scores, positives):
        fpr, tpr, thresholds = metrics.roc_curve(labels, scores, pos_label=positives)
        auc = metrics.auc(fpr, tpr)
        if auc < 0.5:
            auc = 1 - auc
            flipped_scores = 2 * np.mean(scores) - scores
            precision, recall, thresholds = metrics.precision_recall_curve(labels, flipped_scores, pos_label=positives)
        else:
            precision, recall, thresholds = metrics.precision_recall_curve(labels, scores, pos_label=positives)
        aupr = metrics.auc(recall, precision)
        return auc, aupr

    # noinspection PyMethodMayBeStatic
    def __compute_mcc(self, labels, scores, positives):
        total_positive = np.sum(labels == positives)
        total_negative = np.sum(labels != positives)
        negative_class = np.unique(labels[labels != positives]).item()
        true_labels = labels[np.argsort(scores)]

        ps = np.array([positives] * total_positive)
        ng = np.array([negative_class] * total_negative)

        coefficients = np.empty([0])
        for ix in range(0, 2):
            if ix == 0:
                predicted_labels = np.concatenate((ps, ng), axis=0)
            else:
                predicted_labels = np.concatenate((ng, ps), axis=0)
            coefficients = np.append(coefficients, metrics.matthews_corrcoef(true_labels, predicted_labels))

        mcc = np.max(coefficients)

        return mcc

    def calculate(self):
        # obtaining unique sample labels
        unique_labels = np.unique(self.sample_labels)
        number_unique_labels = len(unique_labels)

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
            warnings.warn('your center formula is not valid: median will be applied')
            self.center_formula = 'median'

        pairwise_group_combinations = self.__nchoosek(number_unique_labels, 2)

        mw_values = np.empty([0])
        auc_values = np.empty([0])
        aupr_values = np.empty([0])
        mcc_values = np.empty([0])
        clusters_projections = [np.empty([0, dimensions_number])] * number_unique_labels

        for index_group_combination in range(pairwise_group_combinations):
            centroid_cluster_1 = centroid_cluster_2 = None
            if self.center_formula == 'median':
                centroid_cluster_1 = np.median(data_clustered[n], axis=0)
                centroid_cluster_2 = np.median(data_clustered[m], axis=0)
            elif self.center_formula == 'mean':
                centroid_cluster_1 = np.mean(data_clustered[n], axis=0)
                centroid_cluster_2 = np.mean(data_clustered[m], axis=0)
            elif self.center_formula == 'mode':
                centroid_cluster_1 = self.__mode_distribution(data_clustered[n])
                centroid_cluster_2 = self.__mode_distribution(data_clustered[m])

            if centroid_cluster_1 is None or centroid_cluster_2 is None:
                raise RuntimeError('impossible to set clusters centroids')
            elif (centroid_cluster_1 == centroid_cluster_2).all():
                raise RuntimeError('clusters have the same centroid: no line can be traced between them')

            clusters_line = self.__create_line_between_centroids(centroid_cluster_1, centroid_cluster_2)

            clusters_projections[n] = clusters_projections[m] = np.empty([0, dimensions_number])

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
            dp_scores = np.concatenate([dp_scores_cluster_1, dp_scores_cluster_2])

            mw = self.__compute_mannwhitney(dp_scores_cluster_1, dp_scores_cluster_2)
            mw_values = np.append(mw_values, mw.pvalue)

            # sample membership
            samples_cluster_n = self.sample_labels[np.where(self.sample_labels == unique_labels[n])[0]]
            samples_cluster_m = self.sample_labels[np.where(self.sample_labels == unique_labels[m])[0]]
            sample_labels_membership = np.concatenate((samples_cluster_n, samples_cluster_m), axis=0)

            current_positive_class = None
            for o in range(len(self.positive_classes)):
                if np.any(sample_labels_membership == self.positive_classes[o]):
                    current_positive_class = self.positive_classes[o]
                    break

            if current_positive_class is None:
                raise RuntimeError('impossible to set the current positive class')

            auc, aupr = self.__compute_auc_aupr(sample_labels_membership, dp_scores, current_positive_class)
            auc_values = np.append(auc_values, auc)
            aupr_values = np.append(aupr_values, aupr)

            mcc = self.__compute_mcc(sample_labels_membership, dp_scores, current_positive_class)
            mcc_values = np.append(mcc_values, mcc)

            m = m + 1
            if m > (number_unique_labels - 1):
                n = n + 1
                m = n + 1

        psi_p = (np.mean(mw_values) + np.std(mw_values, ddof=1)) / (np.std(mw_values, ddof=1) + 1)
        psi_roc = np.mean(auc_values) / (np.std(auc_values, ddof=1) + 1)
        psi_pr = np.mean(aupr_values) / (np.std(aupr_values, ddof=1) + 1)
        psi_mcc = np.mean(mcc_values) / (np.std(mcc_values, ddof=1) + 1)

        return psi_p, psi_roc, psi_pr, psi_mcc
