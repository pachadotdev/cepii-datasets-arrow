source("00-pkgs-and-funs.R")

url <- "http://www.cepii.fr/DATA_DOWNLOAD/baci/nomenclatures/country_codes_V202001.csv"
csv <- "csv/country_codes_V202001.csv"

country_codes <- read_csv("csv/country_codes_V202001.csv") %>% 
  select(country_code, iso_3digit_alpha) %>% 
  mutate(iso_3digit_alpha = tolower(iso_3digit_alpha))

finp <- list.files("zip", pattern = "BACI", full.names = T)

map(finp, extract, dir = "csv")

finp2 <- list.files("csv", pattern = "BACI", full.names = T)

map(
  finp2,
  function(t) {
    message (t)
    
    dir <- tolower(gsub("csv", "parquet", gsub("(_.*?)_.*", "\\1", t)))
    
    d <- read_csv(t, col_types = cols(k = col_character())) %>% 
      rename(year = t, reporter_iso = i,
             partner_iso = j, product_code = k,
             trade_value_thousands_usd = v,
             trade_quantity_metric_tons = q)
    
    d <- d %>% 
      
      inner_join(country_codes, by = c("reporter_iso" = "country_code")) %>% 
      select(-reporter_iso) %>% 
      rename(reporter_iso = iso_3digit_alpha) %>% 
      
      inner_join(country_codes, by = c("partner_iso" = "country_code")) %>% 
      select(-partner_iso) %>% 
      rename(partner_iso = iso_3digit_alpha) %>% 
      
      select(year, reporter_iso, partner_iso, everything())
    
    d %>% 
      group_by(year, reporter_iso) %>% 
      write_dataset(dir, hive_style = F)
  }
)
