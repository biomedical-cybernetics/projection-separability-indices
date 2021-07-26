from sklearn.metrics import silhouette_score


class SilhouetteIndex:
    @staticmethod
    def calculate(x, labels):
        return silhouette_score(x, labels)
