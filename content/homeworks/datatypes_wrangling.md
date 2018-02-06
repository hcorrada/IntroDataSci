---
title: "Homework: Datatypes and Wrangling"
---


In this assignment, you will explore and exercise your knowledge of data types, data operations and data plotting.

**DUE**: Thursday Feb. 8, 11:59pm

<!--more-->

## Data types

Choose a dataset from those linked on the [class resources page](/resources/) or found anywhere online. 
The only requirement is that this dataset is downloadable as a CSV (comma separated value) file.
Answer the following questions:

1) Provide a URL to the dataset.  
2) Explain why you chose this dataset.  
3) What are the entities in this dataset? How many are there in this dataset?  
4) How many attributes are there in this dataset?  
5) What is the datatype of each attribute (categorical (ordered or unordered), numeric (discrete or continuous), datetime, geolocation, other)? 
Write a short sentence stating how you determined the type of each attribute. 
Do this for at least 5 attributes, if your dataset contains more than 10 attributes choose 10 of them to describe.  
6) Write R code that loads the dataset using function `read_csv`. Were you able to load the data successfully? If no, why not?  
If yes, show the first 10 rows of the dataset.  

## Wrangling

Write an operation pipeline including at minimum three of the operations we have learned in class: [Notes Section 6](/bookdown-notes/principles-basic-operations.html) and [Notes Section 7](/bookdown-notes/principles-more-operations.html).
If you were able to successfully load your dataset above, you can write the operation pipeline to analyze your dataset. Otherwise, write a pipeline using the `flights` dataset included in package `nycflights13**.

1) Write text to describe the pipeline you are writing and why is it useful as an analysis of the dataset.  
2) Provide R code executing the pipeline and displaying at most the first 10 rows of the result.

**Hint**: In the `flights` dataset you could create a pipeline to make a data frame that lists, in increasing order, the average total delay for each carrier on flights departing from JFK, where total delay is the sum of departure and arrival delays.

## Plotting

Make one plot using `ggplot` of the result of the pipeline you created above. Refer to [Notes Section 8](/bookdown-notes/basic-plotting-with-ggplot.html) to see some examples.

1) Write text describing what you are plotting  
2) Provide R code to create the plot and show the resulting plot

## Submitting

Download the Rmarkdown file here: [HW1 Rmarkdown shell](/misc/hw1_datatypes_wrangling.Rmd) and fill in with your answers. Knit as PDF (or HTML and then print to PDF) and submit to ELMS.
You can see an example submission here: [HW1 Rmarkdown submission example](/misc/hw1_datatypes_wrangling_sample.Rmd) [HW1 PDF submission example](/misc/hw1_datatypes_wrangling_sample.pdf)




