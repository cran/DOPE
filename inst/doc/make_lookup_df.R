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
  bind_rows(c(category = "morphine", brand = "ms contin"))

## -----------------------------------------------------------------------------
dea_class_cat <- DOPE::dea_factsheets %>%
  mutate(across(where(is.character), tolower)) %>%
  mutate(category =
           case_when(category == "peyote and mescaline" ~ "mescaline",
                     category == "ghb - gamma-hydroxybutyric acid" ~ "ghb",
                     category == "ecstasy or mdma (also known as molly)" ~ "mdma",
                     category == "flakka (alpha-pvp)" ~ "flakka",

                     TRUE ~ category))


## -----------------------------------------------------------------------------
dea_street_names <- DOPE::dea_street_names %>%
  mutate(across(where(is.character), tolower)) %>%
  mutate(category =
           case_when(category == "fentanyl and fentanyl derivatives"	~ "fentanyl",
                     TRUE ~ category))


## -----------------------------------------------------------------------------
# the these drugs do not have fact sheets but they appear on the DEA

# DEA website (in slang)
missing <- tribble(
  ~category, ~class, ~fact_path,
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
  ~category,  ~class, ~fact_path,
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
categories <- data.frame(allCat = c(dea_brands$category,
                                   dea_street_names$category,
                                   dea_class_cat$category,
                                   missing$category,
                                   extraNewSlang$category)) %>%
  distinct() %>%
  arrange()

## -----------------------------------------------------------------------------
library(sqldf)
lookup_df <- sqldf("select cc.class, a.category, a.syn synonym from
                (select b.category, b.brand as syn from dea_brands as b
                 union
                 select s1.category, s1.slang as syn from dea_street_names as s1
                 union
                 select s2.category, s2.brand as syn from dea_street_names as s2 where s2.brand <> NULL
                 union
                 select ns.drug, ns.street_name as syn from noslang_street_names as ns) as a
              left join dea_class_cat as cc on a.category = cc.category")

#use_data(lookup_df, overwrite = TRUE)

## ----fix_missing_class, echo=FALSE--------------------------------------------
na_lookup <- filter(lookup_df, is.na(class))
length(unique(na_lookup$category)) # 30 unique categories with no class
# *am = depressants
# *mine = hallucinogen as per DAN 3/29/21
# *2cb = hallucinogen
# *amt = hallucinogen 
# *trite = depressants
# *deine = narcotics (opioids)
# crack = stimulants

lookup_df2 <- lookup_df %>% 
  mutate(class = case_when(str_detect(category, "(?=.*am$)|(?=.*trite$)|(gbl)|(?=.*qualone$)|(?=.*ital$)") == TRUE ~ "depressants",
                           str_detect(category, "crack|(?=.*cathin)|(?=.*date$)|(ritalin)|(?=.*phetamine$)") == TRUE ~ "stimulants",
                           str_detect(category, "(?=.*amt$)|(?=.*2cb$)|(?=.*mine$)|(dmt)|(?=.*room)|(pcp)|(peyote)") == TRUE ~ "hallucinogen",
                           str_detect(category, "(?=.*deine$)|(?=.*one$)") == TRUE ~ "narcotics (opioids)",
                           str_detect(category, "(?=.*marijuana)|(?=.*cannab)") == TRUE ~ "cannabis",
                           category == "dextromethorphan" ~ "antitussives",
                           category == "nitrous oxide" ~ "inhalant",
                           TRUE ~ class
  )
  )

#check missing again
na_lookup <- filter(lookup_df2, is.na(class))
lookup_df <- lookup_df2


## -----------------------------------------------------------------------------
iqvia <- DOPE::iqvia %>%
  mutate(across(where(is.character), tolower)) 

lookup_df <- lookup_df %>% 
  bind_rows(iqvia)



## -----------------------------------------------------------------------------
# get classes & categories
unique(lookup_df$class)
unique(lookup_df$category)

lookup_df3 <- lookup_df %>% 
  mutate(class = if_else(class != "cannabis", str_replace(class, "s$", ""), class),
         class = case_when(class == "narcotics (opioids)" ~ "narcotic (opioid)",
                           TRUE ~ class),
         category = if_else(category != "mushrooms", str_replace(category, "s$", ""), category)
         )

lookup_df <- lookup_df3
use_data(lookup_df, overwrite = TRUE)

