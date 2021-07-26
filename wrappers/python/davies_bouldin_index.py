from sklearn.metrics import davies_bouldin_score


class DaviesBouldinIndex:
    @staticmethod
    def calculate(x, labels):
        return davies_bouldin_score(x, labels)
