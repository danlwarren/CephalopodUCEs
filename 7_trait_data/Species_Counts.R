library(worrms)
library(dplyr)

families <- c("Alloposidae",
              "Amphitretidae",
              "Ancistrocheiridae",
              "Architeuthidae",
              "Argonautidae",
              "Bathypolypodidae",
              "Bathyteuthidae",
              "Brachioteuthidae",
              "Chiroteuthidae",
              "Chtenopterygidae",
              "Cranchiidae",
              "Cycloteuthidae",
              "Eledonidae",
              "Enoploteuthidae",
              "Enteroctopodidae",
              "Gonatidae",
              "Histioteuthidae",
              "Idiosepiidae",
              "Joubiniteuthidae",
              "Lepidoteuthidae",
              "Loliginidae",
              "Lycoteuthidae",
              "Mastigoteuthidae",
              "Megaleledonidae",
              "Nautilidae",
              "Octopodidae",
              "Octopoteuthidae",
              "Ommastrephidae",
              "Onychoteuthidae",
              "Opisthoteuthidae",
              "Pholidoteuthidae",
              "Pyroteuthidae",
              "Sepiadariidae",
              "Sepiidae",
              "Sepiolidae",
              "Spirulidae",
              "Thysanoteuthidae",
              "Tremoctopodidae",
              "Vampyroteuthidae")



family.df <- do.call(rbind, wm_records_taxamatch(families))
family.df <- family.df %>%
  filter(AphiaID == valid_AphiaID)
  
genera.df <- NULL
for(i in 1:nrow(family.df)){
  genera.df <- rbind(genera.df, wm_children(as.numeric(family.df[i, "AphiaID"])))
}

genera.df <- genera.df %>%
  filter(rank == "Genus" & valid_AphiaID == AphiaID)

species.df <- NULL
for(i in 1:nrow(genera.df)){
  species.df <- rbind(species.df, wm_children(as.numeric(genera.df[i, "AphiaID"])))
}

species.df <- species.df %>%
  filter(rank == "Species" & valid_AphiaID == AphiaID & status == "accepted")

count.df <- species.df %>% 
  group_by(family) %>%
  count()

write.csv(species.df, "species.csv", row.names = FALSE)
write.csv(count.df, "species_counts.csv", row.names = FALSE)
