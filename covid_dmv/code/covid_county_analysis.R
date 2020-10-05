##packages needed to automate virus cases in the DMV
library(readxl)
library(tidyverse)
library(zoo)
library(RcppRoll)

#rolling_rates for the DMV and Washington D.C. region
## load data from each of the respective jurisdictions

##download files for dc, md and va
download.file("https://coronavirus.dc.gov/sites/default/files/dc/sites/coronavirus/page_content/attachments/DC-COVID-19-Data-for-October-3-2020-.xlsx", 
              "dc_data.xlsx")
download.file("https://opendata.arcgis.com/datasets/0573e90adab5434f97b082590c503bc1_0.csv", 
              "MDCOVID19_CasesByCounty.csv")
download.file("https://opendata.arcgis.com/datasets/3dbd3e633b344c7c9a0d166b1d6a2b03_0.csv", 
              "MDCOVID19_ConfirmedDeathsByCounty.csv")
download.file("https://opendata.arcgis.com/datasets/14dfc21466d34c2ea250a4642f08e880_0.csv", 
              "MDCOVID19_ProbableDeathsByCounty.csv")
download.file("https://data.virginia.gov/api/views/bre9-aqqr/rows.csv?accessType=DOWNLOAD", 
              "VDH-COVID-19-PublicUseDataset-Cases.csv")

##population_data to calculate per capita rates
population <- read_csv("dmv_county_populations.csv")
##dc files
dc <- read_excel("dc_data.xlsx") 
##va files
va <- read_csv("VDH-COVID-19-PublicUseDataset-Cases.csv")
##three files from maryland
md <- read_csv("MDCOVID19_CasesByCounty.csv")
md_deaths <- read_csv("MDCOVID19_ConfirmedDeathsByCounty.csv")
md_pdeaths <- read_csv("MDCOVID19_ProbableDeathsByCounty.csv")
#clean and combine maryland data
md_1 <- md %>%
  gather(Allegany:Unknown, key = "county", value = infections)
md_2 <- md_deaths %>%
  gather(Allegany:Unknown, key = "county", value = deaths)
md_3 <- md_pdeaths %>%
  gather(Allegany:Unknown, key = "county", value = pdeaths)
md_4 <- bind_rows(md_1, md_2, md_3) %>%
  mutate(DATE = as.Date(DATE))

## fix population vector
population <- population %>%
  select(fips, key, total_pop)

#clean maryland
maryland_data <- md_4 %>% replace(is.na(.), 0) %>%
  rename(locality = county, date = DATE) %>%
  group_by(locality, date) %>%
  summarise(infections = sum(infections),
            deaths = sum(deaths),
            pdeaths = sum(pdeaths)) %>%
  mutate(death_total = deaths + pdeaths) %>%
  arrange(locality) %>% ungroup() %>% group_by(locality) %>%
  inner_join(population, by = c("locality" = "key")) %>%
  mutate(
    death_change = death_total - lag(death_total, default = first(death_total)),
    rolling_deaths = roll_mean(death_change, 7, align = "right", fill = NA),
    infection_change = infections - lag(infections, default = first(infections)),
    rolling_infections = roll_mean(infection_change, 7, align = "right", fill = NA), 
    cases_per100k = (infection_change/total_pop) * 100000,
    rolling_case100k = roll_mean(cases_per100k, 7, align = "right", fill = NA),
    state = "Maryland"
  ) %>%
  select(date, locality, fips, rolling_infections, rolling_deaths, cases_per100k, rolling_case100k) %>%
  filter(date < as.Date("2020-10-01"))

##clean washington_dc
washington_dc <- dc %>% gather(`43897`:`44107`, key = "date", value = "infections") %>%
  select(date, ...2, infections) %>% mutate(date = as.numeric(date)) %>%
  mutate(date = as.Date(dc_test$date, origin = "1899-12-30")) %>% mutate(
    locality = "Washington D.C.",
    fips = as.numeric(11001)
  ) %>%
  inner_join(population, by = "fips") %>%
  filter(...2 %in% c("Total Positives","Number of Deaths")) %>% spread(`...2`, `infections`) %>%
  rename(deaths = `Number of Deaths`, infections = `Total Positives`) %>%
  mutate(
    deaths = as.numeric(deaths),
    infections = as.numeric(infections),
    date = as.Date(date),
    death_change = deaths - lag(deaths, default = first(deaths)),
    infection_change = infections - lag(infections, default = first(infections)),
    rolling_infections = roll_mean(infection_change, 7, align = "right", fill = NA),
    rolling_deaths = roll_mean(death_change, 7, align = "right", fill = NA),
    cases_per100k = (infection_change/total_pop) * 100000,
    rolling_case100k = roll_mean(cases_per100k, 7, align = "right", fill = NA),
    state = "D.C."
  ) %>%
  select(date, locality, fips, rolling_infections, rolling_deaths, cases_per100k, rolling_case100k)

##clean virginia data
virginia_data <- va %>%
  rename(date = `Report Date`, deaths = Deaths, infections = `Total Cases`, fips = FIPS, locality = Locality) %>%
  arrange(locality) %>%
  inner_join(population, by = "fips") %>%
  group_by(fips) %>%
  mutate(
    date = as.Date(date, "%m/%d/%Y"),
    death_change = deaths - lag(deaths, default = first(deaths)),
    infection_change = infections - lag(infections, default = first(infections)),
    rolling_infections = roll_mean(infection_change, 7, align = "right", fill = NA),
    rolling_deaths = roll_mean(death_change, 7, align = "right", fill = NA),
    cases_per100k = (infection_change/total_pop) * 100000,
    rolling_case100k = roll_mean(cases_per100k, 7, align = "right", fill = NA),
    state = "Virginia"
  ) %>%
  select(date, locality, fips, rolling_infections, rolling_deaths, cases_per100k, rolling_case100k)