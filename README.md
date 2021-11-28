# Measuring group separability in geometrical space for evaluation of pattern recognition and dimension reduction algorithms

## Authors
Aldo Acevedo, Claudio Durán, Sara Ciucci, Ming-Ju Kuo, and Carlo Vittorio Cannistraci

## Description

Here we propose a novel rationale named Projection Separability (PS), specifically designed to assess group separability of data samples in a geometrical space of dimensionality reduction analyses based on embedding algorithms. Our PS rationale states that any statistical separability measure - for instance, the ones commonly used to measure the performance of a binary classification model - can be used for evaluating the group separability of dimension reduction results based on the geometrical projection of the samples (points) of two different groups on the line that connects their centroids, and then repeating this procedure for all pairs of groups for which a separability evaluation is desired.

### Validity indexes

Based on this new rationale, we implemented a new class of validity indices based on different statistical separability measures, which we called Projection Separability Indices (PSIs); the first index, PSI-P, evaluates the separability of the points on the projection line using the Mann-Whitney U-test p-value (MW p-value), which is a ranking-based statistical test; the second index, PSI-ROC, adopts as separability measure on the projection line the Area Under the ROC-Curve (AUC-ROC), which provides a measure of a trade-off between true positive rate and false-positive rate; the third index, PSI-PR, which uses instead the Area Under the Precision-Recall Curve (AUC-PR), which gives a measure of a trade-off between precision and sensitivity (a.k.a. recall); and the four index, PSI-MCC, which uses the Matthews correlation coefficient (MCC), which is a correlation coefficient between the observed and predicted binary classifications. Moreover, we have included as well - with the aim of comparison - several commonly used Cluster Validity Indices (CVIs) such as Dunn Index (DI), that relies on the distances among clusters and their diameters; Davies-Bouldin Index (DB), based on the idea that for a good partition inter-cluster separation as well as intra-cluster homogeneity and compactness should be high; Calinski-Harabasz Index (CH), based on the average between-cluster means and within-cluster sum of squares; Silhouette Index (SIL), that validates the clustering performance based on the pairwise difference of between-cluster and within-cluster distances; Generalized Dunn Index (GDI), a variation of the Dunn index; Geometrical Separability Index (GSI) - also known as Thornton’s separability index - which calculates the average number of instances that share the same class label as their nearest neighbors; and Cluster Validity index based on Density-involved Distance (CVDD), a new index based on the density estimation and compactness weights for determining the best grouping of the samples.

### Trustworthiness

In order to prove and to account for the uncertainty of the separability estimation given by the indices, we also propose a second methodological innovation named _trustworthiness_. In brief, this methodology proposes a resampling to build a null model that allows computing an empirical _p_-value to assess the significance (trustworthiness) of the separability measure provided by a selected index. This means that trustworthiness assesses the extent to which the value produced by a certain index is reliable under uncertainty.

## Before starting

### MATLAB version

This source code has been developed and tested with MATLAB 2017a and newer versions. Keep in mind that lower versions than 2017a have not been tested; thus, compatibility is not warranted.

### Python package

If you are a Python user, you may want to check out our python package [psis](https://pypi.org/project/psis/). The development of this Python wrapper is hosted in this repository [biomedical-cybernetics/pypsis](https://github.com/biomedical-cybernetics/pypsis); thus, please report any issues or questions regarding this wrapper there.

### Datasets

You can find all initially studied datasets in the _[datasets](./datasets)_ folder.

### Examples

You can find meaningfull examples in the _[examples](./examples)_ folder. If you want to execute them, locate yourself in the project's root and execute `addpath('examples/')` to add the example files into the search path for the current MATLAB session.

## Execution

### Running the code

You can easily execute the code by running its main function.

```matlab
ValidityIndices = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses)
```

The definition of the inputs is as follows:

| Input           | Type             | Description  |
| --------------- |:----------------:| ----------------------------------------- |
| DataMatrix      | Matrix of double | Matrix of values (a)                      |
| SampleLabels    | Cell array       | List of sample labels                     |
| PositiveClasses | Cell array       | List of positive sample labels (b)        |

_(a) For instance, a matrix of NxM results from a dimension reduction method such as Principal Component Analysis (PCA) where the samples are placed as rows and the features as columns._

_(b) Depending on the study, positive classes are usually ranked as the labels for which a particular prediction is desired. For example, sick patients (positive class) versus controls (negative class); or burnout (positive class), depression (positive class), versus control (negative class). If you are not sure which are your positive classes, then take the groups with the lower number of samples as positive._

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

Here, the user can select either a single index (e.g., 1) or a group of them (e.g., 4:6). In case if option `[1] Projection Separability Indices (PSIs)` is included in the selection, then the following prompt will be displayed:

```
PSIs projection type:
[1] Centroid based (default)
[2] Linear Discriminant Analysis (LDA) based
->
```

Here, the user can specify the type of projection for computing the PSIs. This will define how the points should be projected before the evaluation of the separability. In case if the `centroid` approach is selected, then the following prompt will be displayed:

```
PSIs centroid formula:
[1] Median (default)
[2] Mean
[3] Mode
->
```

Here, the user can specify the criteria for computing (finding) the centroids of the groups. Note that `median` is selected by default because of its robustness to outliers.

After these previous selections, a new prompt will be displayed asking the user if trustworthiness should be applied:

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

PSIs projection type:
[1] Centroid based (default)
[2] Linear Discriminant Analysis (LDA) based
-> 1

PSIs centroid formula:
[1] Median (default)
[2] Mean
[3] Mode
-> 1

Would you like to apply trustworthiness (null model)?:
[y] Yes
[n] No
-> n

Processing validity indices...

Done.
```

Then the variable `ValidityIndicesResults` will contain all indices results. Thus, you can easily access them as `ValidityIndicesResults.PSIP`, `ValidityIndicesResults.DN`, `ValidityIndicesResults.GSI`, and so on.

#### Running an analysis with trustworthiness

On the other hand, if the application of trustworthiness is preferred, then a new command prompt will be displayed to specify the desired number of iterations:

```
How many iterations should be applied?:
# Enter a number higher than 0
->
```

After this step, all selected validity indexes will be processed according to each trustworthiness iteration (a).

_(a) Note that this execution is implemented by using MATLAB's [parfor](https://de.mathworks.com/help/parallel-computing/parfor.html), which executes for-loop iterations in parallel on workers in a parallel pool._

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

PSIs projection type:
[1] Centroid based (default)
[2] Linear Discriminant Analysis (LDA) based
-> 1

PSIs centroid formula:
[1] Median (default)
[2] Mean
[3] Mode
-> 1

Would you like to apply trustworthiness (null model)?:
[y] Yes
[n] No
-> y

How many iterations should be applied?:
# Enter a number higher than 0
-> 1000

Processing trustworthiness...

Done.
```

Then the variable `TrustworthinessResults` will contain all null model results. Hence, you can easily access them as `TrustworthinessResults.PSIP.PValue`, `TrustworthinessResults.DN.StandardDeviation`, and so on.

### Disabling command prompts

You can also pre-define the options inputted via command prompt by using the following optional arguments.

| Optional argument | Type               | Description                                                            |
| ----------------- |:------------------:| ---------------------------------------------------------------------- |
| Indices           | double (or range)  | Number or range of desired indices (a)                                 |
| Trustworthiness   | double             | Number of iterations for generating a null model (b)                   |
| Seed              | double             | Random seed                                                            |
| ProjectionType    | char               | Projection approach to be used when computing the PSIs (c)             |
| CenterFormula     | char               | Approach for finding the groups' centroids when computing the PSIs (d) |

_(a) The numbering of the indices is as follows:_

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

Also, you can input a range. For instance:

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'Indices', 1:3);
```

Here, `1:3` means that the algorithm will compute the PSIs, DI, and DB.

_(b) Regarding the `trustworthiness`, a value `0` will avoid the application of a null model._

_(c) This option only takes effect if `'Indices', 1` or `Indices, 1:N` is inputted. In other cases, its value will be ignored._

_(d) This option only takes effect if `'Indices', 1` or `Indices, 1:N`, and `'ProjectionType', 'centroid'` are inputted. In other cases, its value will be ignored._

Let's check some examples:

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'Indices', 2:8, 'Trustworthiness', 0);
```

The code above will calculate all indices from 2 to 8 (included) without the application of trustworthiness (null model).

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'Indices', 1:8, 'ProjectionType', 'centroid', 'CenterFormula', 'median', 'Trustworthiness', 1000, 'seed', 100);
```

The code above calculate all indices from 1 to 8 (included) and apply the trustworthiness by generating a null model of 100 iterations. Also, note that the PSIs will be computed using a centroid-based projection and the centers of the groups will be computed using `median`.

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'Indices', 1, 'ProjectionType', 'lda', 'Trustworthiness', 0);
```

The code above will compute the PSIs using a Linear Discriminant Analysis (LDA) based projection and no trustworthiness will be applied.

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'Trustworthiness', 1000);
```

The code above pre-select a trustworthiness by generating a null model of 1000 iterations and prompt the selection of the indices.

**Find more examples at _[examples](./examples)_ with different settings and use cases.**

# Contact
Please, report any issue here on Github or contact:

- Aldo Acevedo:  [aldo.acevedo.toledo@gmail.com](mailto:aldo.acevedo.toledo@gmail.com)
- Carlo Vittorio Cannistraci:  [kalokagathos.agon@gmail.com](mailto:kalokagathos.agon@gmail.com)
