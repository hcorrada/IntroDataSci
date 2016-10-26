raw_geno_data <- read.delim("geno_table.txt")

library(readxl)
raw_sample_info <- read_excel("20130606_sample_info.xlsx")

library(dplyr)

# clean up the sample info table
# add info for hypothetical optimal sample
sample_info <- raw_sample_info %>%
  select(Sample, Population, `Population Description`) %>%
  rename(sample_name = Sample,
         population = Population,
         population_description = `Population Description`) %>%
  bind_rows(data.frame(sample_name="perfect", population_description="Hypothetical optimal human", population="OPT"))

# make a new super population variable 
population_info <- sample_info %>% 
  group_by(population) %>%
  summarize(population_description=first(population_description)) %>%
  mutate(super_population=c("AMR","AFR","EAS","EAS","EUR","EAS",
                            "EAS","AMR","AFR","EUR","EUR","AMR",
                            "AFR","EUR","EAS","EAS","EAS","AFR",
                            "AFR","AMR","OPT", "AMR","EAS","AMR","EAS",
                            "EUR", "AFR"))

# add the super population variable to sample info table  
sample_info <- sample_info %>%
  left_join(select(population_info, -population_description), by="population")

# let's clean up the genotype data
# and add the population information
snp_ids <- raw_geno_data[,1]
sample_names <- colnames(raw_geno_data)[-1]

geno_data <- t(raw_geno_data[,-1]) %>%
    as.data.frame() %>%
    magrittr::set_colnames(snp_ids) %>%
    mutate(sample_name=sample_names) %>%
    left_join(sample_info, by="sample_name")

# let's remove any SNPs that don't change for this dataset
snp_filter <- geno_data %>%
  select(contains("rs")) %>%
  apply(2, sd) %>%
  magrittr::is_greater_than(0)

snps_to_keep <- geno_data %>%
  select(contains("rs")) %>%
  colnames() %>%
  magrittr::extract(snp_filter)

filtered_geno_data <- geno_data %>%
    select(sample_name, population, super_population, one_of(snps_to_keep))

save(filtered_geno_data, file="geno_data.rda")

