from scipy.spatial.distance import cdist
import numpy as np


class GeometricalSeparabilityIndex:
    @staticmethod
    def calculate(x, labels):
        p = len(labels)
        d2 = cdist(x, x)
        idx = d2.argsort(axis=0)
        t = np.take(labels, idx)
        t1 = t[0]
        t2 = t[1]
        gsi = np.sum(t1 == t2) / p
        return gsi
