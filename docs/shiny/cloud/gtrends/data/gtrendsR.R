#=====================================================================#
# File name: gtrendsR.R
# This is code to create: Google trends for BioMarin App
# Authored by and feedback to: mjfrigaard
# Last updated: 2020-12-13
# MIT License
# Version: 1.0
#=====================================================================#

# description -------------------------------------------------------------
# download Google trend data in R and export at two .csv files


# packages ----------------------------------------------------------------
# install.packages("gtrendsR")
library(gtrendsR)
library(tidyverse)

# locate country geos -----
data("countries")
filter(countries, sub_code == "US-CA")

# trend data --------------------------------------------------------------
LAGoogleRaw <- gtrendsR::gtrends(c("COVID", "Unemployment", "Inflation"), 
                                    time = "all", geo = "US-CA")
LAGoogleRaw %>% glimpse()
# export LAGoogleRaw -----------------------------------------------------
# fs::dir_ls("docs/data")
write_rds(x = LAGoogleRaw, file = paste0("./data/",
                              noquote(lubridate::today()),
                              "-LAGoogleRaw.rds"))

# wrangle interest over time -------------------------------------------------
# interest over time
LAGoogleRawIOT <- LAGoogleRaw$interest_over_time
LAGoogleIOT <- LAGoogleRawIOT %>% 
    mutate(
        hits = case_when(
            hits == "<1" ~ "0",
            TRUE ~ hits),
        hits_num = as.numeric(hits),
        month = lubridate::month(date, label = TRUE, abbr = TRUE),
        year = lubridate::year(date)) 

LAGoogleIOT %>% 
    filter(year > 2004) %>% 
    ggplot(aes(x = date, y = hits_num, group = keyword)) + 
    geom_line(aes(color = keyword)) + 
    theme_minimal()

# export LAGoogleIOT -----------------------------------------------------
write_csv(x = LAGoogleIOT, file = paste0("./data/",
                              noquote(lubridate::today()),
                              "-LAGoogleIOT.csv"))


LAGoogleDMA <- LAGoogleRaw$interest_by_dma
LAGoogleDMA %>% 
    filter(keyword == "COVID") %>% 
    ggplot(aes(x = hits, 
        y = forcats::fct_reorder(
            .f = location, 
            .x = hits))) + 
    geom_col(aes(fill = hits), width = .7)

write_csv(x = LAGoogleDMA, file = paste0("./data/",
                              noquote(lubridate::today()),
                              "-LAGoogleDMA.csv"))

LAGoogleCITY <- LAGoogleRaw$interest_by_city



