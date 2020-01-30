# Findings 

Data obtained and analyzed by the Washington Post reveals the neighborhoods of Congress Heights, Bellevue and Washington Highlands have tallied the most incidents of gunshots in the district from 2017 to Sept. 2019, based on ShotSpotter data. 

That area in Ward 8 has recorded nearly 2,500 incidents since 2017 – often going less than a day (an average of .41 days) without hearing a gunshot and often going months at a time with hearing gunshots each day. The neighborhoods of Douglas and Shipley Terrace fall to second with just over 1,250 gunshot incidents within the same timeframe.   

*More than 3,565 bullet casings were recovered in the police districts that overlap the Congress Heights, Bellevue and Washington Highlands area. That's a little more than 16 percent of all casings recovered in the last two years. 

The data coincides with additional data collected by the Post and the level of violence that those areas have seen in recent years. The Congress Heights area has led the District in homicides since 2015 through Dec. 12 more than 101 people have been killed in the area since then. This is an area that includes seven public schools. 

Eighty-one of those deaths were gun related. And additionally, gun seizure data obtained by the Post shows that ~720 guns (or 15 percent of guns districtwide) have been seized in those areas between 2016 through Aug 2018.


## Loading data and parsing

Shapefiles created and exported from QGIS. Boundaries were collected from DC OPEN DATA. Grid shapefiles were created by the Washington Post, using QGIS. 
```{r include=FALSE}
library(tidyverse)
library(lubridate)
library(rgdal)
library(broom)
library(RColorBrewer)
library(maps)
library(sf)

shotspotter_data <- read_csv("~/Desktop/shotspotter/shotspotter_database.csv") #import data
dc <- st_read("~/Desktop/shotspotter/r_shotspotter_.geojson")  #grid layout
dc_river <- st_read("~/Desktop/Data Repo/Commonly Used Shapefiles/Waterbodies/Waterbodies.shp")
dc_ward <- st_read("~/Desktop/shotspotter/dc_ward.geojson")


```

### Results
A breakdown of the ShotSpotter Incidents by neighborhood
```{r}
#count types of shooting incidents from ShotsSpotter 
nbh_counts <- shotspotter_data %>%
  group_by(nbh_names) %>%
  count(nbh_names) %>%
  filter(n > 500) %>%
  arrange(n)

nbh_counts 

```

Map package reveals that one area of the District, in Southeast, has a higher concentration of gunshots, based on ShotSpotter locations.  

```{r}
#mapping heatmap

ggplot() +
  geom_sf(data = dc_ward, aes()) +
  geom_sf(data = dc, aes(fill = shots_n)) +
  geom_sf(data = dc_river, aes()) +
  theme_void ()

```
