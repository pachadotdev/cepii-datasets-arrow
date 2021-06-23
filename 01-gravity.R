source("00-pkgs-and-funs.R")

# docs ----

url <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/gravdata_codebook_2015.pdf"
pdf <- "dta/gravdata_codebook_2015.pdf"
if (!file.exists(pdf)) try(download.file(url, pdf))

# gravity ----

dta <- "dta/gravdata.dta"
if (!file.exists(dta)) extract(zip, "dta")

gravdir <- "parquet/gravity"

if (!dir.exists(gravdir)) {
  gravdata <- read_dta(dta) %>% 
    clean_names() %>% 
    mutate_if(is.character, fix_chr)
  
  gravdata %>% 
    group_by(iso3_o) %>% 
    write_dataset(gravdir, hive_style = F)
}

# gravity light ----

dta <- "dta/col_regfile09.dta"
if (!file.exists(dta)) extract(zip, "dta")

gravlightdir <- "parquet/gravity_light"

if (!dir.exists(gravlightdir)) {
  gravlightdata <- read_dta(dta) %>% 
    clean_names() %>% 
    mutate_if(is.character, fix_chr)
  
  gravlightdata %>% 
    group_by(iso_o) %>% 
    write_dataset(gravlightdir, hive_style = F)
}
