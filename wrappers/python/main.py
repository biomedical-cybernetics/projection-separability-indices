import click
import numpy as np
import pandas as pd

from geometrical_separability_index import GeometricalSeparabilityIndex


@click.command()
@click.option('--matrix', default='./sample-data/matrix.csv', type=click.File("rb"), help='Data matrix')
@click.option('--samples', default='./sample-data/samples.csv', type=click.File("rb"), help='Sample labels')
@click.option('--positive', default='./sample-data/positive.csv', type=click.File("rb"), help='Positive classes')
def indices(matrix, samples, positive):
    """Projection Separability Indices CLI tool."""

    dataMatrix = pd.read_csv(matrix, delimiter=',', header=None)
    sampleLabels = pd.read_csv(samples, delimiter=',', header=None)
    positiveClasses = pd.read_csv(positive, delimiter=',', header=None)

    #print(dataMatrix.head())
    #print(sampleLabels.head())
    #print(positiveClasses.head())

    originData = dict(
        DataMatrix=dataMatrix.to_numpy(),
        SampleLabels=sampleLabels,
        PositiveClasses=positiveClasses,
        UniqueSampleLabels=sampleLabels[0].unique(),
    )

    #print(originData['UniqueSampleLabels'])

    gsi = GeometricalSeparabilityIndex(originData['DataMatrix'], originData['SampleLabels'])
    print(gsi)


if __name__ == '__main__':
    indices()
