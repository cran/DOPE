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

category <- unique(dea_factsheets$category)

# category

class <- dea_factsheets %>% 
  arrange(class) %>% 
  # filter(class == "steroids") %>% 
  select(class)
  

#load("../../data/dea_brands.rda")

class2 <- unique(dea_brands$class)

brands <- dea_brands %>% 
  arrange(class) %>% 
  #filter(type == "oxycodone") %>% 
  pull(brands)

#load("../../data/dea_controlled.rda")
#load("../../data/dea_street_names.rda")



#unique(slang$brand)
#unique(slang$Class)

duplicates <- dea_street_names %>% 
  group_by(slang) %>% 
  filter(n() > 1) %>% 
  arrange(slang)

# unique(duplicates)

## -----------------------------------------------------------------------------
sort(category) %>% 
  knitr::kable(col.names = "Category")

## ---- cache=FALSE, echo=FALSE, fig.align="center", fig.cap="Figure 1 shows the DEA website drug ontology. Problematic entries shown with a red callout.", out.width="100%"----
knitr::include_graphics("../inst/extdata/Drugs.jpg", error = FALSE)

