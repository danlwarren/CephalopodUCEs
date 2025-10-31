# Retrieving Trait Data

## Species counts per family

We retrieved species counts per family using the **worrms** R package (Chamberlain 2023). We retrieved descendant taxa for each family using **wm_records_taxamatch**, and then split those into genus records and subfamily records, and filtered each so that the only taxon names left in the data were the current valid names (as of June 19, 2025). For subfamilies we retrieved the constituent genera using **wm_children**, and then cycled through the family and subfamily datasets to get a list of valid genera from each into a shared data frame containing all extant genera of cephalopods. We then used this data frame to retrieve all species records for each genus and filtered these for species that have currently accepted and valid taxon names. Finally we grouped these by family and counted the number of species per family using **dplyr** (Wickham et al. 2023). Code for these steps is given in Species_Counts.R in this directory, and .csv files are included for the raw species data, filtered species data, and count data.

## Maximum and minimum depth per family

We retrieved distribution information from OBIS (OBIS 2025) by using the **robis** package for R. We obtained all occurrence records for taxon id = 11707 (Cephalopoda), and used **dplyr** (Wickham et al. 2023) to select only the family and depth columns. From there we grouped data points by family, removed incomplete records, and summarised data by taking the maximum absolute value of maximumDepthInMeters and minimum absolute value of minimumDepthInMeters for each family. Code is given in the file Depths.R in this directory.

## Citations

Chamberlain S, Vanhoorne. B (2023). worrms: World Register of Marine Species (WoRMS) Client\_. R package version 0.4.3, <https://CRAN.R-project.org/package=worrms>.

OBIS (2025) Ocean Biodiversity Information System. Intergovernmental Oceanographic Commission of UNESCO. <https://obis.org.>

Wickham H, François R, Henry L, Müller K, Vaughan D (2023). \_dplyr: A Grammar of Data Manipulation\_. R package version 1.1.4, <https://CRAN.R-project.org/package=dplyr>.
