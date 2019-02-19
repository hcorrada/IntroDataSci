library(tidyverse)
arrest_tab <- read_csv("data/BPD_Arrests.csv")
arrest_tab

# index attributes by name
select(arrest_tab, sex, age, district)

# index attributes by position
select(arrest_tab, 1, 3, 4)

# index attributes by position (range)
select(arrest_tab, 1:4)

# index entities by position (range)
slice(arrest_tab, 1:4)

# filter by attribute values
filter(arrest_tab, age < 17)
filter(arrest_tab, age >= 18 & age <= 25)

# filter to age >= 18 and age <= 25
# select sex, age, district
select(
  filter(arrest_tab, age >= 18 & age <= 25),
  sex, age, district)

# same pipeline
arrest_tab %>%
  filter(age >= 18 & age <= 25) %>%
  select(sex, age, district)

# exercise
arrest_tab %>%
  filter(age >= 18 & age <= 25) %>%
  select(sex, district, arrestDate) %>%
  sample_frac(.5)

# filters dataset to arrests from the “SOUTHERN” district occurring before “12:00” (arrestTime)
# selects attributes, sex, age
# samples 10 entities at random (sample_n)
arrest_tab %>%
  filter(district == "SOUTHERN" & arrestTime < "12:00") %>%
  select(sex, age) %>%
  sample_n(10)

# age in months
mutate(arrest_tab, age_in_months = 12 * age) %>%
  select(-age)

summarize(arrest_tab, num_arrests=n(), 
          mean_age=mean(age, na.rm=TRUE))


arrest_tab %>%
  filter(!is.na(sex)) %>%
  group_by(sex) %>%
  summarize(num_arrests=n(),
            mean_age=mean(age, na.rm=TRUE))


library(lubridate)
arrest_tab %>%
  mutate(early_arrest=arrestTime <= hms("12:00:00")) %>%
  select(age, arrestTime, early_arrest) %>%
  group_by(early_arrest) %>%
  summarize(num_arrests=n(),
            mean_age=mean(age, na.rm=TRUE))

## filters records to 
#     the southern district and 
#     ages between 18 and 25
#  computes mean arrest age for each sex
arrest_tab %>%
  filter(district == "SOUTHERN",
         age >= 18,
         age <= 25) %>%
  group_by(sex) %>%
  summarize(mean_age=mean(age))















  
  
  
  




