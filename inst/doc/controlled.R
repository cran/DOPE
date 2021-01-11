## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
#  library(DOPE)

## -----------------------------------------------------------------------------
#  library(readxl)
#  controlled <- read_excel("../inst/extdata/c_cs_alpha.xlsx")

## ----packages-----------------------------------------------------------------
#  library(conflicted)
#  suppressMessages(conflict_prefer("filter", "dplyr"))
#  suppressPackageStartupMessages(library(dplyr))
#  library(stringr)  # str_count & str_detect
#  library(tidyr)  # separate
#  library(readr)  # write_csv

## -----------------------------------------------------------------------------
#  new <- controlled %>%
#    mutate(difficult = str_count(Names, "[(]") > 0 |
#             str_detect(controlled$Names, ",(?=\\S)"))

## -----------------------------------------------------------------------------
#  # filtered rows where synonyms are "difficult"
#  difficult <- new %>%
#    filter(difficult == TRUE)
#  
#  # created an text file (CSV) for all rows with "difficult" synonyms
#  # difficult %>%
#  # select(- difficult) %>%
#  #  write_csv("../inst/extdata/Difficult.csv")
#  
#  # for the 'difficult' synonyms, I plan to split by semicolon
#  # prepped csv file for splitting synonyms via semicolon
#  synonyms_edited <- read_csv("../inst/extdata/Difficult_Edited.csv")
#  
#  # data set of difficult synonyms, all split by semicolon
#  synonyms_difficult <-
#    synonyms_edited %>%
#    separate(
#      Names,
#      into = c("n_1", "n_2", "n_3", "n_4", "n_5", "n_6", "n_7", "n_8", "n_9"),
#      extra = "drop",
#      fill = "right",
#      sep = "[;]",
#      remove = FALSE
#      ) %>%
#    select(everything()) %>%
#    mutate(across(starts_with("n_"), ~str_trim(.x))) %>%
#    pivot_longer(
#      cols = starts_with("n_"),
#      values_to = "synonym",
#      values_drop_na = TRUE) %>%
#    select(-c(name, Names)) %>%
#    filter(synonym != '')

## -----------------------------------------------------------------------------
#  # filtered rows where synonyms are NOT "difficult"
#  easy <- new %>%
#    filter(difficult %in% c(FALSE, NA))
#  
#  # made the comma replacements and created a dataset for each type of
#  # transformation, with the final result being a comma
#  
#  # change semicolon to comma
#  semi_is_gone <-
#    easy %>%
#    slice(6, 64, 80, 378) %>%
#    mutate(Names = str_replace_all(Names, ";", ","))
#  
#  # replace "and" with comma
#  and_is_gone <-
#    easy %>%
#    slice(79, 120, 247, 274, 422, 423) %>%
#    mutate(Names = str_replace_all(Names, " and", ","))
#  
#  # remove the phrase involving ecstasy
#  ecstasy_is_gone <-
#    easy %>%
#    slice(58) %>%
#    mutate(Names = str_remove_all(Names, " has been sold as Ecstasy, i.e."))
#  
#  # remove comma after synonym
#  extra_comma_is_gone <-
#    easy %>%
#    slice(376) %>%
#    mutate(Names = str_remove_all(Names, ","))
#  
#  # replace "or" with comma
#  or_is_gone <-
#    easy %>%
#    slice(328) %>%
#    mutate(Names = str_replace_all(Names, " or", ","))
#  
#  # dataset of rows that did NOT require a comma change
#  #  (i.e. I left them the way they are)
#  easy_nochanges <-
#    easy %>%
#    slice(-6, -58, -64, -79, -80, -120, -247, -274, -328, -376, -378, -422, -423)
#  
#  # bind rows that required a comma change and rows that didn't
#  # now the data is ready to be split by comma
#  synonyms_easy_prep <-
#    bind_rows(
#      semi_is_gone,
#      and_is_gone,
#      ecstasy_is_gone,
#      extra_comma_is_gone,
#      or_is_gone,
#      easy_nochanges
#    )
#  
#  # dataset of easy synonyms, all split by comma
#  synonyms_easy <-
#    synonyms_easy_prep %>%
#    # move the comma separated names into their own columns.
#    #   mine new columns are enough to hold the drugs with MANY synonyms.
#    separate(
#      Names,
#      into = c("n_1", "n_2", "n_3", "n_4", "n_5", "n_6", "n_7", "n_8", "n_9"),
#      extra = "drop",
#      fill = "right",
#      sep = "[,]",
#      remove = FALSE
#      ) %>%
#    # remove extra spaces for all the newly created variables
#    mutate(across(starts_with("n_"), ~str_trim(.x))) %>%
#    # make the dataset long
#    pivot_longer(
#      cols = starts_with("n_"),
#      values_to = "synonym",
#      values_drop_na = TRUE) %>%
#    select(-c(name, Names, difficult)) %>%
#    # get of any blank name columns
#    filter(synonym != '')

## -----------------------------------------------------------------------------
#  dea_controlled <- bind_rows(synonyms_difficult, synonyms_easy) %>%
#    mutate(synonym = if_else(synonym == "Soneryl (UK)", "Soneryl", synonym))  %>%
#    rename("substance" = SUBSTANCE) %>%
#    rename("number" = Number)  %>%
#    rename("schedule" = Schedule)  %>%
#    rename("narcotic" = Narcotic)
#  
#  usethis::use_data(dea_controlled, overwrite = TRUE)

