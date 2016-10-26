LargeScale
========================================================
author: Hector Corrada Bravo
date: CMSC489T: Intro Data Science



Reminder (Regression)
=======================================================

- _Least squares regression: linear regression, polynomial regression_
- K-nearest neighbors regression
- _Loess_
- Tree-based regression: Regression Trees, Random Forests
- _SVM regression (not covered): linear and non-linear (kernels)_

Reminder (Classification)
======================================================

- _Logistic regression: linear, polynomial_
- LDA, QDA
- K-nearest neighbors classification
- Tree-based classification: Classification Trees, Random Forests
- _SVM classification: linear and non-linear (kernels)_
  
For Today
========================================================

**Question**: How to fit the type of analysis methods we've seen so far for large datasets?

**Insights**: 
  1. All methods in _italics_ were presented as **optimization problems**.
  2. We can devise optimization algorithms that process training data efficiently.

We will use linear regression as a case study of how this insight would work.

Case Study
================================================

Linear regression with one predictor, no intercept

**Given**: Training set $\{(x_1, y_1), \ldots, (x_n, y_n)\}$, with continuous response $y_i$ and single predictor $x_i$ for the $i$-th observation.

**Do**: Estimate parameter $\beta_1$ in model $y=\beta_1 x$ to solve

$$
\min_{\beta_1} L(\beta_1) = \frac{1}{2} \sum_{i=1}^n (y_i - \beta_1 x_i)^2
$$

Case Study
==============================================

![plot of chunk unnamed-chunk-2](LargeScale-figure/unnamed-chunk-2-1.png) 

Case Study
===============

![plot of chunk unnamed-chunk-3](LargeScale-figure/unnamed-chunk-3-1.png) 

Case Study
==============================================

![plot of chunk unnamed-chunk-4](LargeScale-figure/unnamed-chunk-4-1.png) 

Case Study
===============================================

Insights:

1) Loss is minimized when the derivative of the loss function is 0

2) The derivative of the loss (with respect to $\beta_1$ ) at a given estimate $\beta_1$ suggests new values of $\beta_1$ with smaller loss!

Case Study
====================

Let's take a look at the derivative:

$$
\frac{\partial}{\partial \beta_{1}} L(\beta_1) = \frac{\partial}{\partial \beta_{1}} \frac{1}{2} \sum_{i=1}^n (y_i - \beta_1 x_i)^2 \\
{} = \sum_{i=1}^n (y_i - \beta_1 x_i) \frac{\partial}{\partial \beta_1} (y_i - \beta_1 x_i) \\
{} = \sum_{i=1}^n (y_i - \beta_1 x_i) (-x_i)
$$

Case Study
================================================

![plot of chunk unnamed-chunk-5](LargeScale-figure/unnamed-chunk-5-1.png) 

Gradient Descent
=================================================

This suggests an algorithm:

1. Initialize $\beta_1=0$
2. Repeat until convergence
  - Set $\beta_1 = \beta_1 + \alpha \sum_{i=1}^n (y_i - f(x_i)) x_i$
  
($\alpha$ is a step size)

Gradient Descent
=================================================

This suggests an algorithm:

1. Initialize $\beta_1=0$
2. Repeat until convergence
  - Set $\beta_1 = \beta_1 + \alpha \sum_{i=1}^n (y_i - f(x_i)) x_i$
  
This algorithm is called **gradient descent** in the general case.

_Idea_: Move current estimate in the direction that minimizes loss the *fastest*

Another way of calling it: **Steepest Descent**

Gradient Descent
=================

Check presentation RMarkdown for implementation





Gradient Descent
===============

![plot of chunk unnamed-chunk-8](LargeScale-figure/unnamed-chunk-8-1.png) 

Gradient Descent
=================

![plot of chunk unnamed-chunk-9](LargeScale-figure/unnamed-chunk-9-1.png) 

Gradient Descent
==================

This is referred to as "Batch" gradient descent, since we take a step (update $\beta_1$) by calculating derivative with respect to all $n$ observations.

Let's write out the update equation:

$$
\beta_1 = \beta_1 + \alpha \sum_{i=1}^n (y_i - f(x_i, \beta_1)) x_i
$$

where $f(x_i) = \beta_1 x_i$.

Gradient Descent
==================

For multiple predictors (e.g., adding an intercept), this generalizes to the _gradient_ i.e., the vector of first derivatives of _loss_ with respect to parameters.

The update equation is exactly the same for least squares regression

$$
\mathbf{\beta} = \mathbf{\beta} + \alpha \sum_{i=1}^n (y_i - f(\mathbf{x}_i, \beta)) \mathbf{x}_i
$$

where $f(\mathbf{x}_i, \mathbf{\beta}) = \beta_0 + \beta_1 x_{i1} + \cdots + \beta_p x_{ip}$

First-order methods
============================

Gradiest descent falls within a family of optimization methods called _first-order methods_.

These methods have properties amenable to use with very large datasets:

1. Inexpensive updates    
2. "Stochastic" version can converge with few sweeps of the data  
3. "Stochastic" version easily extended to streams  
4. Easily parallelizable  

Drawback: Can take many steps before converging

Stochastic gradient descent
============================

**Key Idea**: Update parameters using update equation _one observation at a time_:

1. Initialize $\beta=\mathbf{0}$, $i=1$
2. Repeat until convergence
  - For $i=1$ to $n$
    - Set $\beta = \beta + \alpha (y_i - f(\mathbf{x}_i, \beta)) \mathbf{x}_i$

Stochastic gradient descent
=============================

See presentation Rmarkdown for implementation




Stochastic Gradient Descent
============================

![plot of chunk unnamed-chunk-12](LargeScale-figure/unnamed-chunk-12-1.png) 

```
it:  0  beta:  0 loss:  66.15  alpha:  0.001 
it:  1  beta:  1.92 loss:  2.32  alpha:  0.001 
it:  2  beta:  1.99 loss:  2.25  alpha:  0.001 
it:  3  beta:  1.99 loss:  2.25  alpha:  0.001 
```

Stochastic Gradient Descent
=============================

Easily adapt to _data streams_ where we receive observations one at a time and _assume_ they are not stored.

**Idea**: Update parameter using same update rule

_Note_: This falls in the general category of _online_ learning.

Gradient Descent
==================

Easily parallelizable:

- Split observations across computing units
- For each step, compute partial sum for each partition (map), compute final update (reduce)

$$
\beta = \beta + \alpha * \sum_{\mathrm{partition}\; p} \sum_{i \in p} (y_i - f(\mathbf{x_i}, \beta)) \mathbf{x}_i
$$

Large-scale learning frameworks
================================

1. [Vowpal Wabbit](https://github.com/JohnLangford/vowpal_wabbit/wiki)
  - Implements general framework of (sparse) stochastic gradient descent for many optimization problems
  - R interface: [http://cran.r-project.org/web/packages/RVowpalWabbit/index.html]
  
2. [Spark MLlib](https://spark.apache.org/docs/1.2.1/mllib-guide.html)
  - Implements many learning algorithms using Spark framework we saw previously
  - Very little access to the MLlib API via R, but built on primitives accessible through `SparkR` library we saw previously
  
