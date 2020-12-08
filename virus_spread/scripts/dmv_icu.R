## Exploring ICU patient capacity across the DMV
## Script attempts to standardize data across each 
## Jurisdiction. Note: Data from Washington doesn't 
## begin until mid-May. Data must be adjusted accordingly. 

# dc hospitals 
dc_hospitals_parsed <- dc_hospitals %>% 
  separate(DATE_REPORTED, sep = " ", c("date", "x")) %>%
  mutate(date = as.Date(date,"%Y/%m/%d")) %>%
  select(date, TOTAL_COVID19_PATIS_DCHOS_HOS, TOTAL_COVID19_PATIENTS_ICU_HOS) %>%
  rename(total_patients = TOTAL_COVID19_PATIS_DCHOS_HOS, total_icu = TOTAL_COVID19_PATIENTS_ICU_HOS)

# va hospitals
va_hospitals_parsed <- va_hospitals %>%
  mutate(date = as.Date(`Date`, "%m/%d/%Y")) %>%
  rename(total_patients = `Total COVID-19 Patients`, total_icu = `ICU Patients`) %>%
  select(date, total_patients, total_icu) %>%
  arrange(date)
  
# md hospitals
md_hospitals_parsed <- md_hospitals %>%
  mutate(date = as.Date(DATE, "%Y/%m/%d")) %>%
  rename(total_patients = Total, total_icu = ICU) %>%
  select(date, total_patients, total_icu)

## bind data
bind_patients <- bind_rows(dc_hospitals_parsed, va_hospitals_parsed, md_hospitals_parsed) 

region_patients <- bind_patients %>% 
  group_by(date) %>%
  filter(date > as.Date("2020-05-20")) %>%
  summarise(
    total_patients = sum(total_patients),
    total_icu = sum(total_icu)
  ) %>%
  mutate(
    rolling_patients = roll_mean(total_patients, 7, align = "right", fill = NA),
    rolling_icu = roll_mean(total_icu, 7, align = "right", fill = NA)
  ) 
