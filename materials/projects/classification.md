---
layout: page
title:  "Project 3: Classification"
---

**Due**: May 3rd, 2016  
**Posted**: April 21, 2016  
**Last Update**: April 21st, 2015  


Note: All required packages and datasets needed for this should be
available in the class Docker image. [More info here](http://cbcb.umd.edu/~hcorrada/IntroDataSci/resources.html)

### Question 1
(This is a modified question 10 Chapter 4 of ISLR)

This question should be answered using the `Weekly` data set, which is
part of the `ISLR` package. This data contains 1,089
weekly stock market returns for 21 years, from the beginning of 1990 to the end
of 2010. You can load this data using:

{% highlight r %}
library(ISLR)
data(Weekly)
{% endhighlight %}

a. Produce some numerical and graphical summaries of the `Weekly`
data. Do there appear to be patterns?

b. Use the full data set to perform a logistic regression with
`Direction` as the response and the five lag variables plus `Volume`
as predictors. Use the `summary` function to print the results. Do any
of the predictors appear to be statistically significant? If so, which
ones?

c. Compute the confusion matrix and overall fraction of correct
predictions. Explain what the confusion matrix is telling you about
the types of mistakes made by logistic regression.

d. Now fit the logistic regression model using a training data period
from 1990 to 2008, with `Lag2` as the only predictor. Compute the
confusion matrix and the overall fraction of correct predictions for
the held out data (that is, the data from 2009 and 2010).
Explain what the confusion matrix is telling you about
the types of mistakes made by logistic regression.


###Question 2

a. Use 10-fold cross validation to estimate prediction error for a
random forest that predicts `Direction` using all predictors (except
the `Today` variable) in the
`Weekly` dataset.

b. Do the same for an SVM using a "radial" kernel.

c. Do the same for an SVM using a "polynomial" kernel.

d. Using a t-test (the lecture notes show how to use the `lm` function to do this), is prediction error for the
SVM with "radial" kernel significantly better than the SVM with "polynomial" kernel.

e. Using a t-test, is prediction error for the random forest
significantly better than the SVM with "radial" kernel? Is it
significantly better than the SVM with "polynomial" kernel?

###Handing in
Submit your answers (including both code and text as appropriate) as
a knitted R markdown file to ELMS:
[https://myelms.umd.edu/courses/1177854/assignments/4171444](https://myelms.umd.edu/courses/1177854/assignments/4171444)
