## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "  ",
  message = FALSE,
  warning = FALSE
)

## ----setup--------------------------------------------------------------------
library(DOPE)
library(dplyr)
library(stringr)

## ----data, echo=TRUE----------------------------------------------------------
dim(drug_df)

str(drug_df)

class(drug_df)

## ----messy--------------------------------------------------------------------

messy_data <- drug_df %>% 
  # select records that have problematic characters
  filter(str_detect(textdrug, ",|;|and|\\/|=|\\(")) %>% 
  distinct(textdrug)

knitr::kable(messy_data)


## -----------------------------------------------------------------------------
drug_names <- DOPE::parse(messy_data$textdrug)

drug_names

## ----lookup_df, echo=TRUE-----------------------------------------------------
dim(lookup_df)

str(lookup_df)

class(lookup_df)

## -----------------------------------------------------------------------------
results <- lookup(unique(drug_names))
head(results, 15) %>%
  knitr::kable()

## -----------------------------------------------------------------------------
filtered_df <- compress_lookup(results)
head(filtered_df)

## -----------------------------------------------------------------------------
results <- lookup_syn("shrooms")
head(results)

