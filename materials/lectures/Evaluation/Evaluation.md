Evaluation using resampling methods
========================================================
author: Hector Corrada Bravo
date: CMSC498T Intro. Data Science, Spring 2015

Evaluation
===========



- So far we have discussed training set error
- But in first lecture on modeling we said we wanted to build models that
**generalize** and don't **overfit**
- How do we measure that, when we we only have training data?

Cross Validation
=================

- Most common tool to evaluate model performance.
- Used in two essential modeling steps:
  - _Model Selection_: for a given model, what should be included?
  - _Model Assessment_: how well does our selected model perform?
  
Cross Validation
=================

_Model Selection_

- Example: I will fit a linear regression model, what predictors should be included?, interactions?, transformations?
- Example: I will use KNN, what should the value of K be?

_Model Assessment_

- Example: I've built a linear regression models, with specific predictors. How well will it perform on unseen data?
- Example: I've built a KNN classifier. How well will it predict unseen observations?

Cross Validation
=================

Resampling method to obtain estimates of **test error rate** (or any other performance measure on unseen data).

- In some instances, you will have a large predefined test dataset **that you should never use when training**.
_ In the absence of this, cross validation can be used

Validation Set
===============

First option: **randomly** divide dataset into _training_ and _validation_ sets

- Put the _validation_ set away, and do not use it until ready to compute **test error rate** (once, don't go back and check if you can improve it).

![](validation.png)

Validation Set
===============

![plot of chunk unnamed-chunk-2](Evaluation-figure/unnamed-chunk-2-1.png) 


Validation Set
===============

Split into a single set, fit regression with different polynomial degrees.

***

![plot of chunk unnamed-chunk-3](Evaluation-figure/unnamed-chunk-3-1.png) 

Validation Set
===============

Now replicate the same thing 10 times (with different validation and training sets).

- Only using 50% of data to train: this overestimates error
- Highly variable!: error rate is a random quantity, depends on observations in training and validation sets.

***

![plot of chunk unnamed-chunk-4](Evaluation-figure/unnamed-chunk-4-1.png) 

Leave-one-out Cross-Validation
================================

Procedure:  
For each observation $i$ in data set:  
  a. Train model on all but $i$-th observation  
  b. Predict response for $i$-th observation  
  c. Calculate prediction error  

$$
CV_{(n)} = \frac{1}{n} \sum_i (y_i - \hat{y}_i)^2
$$

***

![](loocv.png)

Leave-one-out Cross-Validation
================================

Advantages:

1. Uses $n-1$ observations to train model
2. There is no randomness, since error estimated on each sample

Disadvantages:

1. Very costly since have to train $n-1$ models.
2. Error estimate is highly variable

***

![](loocv.png)

Leave-one-out Cross-Validation
===============================



![plot of chunk unnamed-chunk-6](Evaluation-figure/unnamed-chunk-6-1.png) 

***

For linear models (and some non-linear models) there is a nice trick that allows one to compute (exactly or approximately) LOOCV from the full data model fit.


k-fold Cross-Validation
===============================
left: 50%

Procedure:  
Partition observations randomly into $k$ groups.  

For each of the $k$ groups of observations:
- Train model on observations in the other $k-1$ partitions  
- Estimate test-set error (e.g., Mean Squared Error)  

Compute average error across $k$ folds  

*** 

![](kfoldcv.png)

k-fold Cross-Validation
========================

$$
CV_{(k)} = \frac{1}{k} \sum_i MSE_i
$$

where $MSE_i$ is mean squared error estimated on the $i$-th fold

***

![](kfoldcv.png)


k-fold Cross-Validation
========================

Advantages:
 - fewer models to fit
 - less variance in the computed $MSE_i$ 
 
Disadvantages:
 - Slight bias (over estimating usually) in error estimate
 
***

![](kfoldcv.png)

k-fold Cross-Validation
========================



![plot of chunk unnamed-chunk-8](Evaluation-figure/unnamed-chunk-8-1.png) 

Cross-Validation in Classification
===================================

- Each of these procedures can be used for classification as well.
- Substitute MSE with performance metric of choice. E.g., error rate, accuracy, TPR, FPR, AUROC
- Not all of these work with LOOCV (e.g. AUROC)

Comparing Models
==================

- Suppose you want to compare two classification models (logistic regression vs. knn) on the `Default` dataset.
- We can use Cross-Validation to determine if one model is better than the other.
- A t-test!

Comparing Models
=================



![plot of chunk unnamed-chunk-10](Evaluation-figure/unnamed-chunk-10-1.png) 

***


```

	Welch Two Sample t-test

data:  error_rates["logis", ] and error_rates["knn", ]
t = -1.6543, df = 17.885, p-value = 0.05776
alternative hypothesis: true difference in means is less than 0
95 percent confidence interval:
         -Inf 0.0002430517
sample estimates:
mean of x mean of y 
   0.0267    0.0317 
```

Summary
========

- Model selection and assessment are critical steps of data analysis
- Resampling methods are general tools used for this purpose
- Many data analysis frameworks have a lot of supporting libraries for this: `boot`, `cvTools`, many more.

One Last Thing
===============

For non-linear regression and classification we've seen:
  - KNN 
  - polynomial regression (and logistic regression)
  - QDA
  
There are a large number of other, more flexible, non-linear methods
  - The classic example is `loess` in regression settings. Extremely useful in EDA
  - A combination of polynomial regression and KNN
  
EDA with LOESS
===============

![plot of chunk unnamed-chunk-12](Evaluation-figure/unnamed-chunk-12-1.png) 

