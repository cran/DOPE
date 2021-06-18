## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------
#  knitr::opts_chunk$set(echo = TRUE)
#  library(DOPE)

## ---- cache=FALSE, echo=FALSE, fig.align="center", fig.cap="Figure 1. Console", out.width=5----
#  knitr::include_graphics("../inst/extdata/console.png", error = FALSE)

## -----------------------------------------------------------------------------
#  library(conflicted)
#  suppressMessages(conflict_prefer("filter", "dplyr"))
#  library(xml2)  # read_html()
#  library(rvest)  # html_nodes(), html_text()
#  library(purrr)  # map_dfr()
#  library(stringr)  # str_to_lower()
#  library(tibble)  # tibble(),
#  suppressPackageStartupMessages(library(dplyr))  # %>%, bind_rows()
#  
#  get_drug_factsheets <- function(pg_num){
#    category <- read_html(paste0("https://www.dea.gov/factsheets?field_fact_sheet_category_target_id=All&page=", pg_num)) %>%
#      html_nodes(".teaser-title--drug_fact_sheet span") %>%
#      html_text() %>%
#      str_to_lower()
#    class <- read_html(paste0("https://www.dea.gov/factsheets?field_fact_sheet_category_target_id=All&page=", pg_num)) %>%
#      html_nodes(".teaser-category--drug-category") %>%
#      html_text() %>%
#      str_to_lower()
#    #get correct path to factsheet
#    path <- read_html(paste0("https://www.dea.gov/factsheets?field_fact_sheet_category_target_id=All&page=", pg_num)) %>%
#      html_nodes(".teaser-title--drug_fact_sheet a") %>%
#      html_attr("href")
#    #return 1x2 tibble
#    tibble("class" = class,
#           "category" = category,
#           "fact_path" = path
#           )
#  }
#  
#  dea_factsheets <- map_dfr(0:2, get_drug_factsheets)
#  

## -----------------------------------------------------------------------------
#  
#  # function to pull the data - specifically the brand names of each of
#  #   the drug types from their factsheets
#  get_brand <- function(drug_path, drug_category){
#    drug_brands <- read_html(paste0("https://www.dea.gov", drug_path)) %>%
#      html_nodes(".field--what") %>%  # name of the div with the brand names
#      html_text() %>%
#      str_remove_all("\n") %>%  # remove line breaks
#      str_split(" ", simplify = TRUE) %>%  # split the vector into individual strings
#      .[str_detect(., "®")] %>%  # find the strings that include the registered trademark symbol and subset
#      str_remove_all(., "[,|.]")  # remove extra characters
#    tibble("category" = drug_category,
#           "brands" = drug_brands)
#  }
#  
#  dea_brands <- map2_dfr(dea_factsheets$fact_path, dea_factsheets$category, get_brand)

## -----------------------------------------------------------------------------
#  usethis::use_data(dea_factsheets, overwrite = TRUE)
#  usethis::use_data(dea_brands, overwrite = TRUE)

