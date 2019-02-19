library(tidyverse)
arrest_tab <- read_csv("data/BPD_Arrests.csv")
arrest_tab


# data
arrest_tab %>%
  group_by(district) %>%
  summarize(num_arrest = n()) %>%

# mapping data attribute to
# graphical attribute
ggplot(aes(y=num_arrest, x=district)) + 
  geom_bar() +
  labs(title="Example Plot")


# Make a box plot 
# showing the distribution of ages 
# for arrests for the SOUTHERN district 
# conditioned on sex.


# Data (operation pipeline)
arrest_tab %>%
  filter(district == "SOUTHERN") %>%
  select(sex, age) %>%
  group_by(sex) %>%
  summarize(mean_age=mean(age, na.rm=TRUE)) %>%

# Mapping
ggplot(aes(x=sex, y=mean_age)) +

# Geometric Representation
  geom_boxplot()










