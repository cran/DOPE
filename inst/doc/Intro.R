## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  echo = FALSE,
  eval = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(conflicted)
suppressMessages(conflict_prefer("filter", "dplyr"))
library(dplyr)
library(DOPE)

## -----------------------------------------------------------------------------
data(dea_factsheets)

#load("../../data/dea_factsheets.rda")

class <- unique(dea_factsheets$class)

# class

category <- dea_factsheets %>%
  arrange(category) %>%
  # filter(category == "steroids") %>%
  select(category)


#load("../../data/dea_brands.rda")

category2 <- unique(dea_brands$category)

brands <- dea_brands %>%
  arrange(category) %>%
  #filter(type == "oxycodone") %>%
  pull(brands)

#load("../../data/dea_controlled.rda")
#load("../../data/dea_street_names.rda")



#unique(slang$brand)
#unique(slang$Category)

duplicates <- dea_street_names %>%
  group_by(slang) %>%
  filter(n() > 1) %>%
  arrange(slang)

# unique(duplicates)

## -----------------------------------------------------------------------------
sort(class) %>%
  knitr::kable(col.names = "Class")

## ---- cache=FALSE, echo=FALSE, fig.align="center", fig.cap="Figure 1 shows the DEA website drug ontology. Problematic entries shown with a red callout.", out.width="100%"----
knitr::include_graphics("../inst/extdata/Drugs.jpg", error = FALSE)

