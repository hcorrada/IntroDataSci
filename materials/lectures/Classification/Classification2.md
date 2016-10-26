Classification2
========================================================
author: Hector Corrada Bravo
date: CMSC498T Introduction to Data Science, Spring 2015

Linear Discriminant Analysis
=========================================

- Another linear method, based on probability model.
- Recall that we want to partition data based on **posterior class probability**:  _find the $\mathbf{X}$ for which_ $P(\mathrm{default=Yes}|X) > P(\mathrm{default=No}|X)$ 
- In logistic regression **we made no assumption about $\mathbf{X}$**
- In some cases, we **can** make assumptions about $\mathbf{X}$ that improve prediction performance (if assumptions hold, obviously)

Linear Discriminant Analysis
==============================



![plot of chunk unnamed-chunk-2](Classification2-figure/unnamed-chunk-2-1.png) 

Linear Discriminant Analysis
=============================

- This implies we can model `balance` for each of the classes with a normal distribution
- WARNING, BIG ASSUMPTION: We will assume `balance` has the same *variance* for both classes (this is what makes LDA linear)
- So, we estimate average `balance` for people who _do not_ default:

$$
\hat{\mu}_0 = \frac{1}{n_0} \sum_{i:\, y_i=0} x_i
$$

- And for people who do default:

$$
\hat{\mu}_1 = \frac{1}{n_1} \sum_{i:\, y_i=1} x_i
$$



Linear Discriminant Analysis
==============================

![plot of chunk unnamed-chunk-4](Classification2-figure/unnamed-chunk-4-1.png) 


Linear Discriminant Analysis
=============================

- This implies we can model `balance` for each of the classes with a normal distribution
- WARNING, BIG ASSUMPTION: We will assume `balance` has the same *variance* for both classes (this is what makes LDA linear)
- And estimate variance for both classes as

$$
\hat{\sigma}^2 = \frac{1}{n-2} \sum_{k=1,2} \sum_{i:\, y_i=k} (x_i - \hat{\mu}_k)^2
$$

Linear Discriminant Analysis
=============================

![plot of chunk unnamed-chunk-5](Classification2-figure/unnamed-chunk-5-1.png) 

Linear Discriminant Analysis
==============================

We can "score" values of `balance` based on these estimates:

$$
f_k(x) = \frac{1}{\sqrt{2\pi}\sigma} \exp \left(-\frac{1}{2\sigma^2} (x-\mu_k)^2 \right)
$$

Linear Discriminant Analysis
==============================

- Remember, what we want is **posterior class probability** $P(Y=k|X)$, for that we need to include the probability that we _observe_ class $k$.

- This is called **prior class probability**, denoted $\pi_k$, means the proportion of times you expect people to default regardless of any other attribute. We can estimate from training data as the proportion of observations with label $k$.

Linear Discriminant Analysis
==============================

- Bayes' Rule (or Theorem) gives us a way of computing $P(Y=k|X)$ using score $f_k(x)$ (from the class normal assumption) and prior $\pi_k$:

$$
P(Y=k|X) = \frac{f_k(x) \pi_k}{\sum_l f_l(x) \pi_l}
$$

- If data (conditioned by class) is distributed so that $f_k$ is the right probability function to use, then

- Predicting the class that maximizes $P(Y=k|X)$ is the **optimal** thing to do.

- This is referred to the _Bayes classifier_ (aka the Holy Grail of classification)

Linear Discriminant Analysis
==============================

**How to train LDA**

Compute class means and squared error based on class mean


```r
lda_stats <- Default %>% 
  group_by(default) %>% 
  mutate(class_mean=mean(balance),
         squared_error=(balance-class_mean)^2) 
```

Linear Discriminant Analysis
==============================

**How to train LDA**

Compute class sizes and sum of squared errors


```r
lda_stats <- lda_stats %>%
  summarize(class_mean=first(class_mean),
            class_size=n(),
            sum_squares=sum(squared_error))
```

Linear Discriminant Analysis
=============================

**How to train LDA**

Compute class prior and variance (note same variance for both classes)


```r
lda_stats <- lda_stats %>%
  mutate(class_prior=class_size/sum(class_size),
         sigma2=sum(sum_squares) / (sum(class_size) - 2)) %>%
  select(default, class_mean, class_prior, sigma2)

kable(lda_stats)
```



|default | class_mean| class_prior|   sigma2|
|:-------|----------:|-----------:|--------:|
|No      |   803.9438|      0.9667| 205318.6|
|Yes     |  1747.8217|      0.0333| 205318.6|

Linear Discriminant Analysis (predict)
=======================================

How do we predict with LDA?

- Predict `Yes` if $P(Y=1|X) > P(Y=0|X)$
- Equivalently:

$$
\log{\frac{P(Y=1|X)}{P(Y=0|X)}} > 0 \Rightarrow \\
\log f_1(x) + \log \pi_1 > \log f_0(x) + \log \pi_0
$$

- This turns out to be a linear function of $x$!


Linear Discriminant Analysis (predict)
====================================


```r
lda_log_ratio <- function(balance, lda_stats) {
  n <- length(balance)
  
  # subtract class mean
  centered_balance <- rep(balance, 2) - rep(lda_stats$class_mean, each=n)
  
  # scale by standard deviation
  scaled_balance <- centered_balance / sqrt(lda_stats$sigma2[1])
  
  # compute log normal density and add log class prior
  lprobs <- dnorm(scaled_balance, log=TRUE) + log(rep(lda_stats$class_prior, each=n))
  
  # compute log ratio of class probabilities
  lprobs <- matrix(lprobs, nc=2)
  colnames(lprobs) <- lda_stats$default
  lprobs[,"Yes"] - lprobs[,"No"]
}
```

Linear Discriminant Analysis (predict)
================================



```r
test_balance <- seq(0, 3000, len=100)
plot(test_balance, lda_log_ratio(test_balance, lda_stats),
     type="l", xlab="Balance", ylab="Log Probability Ratio", cex=1.4)
```

![plot of chunk unnamed-chunk-10](Classification2-figure/unnamed-chunk-10-1.png) 

Quadratic Discriminant Analysis
================================

We can get a quadratic decision boundary by letting each class have it's own variance


```r
qda_stats <- qda_stats %>%
  summarize(class_mean=first(class_mean),
            class_size=n(),
            class_sigma2=sum(squared_error) / (class_size - 1))
```


|default | class_mean| class_prior| class_sigma2|
|:-------|----------:|-----------:|------------:|
|No      |   803.9438|      0.9667|     208370.6|
|Yes     |  1747.8217|      0.0333|     116463.0|

Quadratic Discriminant Analysis
================================

![plot of chunk unnamed-chunk-13](Classification2-figure/unnamed-chunk-13-1.png) 

Quadratic Discriminant Analysis
================================



![plot of chunk unnamed-chunk-15](Classification2-figure/unnamed-chunk-15-1.png) 

Evaluation
============

How well did LDA do?


```r
library(MASS)
lda_fit <- lda(default ~ balance, data=Default)
lda_pred <- predict(lda_fit, data=Default)
print(table(predicted=lda_pred$class, observed=Default$default))
```

```
         observed
predicted   No  Yes
      No  9643  257
      Yes   24   76
```

```r
# error rate
mean(Default$default != lda_pred$class) * 100
```

```
[1] 2.81
```

Evaluation
============

How well did LDA do?

Not very well, we can get similar error rate
by always predicting "no default"

- From table above, LDA errors are not symmetric, most common error is that _it misses true defaults_

- Also, when can we say a classifier is better than another classifier? (next lecture)

*** 

```r
# LDA error rate
mean(Default$default != lda_pred$class) * 100
```

```
[1] 2.81
```

***


```r
# dummy error rate
mean(Default$default != "No") * 100
```

```
[1] 3.33
```

Evaluation
===========

Need a more precise language to describe classification errors:

|                   | True Class +        | True Class -        | Total |
|------------------:|:--------------------|---------------------|-------|
| Predicted Class + | True Positive (TP)  | False Positive (FP) | T*    |
| Predicted Class - | False Negative (FN) | True Negative (TN)  | F*    |
| Total             | T                   | F                   |       |


```
         observed
predicted   No  Yes
      No  9643  257
      Yes   24   76
```

Evaluation
===========

Need a more precise language to describe classification errors:

|                   | True Class +        | True Class -        | Total |
|------------------:|:--------------------|---------------------|-------|
| Predicted Class + | True Positive (TP)  | False Positive (FP) | P*    |
| Predicted Class - | False Negative (FN) | True Negative (TN)  | N*    |
| Total             | P                   | N                   |       |

| Name                            | Definition | Synonyms                                          |
|--------------------------------:|:-----------|---------------------------------------------------|
| False Positive Rate (FPR)       | FP / N     | Type-I error, 1-Specificity                       |
| True Positive Rate (TPR)        | TP / P     | 1 - Type-II error, power, sensitivity, **recall** |
| Positive Predictive Value (PPV) | TP / P*    | **precision**, 1-false discovery proportion       |
| Negative Predicitve Value (NPV) | FN / N*    |                                                   |

In the credit default case we may want to increase **TPR** (recall, make sure we catch all defaults) at the expense
of **FPR** (1-Specificity, clients we lose because we think they will default)

Evaluation
===========

How can we adjust TPR and FPR?

Remember we are classifying `Yes` if 

$$
\log \frac{P(Y=\mathtt{Yes}|X)}{P(Y=\mathtt{No}|X)} > 0 \Rightarrow \\
P(Y=\mathtt{Yes}|X) > 0.5
$$

What would happen if we use $P(Y=\mathtt{Yes}|X) > 0.2$?

***

![plot of chunk unnamed-chunk-20](Classification2-figure/unnamed-chunk-20-1.png) 

Evaluation
===========


```r
library(ROCR)
pred <- prediction(lda_pred$posterior[,"Yes"], Default$default)

layout(cbind(1,2))
plot(performance(pred, "tpr"))
plot(performance(pred, "fpr"))
```

![plot of chunk unnamed-chunk-21](Classification2-figure/unnamed-chunk-21-1.png) 

Evaluation
============
left: 30%

- **ROC curve** (Receiver Operating Characteristic) 
- **AUROC** (area under the ROC)

***


```r
auc <- unlist(performance(pred, "auc")@y.values)
plot(performance(pred, "tpr", "fpr"), 
     main=paste("LDA AUROC=", round(auc, 2)), 
     lwd=1.4, cex.lab=1.7, cex.main=1.5)
```

![plot of chunk unnamed-chunk-22](Classification2-figure/unnamed-chunk-22-1.png) 

Evaluation
=============


```r
full_lda <- lda(default~., data=Default)
full_lda_preds <- predict(full_lda, Default)

pred_list <- list(
  balance_lda = lda_pred$posterior[,"Yes"],
  full_lda = full_lda_preds$posterior[,"Yes"],
  dummy = rep(0, nrow(Default)))

pred_objs <- lapply(pred_list,
  prediction, Default$default)

aucs <- sapply(pred_objs, 
  function(x) unlist(
    performance(x, "auc")@y.values))

roc_objs <- lapply(pred_objs, 
  performance, "tpr", "fpr")
```

Evaluation
===========




```r
for (i in seq(along=roc_objs)) {
  plot(roc_objs[[i]], add = i != 1, col=i, 
       lwd=3, cex.lab=1.5)
}
legend("bottomright", 
       legend=paste(gsub("_", " ", names(pred_list)), "AUROC=",round(aucs, 2)), 
       col=1:3, lwd=3, cex=2)
```

Evaluation
===========



![plot of chunk unnamed-chunk-27](Classification2-figure/unnamed-chunk-27-1.png) 

Evaluation
============

Also consider the precision-recall curve:



```r
library(caTools)
pr_objs <- lapply(pred_objs, 
  performance, "prec", "rec")

for (i in seq(along=pr_objs)) {
  plot(pr_objs[[i]], add = i != 1, col=i, 
       lwd=3, cex.lab=1.5)
}
legend("bottomleft", 
       legend=paste(gsub("_", " ", names(pred_list))),
      col=1:3, lwd=3, cex=2)
```

Evaluation
============

Also consider the precision-recall curve:

![plot of chunk unnamed-chunk-29](Classification2-figure/unnamed-chunk-29-1.png) 

K Nearest neighbor classifier
==============================

Use `knn` function in package `class`



![plot of chunk unnamed-chunk-31](Classification2-figure/unnamed-chunk-31-1.png) 

Summary
========

- Think of classification as a class probability estimation problem
- Logistic regression and LDA partition predictor space with linear functions:
  - logistic regression learns parameter using Maximum Likelihood (numerical optimization)
  - LDA learns parameter using means and variances (and assuming normal distribution)
- K nearest neighbor nonlinear, but easy to overfit

Summary
========

- Error and accuracy not enough to understand classifier performance
- Classifications can be done using probability cutoffs to trade, e.g., TPR-FPR (ROC curve), or precision-recall (PR curve)
- Area under ROC or PR curve summarize classifier performance across different cutoffs
