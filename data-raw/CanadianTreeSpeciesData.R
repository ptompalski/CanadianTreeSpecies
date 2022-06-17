## code to prepare `CanadianTreeSpeciesData` dataset goes here

library(tidyverse)
library(magrittr)

# download CASFRI species code mapping
CASFRI_species <- read_csv("https://raw.githubusercontent.com/CASFRI/CASFRI/master/translation/tables/species_code_mapping.csv")

#read NFI species
NFI_species <- read_csv("data-raw/NFI_species.csv")

#read canfi species codes
canfi_species <- read_csv("data-raw/canfi_species.csv")


### combining datasets

#add casfri code to NFI_species
NFI_species %<>%
  mutate(Var2 = if_else(is.na(Var),"###",Var)) %>% #temporary column for Var with "###" instead of NA
  unite(col = casfri_species_codes, Genus, Species, Var2, sep = "_", remove = F) %>%
  select(-Var2)


#combine NFI and CASFRI species
S <- CASFRI_species %>% left_join(NFI_species)

#there are more species listed in CASFRI than in NFI:
S %>% select(casfri_species_codes, scientific_name, Genus, Species, Var, ends_with("codes")) %>%
  filter(is.na(Genus)) %>%
  print(n=50)

# for species that are not present in NFI, get genus/species/var from casfri_species_code
S %<>%
  separate(casfri_species_codes, into = c("genus2", "species2", "var2"), sep = "_", remove = F) %>%
  mutate(var2 = if_else(var2 == "###", NA_character_, var2)) %>%

  mutate(Genus = if_else(is.na(Genus), genus2, Genus)) %>%
  mutate(Species = if_else(is.na(Species), species2, Species)) %>%
  mutate(Var = if_else(is.na(Var), var2, Var)) %>%
  mutate(ScientificName = if_else(is.na(ScientificName), scientific_name, ScientificName)) %>%
  select(-genus2, -species2, -var2)


# combine with canfi_species codes
S %<>% unite(spp, Genus, Species, sep=".", remove = F) %>%
  left_join(canfi_species) %>%
  rename(canfi_species_code = canfi_species) %>%
  select(-spp)

### add NFI-like species code
S %<>% unite(NFI_code, Genus, Species, Var, sep = ".", remove = F, na.rm = T)


### cleanup ####
S %<>%  select(-casfri_species_codes_OLD,
               -scientific_name,
               -casfri_species_codes,
               -Comment,
               -pc02_species_codes,
               -pc01_species_codes,
               -Form,
               -Type)


S %<>% rename_with(.fn = ~str_replace(.x, "_species_codes", "_code"))
S %<>% rename(canfi_code = canfi_species_code)

S %<>% relocate(CommonNameEnglish, CommonNameFrench, ScientificName, Genus, Species, Var, NFI_code)

### save
CanadianTreeSpeciesData <- S

write_csv(CanadianTreeSpeciesData, "data-raw/CanadianTreeSpeciesData.csv")

usethis::use_data(CanadianTreeSpeciesData, overwrite = TRUE)
