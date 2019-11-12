----
title: "hubzone algorithm analysis"
author: "John D. Harden"
date: "8/27/2019"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)

library(tidyverse)
library(readr)
library(rvest)
library(htmlTreeParse)
library(RCurl)
library(XML)
library(modelr)
library(tinytex)
library(rmarkdown)

```

## HUBZone DC college student analysis

Summary: Data obtained from https://www.fpds.gov and https://www.usaspending.gov was used to analyze HUBZone contracts awarded to firms in Washington, DC. Data shows that more than $1 billion in federal dollars was awarded since 2000. # However, many of those dollars were awarded to firms in areas considered economically stable. The point of the HUBZone program was to level the playing field between firms in economically stable communities and businesses in areas that are historically neglected. 
----
load data parsed for federal database
----
```{r load data}

#dc poverty rate
us_analysis <- read_csv("~/us_qualified.csv",
                        na = "NA")
options(stringsAsFactors = FALSE)

us_analysis_tibble <- as_tibble(us_qualified_13_19)

```
----
filter businesses by qct eligibility and gather by years. identifying tracts that have not qualified since 
2013 but have managed to stay in the program and continue benefiting from lucrative contracts. 
----
```{r pressure, echo=FALSE}

filter_qualified_4_yr <- filter(us_analysis_tibble, 
                                 `13qct`== 0, `14qct` == 0, `15qct` == 0, 
                                 `17qct` == 0, `18qct` == 0, `19qct` == 0) %>%
  select(state, `2016`, `2017`, `2018`, `2019`) %>% 
  gather (`2016`, `2017`, `2018`, `2019`, key = four_year_total, value = "dollars")  %>%
  group_by(state) %>%
  summarize(
    total = sum(dollars, na.rm = TRUE)
  )

```
----
filtering and sorting states by the top 15  
----
```{r result, echo=FALSE}

top_15_states <- head(filter_qualified_4_yr, 15)

```
