## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(conflicted)
suppressMessages(conflict_prefer("filter", "dplyr"))

library(DOPE)
library(tibble)
library(dplyr)
library(stringr)
library(usethis)

## -----------------------------------------------------------------------------
dea_brands <- DOPE::dea_brands %>%
  rename("brand" = brands) %>%
  mutate(across(where(is.character), tolower)) %>%
  mutate(brand = str_remove_all(brand, "®")) %>%
  mutate(brand = case_when(brand == "kadianms-contin" ~ "kadian", # two names
                           TRUE ~ brand)) %>%
  bind_rows(c(class = "morphine", brand = "ms contin"))

## -----------------------------------------------------------------------------
dea_class_cat <- DOPE::dea_factsheets %>%
  mutate(across(where(is.character), tolower)) %>%
  mutate(class =
           case_when(class == "peyote and mescaline" ~ "mescaline", 
                     class == "ghb - gamma-hydroxybutyric acid" ~ "ghb",
                     class == "ecstasy or mdma (also known as molly)" ~ "mdma",
                     class == "flakka (alpha-pvp)" ~ "flakka",
                     	
                     TRUE ~ class))


## -----------------------------------------------------------------------------
dea_street_names <- DOPE::dea_street_names %>%
  mutate(across(where(is.character), tolower)) %>%
  mutate(class =
           case_when(class == "fentanyl and fentanyl derivatives"	~ "fentanyl",
                     TRUE ~ class))


## -----------------------------------------------------------------------------
# the these drugs do not have fact sheets but they appear on the DEA 

# DEA website (in slang)
missing <- tribble(
  ~class, ~category, ~fact_path,
  "acetaminophen and oxycodone", "narcotics (opioids)", "DEA slang",
  "alprazolam", "benzodiazepine", "DEA slang" ,
  "clonazepam", "benzodiazepine", "DEA slang"  ,
  "crack cocaine", "stimulants", "DEA slang",
  "hydrocodone", "narcotics (opioids)", "DEA slang",
  "marijuana concentrates", "cannabis", "DEA slang",
  "mushrooms", "hallucinogen", "DEA slang",
  "PCP", "hallucinogen", "DEA slang",
  "promethazine with codeine", "narcotics (opioids)", "DEA slang",
  "ritalin", "stimulants", "DEA slang",
  "synthetic cannabinoids", "designer drugs", "DEA slang",
  "synthetic cathinones", "stimulants", "DEA slang") 

# extras from NoSlang
extraNewSlang <- tribble(
  ~class,  ~category, ~fact_path,
  "2cb", "hallucinogen", "noSlang Term",
  "alpha-ethyltryptamine", "hallucinogen", "noSlang Term",
  "alpha-methyltryptamine", "hallucinogen", "noSlang Term",
  "amobarbital", "depressant", "noSlang Term",
  "amyl nitrite", "inhalant", "noSlang Term",
  "dextromethorphan", "depressant", "noSlang Term",
  "diazepam", "benzodiazepine", "noSlang Term",
  "dimethyltryptamine", "hallucinogen", "noSlang Term",
  "gbl", "depressant", "noSlang Term",
  "isobutyl nitrite", "inhalant", "noSlang Term",
  "methcathinone", "stimulant", "noSlang Term",
  "methaqualone", "depressant", "noSlang Term",
  "nitrous oxide", "inhalant", "noSlang Term"
)

## -----------------------------------------------------------------------------
classes <- data.frame(allClass = c(dea_brands$class,
                                   dea_street_names$class,
                                   dea_class_cat$class,
                                   missing$class,
                                   extraNewSlang$class)) %>%
  distinct() %>%
  arrange(allClass)

## -----------------------------------------------------------------------------
library(sqldf)
lookup_df <- sqldf("select cc.category, a.class, a.syn synonym from
                (select b.class, b.brand as syn from dea_brands as b
                 union
                 select s1.class, s1.slang as syn from dea_street_names as s1
                 union
                 select s2.class, s2.brand as syn from dea_street_names as s2 where s2.brand <> NULL
                 union
                 select ns.drug, ns.street_name as syn from noslang_street_names as ns) as a
              left join dea_class_cat as cc on a.class = cc.class")

use_data(lookup_df, overwrite = TRUE)

