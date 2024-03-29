% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lookup.R
\name{lookup}
\alias{lookup}
\title{Make a table with the class and category for a drug name}
\usage{
lookup(
  drug_vec = NULL,
  ...,
  searchClass = TRUE,
  searchCategory = TRUE,
  searchSynonym = TRUE
)
}
\arguments{
\item{drug_vec}{a vector of strings holding possible drug names}

\item{...}{multiple strings holding possible drug names}

\item{searchClass}{Should the substances listed in \code{...} be searched
for in column \code{class}? Defaults to TRUE.}

\item{searchCategory}{Should the substances listed in \code{...} be searched
for in column \code{category}? Defaults to TRUE.}

\item{searchSynonym}{Should the substances listed in \code{...} be searched
for in column \code{synonym}? Defaults to TRUE.}
}
\value{
A lookup table with category \code{data.frame} having four columns:
original search term, drug class, drug category, and drug street name.
}
\description{
This function provides a table with drug class and category
information all of the known drugs.
}
\examples{
  lookup("zip", "shrooms")
}
