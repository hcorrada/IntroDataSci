library(tidyverse)
data(Auto)

# faceting and discretization example
Auto %>%
  mutate(discrete_mpg = cut(mpg, breaks=4)) %>%
  ggplot(aes(x=weight, y=horsepower)) +
    geom_point() +
    facet_wrap(~discrete_mpg)


# imputing
flights %>%
  mutate(mean_delay = mean(dep_delay, na.rm=TRUE)) %>% 
  mutate(imputed_delay = ifelse(is.na(dep_delay), mean_delay, dep_delay)) %>%
  ggplot(aes(x=log(imputed_delay+10))) +
    geom_histogram() 
