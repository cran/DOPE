#' Drug ontology information from https://www.dea.gov/factsheets
#'
#' A dataset containing a record for each drug category listed on https://www.dea.gov/factsheets, the class in which that drug belongs in and path to the factsheet.
#'
#' @docType data
#'
#' @usage data(dea_factsheets)
#'
#' @format A tibble with 29 rows and 3 variables:
#' \describe{
#'   \item{class}{the drug class}
#'   \item{category}{the drug category}
#'   \item{fact_path}{the unique path to the drug's factsheet}
#'   }
#' @source \href{https://www.dea.gov/factsheets}{https://www.dea.gov/factsheets}
"dea_factsheets"
