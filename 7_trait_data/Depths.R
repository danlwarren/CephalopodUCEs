library(dplyr)
library(robis)

# This will take a while so you probably want to store it locally
cephoccs <- occurrence(taxonid = 11707)

depths <- cephoccs %>% 
  select(family, maximumDepthInMeters, minimumDepthInMeters) %>%
  filter(complete.cases(.)) %>%
  group_by(family) %>%
  summarise(max.depth = max(abs(maximumDepthInMeters), na.rm = TRUE),
            min.depth = min(abs(minimumDepthInMeters), na.rm = TRUE))

write.csv(depths, "depths.csv")
