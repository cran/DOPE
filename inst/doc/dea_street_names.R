## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
#  library(pdftools)
#  x <- pdf_text("../inst/extdata/DIR-020-17DrugSlangCodeWords.pdf")
#  
#  sink("slang.txt")
#  cat(x[2:7])
#  sink()

## -----------------------------------------------------------------------------
#  library(readr)  # read_delm
#  
#  s <- read_delim("../inst/extdata/slangUE.txt", "~", escape_double = FALSE,
#                  col_names = c("class", "brand", "slang"),
#                  col_types = cols(
#                    class = col_character(),
#                    brand = col_character(),
#                    slang = col_character()),
#                    trim_ws = TRUE)
#  
#  library(tidyr)  # for separate_rows()
#  library(stringr)  #str_squish
#  suppressPackageStartupMessages(library(dplyr))  # mutate  %>%
#  
#  dea_street_names <- separate_rows(s, slang, sep = ";") %>%
#    mutate(slang = str_squish(slang)) %>%
#    distinct() # Blaze listed twice in Synthetic Cannabinoids
#  

## -----------------------------------------------------------------------------
#  usethis::use_data(dea_street_names,overwrite = TRUE)

