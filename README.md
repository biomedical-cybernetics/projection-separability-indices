# Measuring group-separability in geometrical space for evaluation of pattern recognition and embedding algorithms

## Authors
Aldo Acevedo, Claudio Durán, Sara Ciucci, Ming-Ju Kuo, and Carlo Vittorio Cannistraci

## Description

Here we propose a novel rationale named Projection Separability (PS), specifically designed to assess group separability of data samples in a geometrical space of dimensionality reduction analyses based on embedding algorithms. Our PS rationale states that any statistical separability measure - for instance, the ones commonly used to measure the performance of a binary classification model - can be used for evaluating the group separability of dimension reduction results based on the geometrical projection of the samples (points) of two different groups on the line that connects their centroids, and then repeating this procedure for all pairs of groups for which a separability evaluation is desired.

### Validity indexes

Based on this new rationale, we implemented a new class of validity indices based on different statistical separability measures, which we called Projection Separability Indices (PSIs); the first index, PSI-P, evaluates the separability of the points on the projection line using the Mann-Whitney U-test p-value (MW p-value), which is a ranking-based statistical test; the second index, PSI-ROC, adopts as separability measure on the projection line the Area Under the ROC-Curve (AUC-ROC), which provides a measure of a trade-off between true positive rate and false-positive rate; the third index, PSI-PR, which uses instead the Area Under the Precision-Recall Curve (AUC-PR), which gives a measure of a trade-off between precision and sensitivity (a.k.a. recall); and the four index, PSI-MCC, which uses the Matthews correlation coefficient (MCC), which is a correlation coefficient between the observed and predicted binary classifications. Moreover, we have included as well - with the aim of comparison - several commonly used Cluster Validity Indices (CVIs) such as Dunn Index (DI), that relies on the distances among clusters and their diameters; Davies-Bouldin Index (DB), based on the idea that for a good partition inter-cluster separation as well as intra-cluster homogeneity and compactness should be high; Calinski-Harabasz Index (CH), based on the average between-cluster means and within-cluster sum of squares; Silhouette Index (SIL), that validates the clustering performance based on the pairwise difference of between-cluster and within-cluster distances; Generalized Dunn Index (GDI), a variation of the Dunn index; Geometrical Separability Index (GSI) - also known as Thornton’s separability index - which calculates the average number of instances that share the same class label as their nearest neighbors; and Cluster Validity index based on Density-involved Distance (CVDD), a new index based on the density estimation and compactness weights for determining the best grouping of the samples.

## Before starting

### MATLAB version

This source code has been developed and tested with MATLAB 2017a and newer versions. Keep in mind that lower versions than 2017a have not been tested; thus, compatibility is not warranted.

### Python package

If you are a Python user, you may want to check out our python package [psis](https://pypi.org/project/psis/). The development of this Python wrapper is hosted in this repository [biomedical-cybernetics/pypsis](https://github.com/biomedical-cybernetics/pypsis); thus, please report any issues or questions regarding this wrapper there.

## Execution

### Running the code

You can easily execute the code by running its main function.

```matlab
ValidityIndices = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses)
```

The definition of the inputs is as follows:

| Input           | Type             | Description  |
| --------------- |:----------------:| ----------------------------------------- |
| DataMatrix      | Matrix of double | Matrix of values (*)                      |
| SampleLabels    | Cell array       | List of sample labels                     |
| PositiveClasses | Cell array       | List of positive sample labels (**)       |

_(*) For instance, a matrix of NxM results from a dimension reduction method such as Principal Component Analysis (PCA)._

_(**) Depending on the study, positive classes are usually ranked as the labels for which a particular prediction is desired. For example, sick patients (positive class) versus controls (negative class); or burnout (positive class), depression (positive class), versus control (negative class). If you are not sure which are your positive classes, then take the groups with the lower number of samples as positive._

At first, the user has to select which indexes should be included as part of the output:

```
Available indices:
[1] Projection Separability Indices (PSIs)
[2] Dunn Index (DI)
[3] Davies-Bouldin Index (DB)
[4] Generalized Dunn Index (GDI)
[5] Calinski and Harabasz Index (CH)
[6] Silhouette Index (SIL)
[7] Geometric Separability Index (GSI)
[8] Cluster Validity Density-involved Distance (CVDD)
# Select your indices (range between 1:8)
->
```

Here, you can select either a single index (e.g., 1)  or a group of them (e.g., 4:6). Then, a second prompt will be displayed asking the user if trustworthiness should be applied:

```
Would you like to apply a trustworthiness (null model)?:
[y] Yes
[n] No
->
```

Depending on the previous selection, the algorithm will take two different paths.

#### Running an analysis without trustworthiness

Suppose the application of trustworthiness is not desired. Then, the program will process all selected validity indexes. Once it is finished, it will return a `struct` of values in which a single index can be accessed as `OutputVariable.IndexShortName`.

For instance, if you executed the main function as:

```
ValidityIndicesResults = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses)

Available indices:
[1] Projection Separability Indices (PSIs)
[2] Dunn Index (DI)
[3] Davies-Bouldin Index (DB)
[4] Generalized Dunn Index (GDI)
[5] Calinski and Harabasz Index (CH)
[6] Silhouette Index (SIL)
[7] Geometric Separability Index (GSI)
[8] Cluster Validity Density-involved Distance (CVDD)
# Select your indices (range between 1:8)
-> 1:8

Would you like to apply a trustworthiness (null model)?:
[y] Yes
[n] No
-> n

Processing validity indices...

Done.
```

Then the variable `ValidityIndicesResults` will contain all indices results. Thus, you can easily access them as `ValidityIndicesResults.psip`, `ValidityIndicesResults.dn`, `ValidityIndicesResults.th`, and so on.

_**Hint: you can run Example1.m for having a quick example of this section.**_

#### Running an analysis with trustworthiness

On the other hand, if the application of trustworthiness is preferred, then a new command prompt will be displayed to specify the desired number of iterations:

```
How many iterations should be applied?:
# Enter a number higher than 0
->
```

After this step, all selected validity indexes will be processed according to each trustworthiness iteration (*).

_(*) Note that this execution is implemented by using MATLAB's [parfor](https://de.mathworks.com/help/parallel-computing/parfor.html), which executes for-loop iterations in parallel on workers in a parallel pool._

Once it is finished, it will return a `struct` of values in which you can access the results of the applied trustworthiness for a single index as `ÒutputVariable.IndexShortName`. This contains the following sub-fields:

| Trustworthiness result   | Description                                            |
| ------------------------ | ------------------------------------------------------ |
| IndexValue               | Index value obtained before applying the null model    |
| IndexPermutations        | List of generated permutations                         |
| MaxValue                 | Maximum permutations value                             |
| MinValue                 | Minimum permutations value                             |
| MeanValue                | Mean of the permuation values                          |
| StandardDeviation        | Standard deviation of the permutation values           |
| PValue                   | *p*-value of the generated null model                  |

These sub-fields can be accessed as `ÒutputVariable.IndexShortName.IndexPermutations`, `ÒutputVariable.IndexShortName.PValue`, and so on.

For instance, if you executed the main function as:

```
TrustworthinessResults = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses)

Available indices:
[1] Projection Separability Indices (PSIs)
[2] Dunn Index (DI)
[3] Davies-Bouldin Index (DB)
[4] Generalized Dunn Index (GDI)
[5] Calinski and Harabasz Index (CH)
[6] Silhouette Index (SIL)
[7] Geometric Separability Index (GSI)
[8] Cluster Validity Density-involved Distance (CVDD)
# Select your indices (range between 1:8)
-> 1:8

Would you like to apply a trustworthiness (null model)?:
[y] Yes
[n] No
-> y

How many iterations should be applied?:
# Enter a number higher than 0
-> 100

Processing trustworthiness...

Done.
```

Then the variable `TrustworthinessResults` will contain all null model results. Hence, you can easily access them as `TrustworthinessResults.psip.PValue`, `TrustworthinessResults.dn.StandardDeviation`, and so on.

_**Hint: you can run Example2.m for having a quick example of this section.**_

##### Disabling command prompts

You can also pre-define the options inputted via command prompt by using the following optional arguments.

| Optional argument | Type               | Description                                 |
| ----------------- |:------------------:| ------------------------------------------- |
| indices           | double (or range)  | Number or range of desired indices (*)      |
| trustworthiness   | double             | Number of iterations for generating a null model (**) |
| seed              | double             | Random seed                                 |

(*) The numbering of the indices is as follows:

```
[1] Projection Separability Indices (PSIs)
[2] Dunn Index (DI)
[3] Davies-Bouldin Index (DB)
[4] Generalized Dunn Index (GDI)
[5] Calinski and Harabasz Index (CH)
[6] Silhouette Index (SIL)
[7] Geometric Separability Index (GSI)
[8] Cluster Validity Density-involved Distance (CVDD)
```

Also, you can input a range. For instance, 1:3 will calculate the PSI, DI, and DB.

(**) Regarding the `trustworthiness`, a value 0 will avoid the application of a null model.

Let's check some examples:

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'trustworthiness', 0);
```

The code above will calculate all indices from 1 to 8 (included) without the application of trustworthiness (null model) (see [Example1.m](./Example1.m)).

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'trustworthiness', 1000, 'seed', 100);
```

The code above calculate all indices from 1 to 8 (included) and apply the trustworthiness by generating a null model of 100 iterations (see [Example2.m](./Example2.m)).

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1);
```

The code above pre-select index 1 and prompt the trustworthiness options.

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'trustworthiness', 1000);
```

The code above pre-select a trustworthiness by generating a null model of 1000 iterations and prompt the selection of the indices.


# Contact
Please, report any issue here on Github or contact:

- Aldo Acevedo:  [aldo.acevedo.toledo@gmail.com](mailto:aldo.acevedo.toledo@gmail.com)
- Carlo Vittorio Cannistraci:  [kalokagathos.agon@gmail.com](mailto:kalokagathos.agon@gmail.com)
