library(purrr)
library(dplyr)
library(arrow)
library(readr)
library(janitor)
library(haven)
library(stringr)

arrow_info()

try(dir.create("csv"))
try(dir.create("zip"))
try(dir.create("dta"))
try(dir.create("parquet"))

extract <- function(t, dir = "csv") {
  system(sprintf("7z e -aos %s -oc:%s", t, dir))
}

fix_chr <- function(x) { str_to_lower(str_squish(x)) }
