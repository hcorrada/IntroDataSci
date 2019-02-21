library(tidyverse)
library(rvest)

# parse html file into node data structure
url <- "https://www.spaceweatherlive.com/en/solar-activity/top-50-solar-flares"
html <- url %>%
  read_html()


# select tables by element
# css selector
html %>%
  html_nodes("table")


# select document node with
# top 50 solar flare table
# by class css selector
table_node <- html %>%
  html_nodes(".table-responsive-md")

# select children nodes corresponding
# to table rows using element css
# selector
table_node %>%
  html_nodes("tr") 

# parse table into data frame
table_node %>%
  html_table()

 