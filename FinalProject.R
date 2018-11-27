library("rvest")
library(tidyr)
require(mongolite)
library(dplyr )
url <- "https://web.education.wisc.edu/nwhillman/index.php/2017/02/01/party-control-in-congress-and-state-legislatures/"
congress_by_party <- url %>%
  read_html() %>%
  html_table()
# this is wide format . 
congress_by_party <- congress_by_party[[1]]

# conver to long format. year, party, chamber, seats


congress_by_party  <- congress_by_party %>% select(1:7)

names(congress_by_party) <- c('year',
                              paste(congress_by_party[1,2], congress_by_party[2,2]),
                              paste(congress_by_party[1,3], congress_by_party[2,3]),
                              paste(congress_by_party[1,4], congress_by_party[2,4]),
                              paste(congress_by_party[1,5], congress_by_party[2,5]),
                              paste(congress_by_party[1,6], congress_by_party[2,6]),
                              paste(congress_by_party[1,7], congress_by_party[2,7])
                              )
congress_by_party <- congress_by_party[c(3:22),] %>% 
  gather(chamber, seat , -year)





InsertRecords<- function(data) {
  data607_final_project <- mongo( db = "DATA607", collection = "DATA607_Final_Project")
  x <-data607_final_project$insert(data)
  rm(data607_final_project)
  gc()
  x
}

InsertRecords(congress_by_party)
``