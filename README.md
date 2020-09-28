# Measuring group-separability in geometrical space for evaluation of pattern recognition and embedding algorithms

## Authors
Aldo Acevedo, Sara Ciucci, Ming-Ju Kuo, Claudio Durán, and Carlo Vittorio Cannistraci

## Description

Here we propose a novel rationale named Projection Separability (PS), which is specifically designed to assess group separability of data samples in a geometrical space of dimensionality reduction analyses based on embedding algorithms. Our PS rationale states that any statistical measure that assesses the performance of a classification model can be used for evaluating the group separability of dimension reduction results based on the geometrical projection of the samples (points) of two different groups on the line that connects their centroids and then repeating this procedure for all pairs of groups for which separability evaluation is desired.

### Validity indexes

<<<<<<< HEAD
On the basis of this new rationale, we implemented a new class of validity indices based on different statistical separability measures which we called as Projection Separability Indices (PSIs); the first index, PSI-P, evaluates the separability of the points on the projection line by means of the Mann-Whitney U-test p-value (MW p-value), which is a ranking-based statistical test; the second index, PSI-ROC, adopts as separability measure on the projection line the Area Under the ROC-Curve (AUC-ROC), which provides a measure of a trade-off between true positive rate and false-positive rate; the third index, PSI-PR, which uses instead the Area Under the Precision-Recall Curve (AUC-PR), which gives a measure of a trade-off between precision and sensitivity (a.k.a. recall); and the four index, PSI-MCC, which uses the Matthews correlation coefficient (MCC), which is a correlation coefficient between the observed and predicted binary classifications. Moreover, we have included as well - with the aim of comparison - several commonly used Cluster Validity Indices (CVIs) such as Dunn index (DN), that relies on the distances among clusters and their diameters; Davies-Bouldin index (DB), based on the idea that for a good partition inter-cluster separation as well as intra-cluster homogeneity and compactness should be high; Calinski-Harabasz index (CH), based on the average between-cluster means and within-cluster sum of squares; Silhouette index (SH), that validates the clustering performance based on the pairwise difference of between-cluster and within-cluster distances; Bezdek index (BZ), a variation of the Dunn index; Thornton’s separability (TH) index, which calculates the average number of instances that share the same class label as their nearest neighbors; and Cluster Validity index based on Density-involved Distance (CVDD), a new index based on the density estimation and compactness weights for determining the best grouping of the samples.
=======
Based on this new rationale, we implemented three statistical separability measures which we called as Projection Separability Indices (PSIs); the first index, PSI-P, evaluates the separability of the points on the projection line by means of the Mann-Whitney U-test p-value (MW p-value), which is a ranking-based statistical test; the second index, PSI-ROC, adopts as separability measure on the projection line the Area Under the ROC-Curve (AUC-ROC), which provides a measure of a trade-off between true positive rate and false-positive rate; and the third index, PSI-PR, which uses instead the Area Under the Precision-Recall Curve (AUC-PR), which gives a measure of a trade-off between precision and sensitivity (a.k.a. recall). Moreover, we have included as well - with the aim of comparison - several commonly used Cluster Validity Indices (CVIs) such as Dunn Index (DI), that relies on the distances among clusters and their diameters; Davies-Bouldin Index (DB), based on the idea that for a good partition inter-cluster separation as well as intra-cluster homogeneity and compactness should be high; Calinski-Harabasz Index (CH), based on the average between-cluster means and within-cluster sum of squares; Silhouette Index (SIL), that validates the clustering performance based on the pairwise difference of between-cluster and within-cluster distances; Generalized Dunn Index (GDI), a variation of the Dunn index; Geometrical Separability Index (GSI) - also known as Thornton’s separability index - which calculates the average number of instances that share the same class label as their nearest neighbors; and Cluster Validity index based on Density-involved Distance (CVDD), a new index based on the density estimation and compactness weights for determining the best grouping of the samples.
>>>>>>> master

## Execution

**Before starting:** This source code is compatible with MATLAB r2016b or newer versions of it. Keep in mind that lower versions than r2016b have not been tested.

### Running the code

You can easily execute the code by running its main function

```matlab
ValidityIndices = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses)
```

The definition of the inputs is as follows:

| Input           | Type             | Description  |
| --------------- |:----------------:| ----------------------------------------- |
| DataMatrix      | Matrix of double | Matrix of values (*)                      |
| SampleLabels    | Cell array       | List of sample labels                     |
| PositiveClasses | Cell array       | List of positive sample labels (**)       |

_(*) For instance, a matrix of NxM which is the result of a dimension reduction method such as Principal Component Analysis (PCA)._

_(**) Depending on the study positive classes are usually ranked as the labels for who a certain prediction is desired. For example, sick patients (positive class) versus controls (negative class); or burnout (positive class), depression (positive class), control (negative class)._

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

Here, either a single index (e.g. 1) can be selected, or a group of them (e.g. 4:6). Then, a second prompt will be displayed asking the user if a null model should be applied:

```
Would you like to apply a null model?:
[y] Yes
[n] No
-> 
```

Depending on the selection, the algorithm will take two different paths.

#### Without null model

If the application of a null model is not desired. Then, the program will process all selected validity indexes, once it is finished, it will return a `struct` of values in which a single index can be accessed as `OutputVariable.IndexShortName`.

For instance, if the main function was executed as:

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

Would you like to apply a null model?:
[y] Yes
[n] No
-> n

Processing validity indices...

Done.
```

Then the variable `ValidityIndicesResults` will contain all indices results. Thus, you can easily access them as `ValidityIndicesResults.psip`, `ValidityIndicesResults.dn`, `ValidityIndicesResults.th`, and so on.

_**Hint: you can run Example1.m for having a quick example of this section.**_

#### Apply null model

On the other hand, if the application of a null model is preferred, then a new command prompt will be displayed in order to specify desired number of iterations:

```
How many iteration should be applied?:
# Enter a number higher than 0
-> 
```

After this step, all selected validity indexes will be processed according for each null model iteration (*). 

_(*) Note that this execution is implemented by using MATLAB's [parfor](https://de.mathworks.com/help/parallel-computing/parfor.html), which executes for-loop iterations in parallel on workers in a parallel pool._

Once it is finished, it will return a `struct` of values in which the results of the applied null model for a single index can be accessed as `ÒutputVariable.IndexShortName`. This contains the following sub-fields:

| Null model result   | Description                                            |
| ------------------- | ------------------------------------------------------ |
| IndexValue          | Index value obtained before applying the null model    |
| IndexPermutations   | List of generated permutations                         |
| MaxValue            | Maximum permutation's value                            |
| MinValue            | Minimum permutation's value                            |
| MeanValue           | Mean of the permuation values                          |
| StandardDeviation   | Standard deviation of the permutation values           |
| PValue              | *p*-value of the generated null model                  |

These sub-fields can be accessed as `ÒutputVariable.IndexShortName.IndexPermutations`, `ÒutputVariable.IndexShortName.PValue`, and so on.

For instance, if the main function was executed as:

```
NullModelResults = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses)

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

Would you like to apply a null model?:
[y] Yes
[n] No
-> y

How many iteration should be applied?:
# Enter a number higher than 0
-> 100

Processing null model...

Done.
```

Then the variable `NullModelResults` will contain all null model results. Hence, you can easily access them as `NullModelResults.psip.PValue`, `NullModelResults.dn.StandardDeviation`, and so on.

_**Hint: you can run Example2.m for having a quick example of this section.**_

##### Disabling command prompts

You can also pre-define the options inputed via command prompt by using the following optional arguments.

| Optional argument | Type               | Description                                 |
| ----------------- |:------------------:| ------------------------------------------- |
| indices           | double (or range)  | Number or range of desired indices (*)      |
| nullmodel         | double             | Number of iterations of the null model (**) |
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

Also you can input a range. For instance, 1:3 will calculate the PSI, DI, and DB.

(**) Regarding the null model, a value 0 will avoid the application of the null model.

Let's check some examples:

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'nullmodel', 0);
```

This will calculate all indices from 1 to 8 (included) without the application of a null model (see Example1.m).

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1:8, 'nullmodel', 1000, 'seed', 100);
```

This will calculate all indices from 1 to 8 (included) and apply a null model of 100 iterations (see Example2.m).

```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'indices', 1);
```

This will pre-select index 1 and prompt the null model options.


```matlab
results = ProcessValidityIndices(DataMatrix, SampleLabels, PositiveClasses, 'nullmodel', 1000);
```
This will pre-select a null model of 1000 iterations and prompt the selection of the indices.


# Contact
Please, report any issue here on Github or contact:

- Aldo Acevedo:  [aldo.acevedo.toledo@gmail.com](mailto:aldo.acevedo.toledo@gmail.com)
- Carlo Vittorio Cannistraci:  [kalokagathos.agon@gmail.com](mailto:kalokagathos.agon@gmail.com)
