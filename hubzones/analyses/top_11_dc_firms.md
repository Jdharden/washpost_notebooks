# John D. Harden / Kate Rabinowitz
# Washington Post Data
# Dec 2018 

## Federal HUBZone Program Analysis

library (tidyverse)
library (reshape)
library(knitr)
library(rmarkdown)
library(lubridate)

#####################################################################################################################################
# Summary: Data obtained from https://www.fpds.gov and https://www.usaspending.gov was used to analyze HUBZone contracts awarded to
# firms in Washington, DC. Data shows that more than $1 billion in federal dollars was awarded since 2000. However, many of those
# dollars were awarded to firms in areas considered economically stable. 

# The point of the HUBZone program was to level the playing field between firms in economically stable communities and businesses
# in areas that are historically neglected. 

#####################################################################################################################################

# load data parsed for federal database

# //////////////////////////////////////////////////////////////////////////////
HUBZoneRaw <- read_csv("HUBZone_Raw.csv", 
                       col_types = cols(action_date = col_date(format = "%m/%d/%Y")))
                       options(stringsAsFactors = FALSE)
# //////////////////////////////////////////////////////////////////////////////

# addresses found in database was geocoded and assigned to their respective ward. 
# wards were grouped and dollars awarded were determined for each. 
# breakdown of dollars by ward (%)

ward_amount <- group_by(HUBZoneRaw, WARD) %>%
  summarise(total_contracts = sum(federal_action_obligation )) %>%
  arrange(desc(total_contracts))

ward.percent <- ward_amount$total_contracts / sum(ward_amount$total_contracts)

# //////////////////////////////////////////////////////////////////////////////

# breakdown of dollars by year 
HUBZoneRaw$HUB_Year <- format(as.Date(HUBZoneRaw$action_date), "%Y")     

# to analyze which firms were getting the most federal dollars we grouped firms
# by parent duns and summarized the countracts.  

firms_total <- group_by(HUBZoneRaw, recipient_parent_duns) %>%
  summarise(total_contracts = sum(federal_action_obligation)) %>%
  arrange(desc(total_contracts))

# firms were sorted; pulling the top 11 businesses 

top11 <- head(firms_total, 11)

# we discovered that the top 11 firms out of more than 200 were awarded more 
# than 70 percent of the federal dollars awarded. 

# //////////////////////////////////////////////////////////////////////////////

sum(top11$total_contracts) / sum(firms_total$total_contracts)

firms_2018 <- group_by(HUBZoneRaw, HUB_Year) %>%
  filter(HUB_Year == 2018) %>%
  summarise(fy2018_contracts = sum(federal_action_obligation))
# //////////////////////////////////////////////////////////////////////////////
