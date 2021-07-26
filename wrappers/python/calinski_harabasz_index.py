from sklearn.metrics import calinski_harabasz_score


class CalinskiHarabaszIndex:
    @staticmethod
    def calculate(x, labels):
        return calinski_harabasz_score(x, labels)
