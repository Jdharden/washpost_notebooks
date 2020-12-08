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

The neighborhoods of Congress Heights, Bellevue and Washington Highlands have tallied the most incidents of gunshots in the district from 2017 to Sept. 2019, based on ShotSpotter data. More than 3,565 bullet casings were recovered in the police districts that overlap those neighborhoods. 

```{r}
nbh_counts <- shotspotter_data %>%
  group_by(nbh_names) %>%
  count(nbh_names) %>%
  filter(n > 500) %>%
  arrange(n)

nbh_counts 

```


```{r}

#shots by neighborhood cluster 
ggplot(nbh_counts, aes(x = reorder(nbh_names, n), y = n, fill = nbh_names)) +
  geom_col() +
  ggtitle("Shooting Incidents by Neighborhoods") +
  theme(axis.text.x = element_text(angle=5, vjust= 1, size = 4.5),
        legend.position = "top",
        legend.text = element_text(
          size = 5),
        legend.title = element_text(
          size = 0
        )) +
  scale_fill_brewer( palette = "Pastel1") #shows total number of shots 2017_sept2019

```


```{r}
#shooting incidents by date and neighborhood
shots_by_day <- shotspotter_data %>%
  group_by(date, nbh_names) %>%
  count(date) %>%
  filter(n > 2) %>%
  filter(nbh_names %in% c("Congress Heights, Bellevue, Washington Highlands",
                          "Douglas, Shipley Terrace", "Capitol View, Marshall Heights, Benning Heights",
                          "Deanwood, Burrville, Grant Park, Lincoln Heights, Fairmont Heights"
                          ))

shots_by_day

```
Data obtained and analyzed by the Washington Post reveals the neighborhoods of Congress Heights, Bellevue and Washington Highlands have tallied the most incidents of gunshots in the district from 2017 to Sept. 2019, based on ShotSpotter data. 
That area in Ward 8 has recorded nearly 2,500 incidents since 2017 – often going less than a day (an average of .41 days) without hearing a gunshot. 

#### Following chart shows frequency of gunshots.

```{r, fig.width = 20, fig.height = 5}
ggplot(shots_by_day, aes(date)) +
  geom_freqpoly(mapping = aes(color = nbh_names), binwidth = 20) + 
  facet_wrap(nbh_names ~ .) + 
  theme(
    strip.text = element_text(size = rel(.5))
  )

```
```{r}
#avg no. of days without gunshots 
days_since <- shotspotter_data %>%
  arrange(date, nbh_names) %>%
  group_by(nbh_names) %>%
  mutate(no_of_days = c(0,diff(date))) %>%
  summarise(
    avg_days = mean(no_of_days)
  ) %>%
filter(avg_days < 2, avg_days > 0)

days_order <- arrange(days_since, desc(avg_days))

days_order

```

```{r}
avg_days <- ggplot(days_order, aes(x = reorder(nbh_names, avg_days), y = avg_days)) +
  geom_col() +
  ggtitle("Avg. days without recording a gunshot") +
  theme(axis.text.x = element_text(angle=20, size = 4))  # showing days frequency of recorded gunshots by the District's shotsspotter system

avg_days
```

#### MPD warns that sensor technology isn’t perfect and may include duplicate incidents or unverified shots. Data is classified and assessed by ShotSpotter personnel. An incident may involve one gunshot or multiple gunshots depending on the time elapsed between each shot. Lastly, the data does not provide coverage for the entire District -- only targeting high population density areas with frequent sounds of gunshots incidents.
