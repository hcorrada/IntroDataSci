# I hypothesize that Russ Feingold is polling at greater than 50% of the vote
# in the Wisconsin senate race. According to the latest Marquette poll (http://www.realclearpolitics.com/epolls/2016/senate/wi/wisconsin_senate_johnson_vs_feingold-3740.html)
# he got .48 of the vote out of 878 likely voters. 

# Q1: let's construct a confidence interval for the population proportion based 
#     on the estimate that \hat{p}=.48

phat <- .48
n <- 878

standard_error <- sqrt(phat * (1-phat)) / sqrt(n)
half_margin <- -qnorm(.05/2, sd=standard_error)
phat_low <- phat - half_margin
phat_high <- phat + half_margin

# Q2: let's test the hypothesis that p>.50
# null: p <= .5
# alternative: p > .5

# what's the probability of observing a value p >= .48 _under the null hypothesis_
