## script containts code for parsing zip codes and race data
## from va, md and dc
## libs needed for analysis 

library(readxl)
library(tidyverse)
library(zoo)
library(RcppRoll)
library(lubridate)
library(jsonlite)
library(tidycensus)

#### This section involves parsing the each state's data into a unified format
#### The process results in a format that includes zip_code or ward, date, 
#### Cases and state. 
#### That is followed by a bind to stitch the datasets together. 


## DC 
rolling_dc <- dc_wards_1 %>%
  rename(date = REPORT_DATE, zip_code = WARD, cases = POSITIVE_CASES) %>%
  mutate(date = as.POSIXct(date/1000, origin = "1970-01-01"),
         date = as.Date(date)) %>% arrange(date) %>%
  select(zip_code, date, cases) %>%
  mutate(
    state = "Washington"
  )

## Maryland
rolling_md <- md_zips %>%
  gather(key = date, value = cases, -OBJECTID, -ZIP_CODE)
##
rolling_md$date <- rolling_md$date %>%
  str_replace("F", "") %>%
  str_replace("total","") %>%
  str_replace_all("_", "/")
##
rolling_md <- rolling_md %>%
  replace(is.na(.), 0) %>%
  mutate(date = as.Date(date, "%m/%d/%Y"),
         ZIP_CODE = as.character(ZIP_CODE))%>%
  rename(zip_code = ZIP_CODE, date = date, cases = cases) %>%
  group_by(zip_code, date) %>%
  summarise(cases = sum(cases)) %>%
  mutate(
    state = "Maryland"
  )

## Virginia
rolling_va <- virgina_zips %>%
  #filter(`Number of Cases` != "Suppressed*") %>% 
  mutate(`Number of Cases` = as.double(`Number of Cases`)) %>%
  spread(`ZIP Code`, `Number of Cases`) %>%
  select( -`Number of Testing Encounters`,-`Number of PCR Testing Encounters`,
          -`Not Reported`, -`Out-of-State`) %>%
  replace(is.na(.), 0) %>%
  gather(-`Report Date`, key = `ZIP Code`, value = cases) %>%
  arrange(`ZIP Code`) %>%
  mutate(date = as.Date(`Report Date`, "%m/%d/%Y"))  %>%
  filter(date >= as.Date("2020-05-15")) %>%
  select(`ZIP Code`,date, cases) %>%
  rename(zip_code = `ZIP Code`, date = date) %>%
  group_by(zip_code, date) %>%
  summarise(
    cases = sum(cases)
  ) %>%
  mutate(
    state = "Virginia"
  )

## Binding the datasets together into one frame
md_va_dc_zips <- bind_rows(rolling_md, rolling_va, rolling_dc) %>%
  filter(date >= as.Date("2020-05-15")) 
