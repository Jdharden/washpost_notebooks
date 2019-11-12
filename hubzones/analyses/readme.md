----
# HUBZone Algorithm Analysis

  In 2018, the Washington Post requested information from the Small Business Administration, regarding its HUBZone Program. The Post asked for data related to contracts awarded to HUBZone firms using the HUBZone set aside. 

The SBA told the Post it did not have the capabilities to map and analyze the data, so we did it for them, beginning with Washington D.C. [The Post mapped where more than $1 billion in contracts were funneled](https://www.washingtonpost.com/local/a-federal-program-was-established-to-help-disadvantaged-areas-thats-not-where-most-of-the-money-goes/2019/04/25/c0bae5c2-f411-11e8-80d0-f7e1948d55f4_story.html?wpisrc=nl_lclheads&wpmm=1).
  
  In the months that followed, I decided to expand that across the nation. So I mapped where the more than $33 billion in  HUBZone-related set-asides landed across the nation. 

----

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

# HUBZone National Analysis

Summary: Data obtained from https://www.fpds.gov and https://www.usaspending.gov was used to analyze HUBZone contracts awarded to firms in Washington, DC. Data shows that more than $1 billion in federal dollars was awarded since 2000. 

However, many of those dollars were awarded to firms in areas considered economically stable. 

The point of the HUBZone program was to level the playing field between firms in economically stable communities and businesses in areas that are historically neglected. 

----

load data parsed from federal database
```{r load data}

us_analysis <- read_csv("~/us_qualified.csv",
                        na = "NA")
options(stringsAsFactors = FALSE)

us_analysis_tibble <- as_tibble(us_qualified_13_19)

```
----
Filtering businesses by qualified census tract eligibility, gathered by years. We are identifying tracts that have not qualified since 2013 but have managed to stay in the program and continue benefiting from lucrative contracts since 2016.

Tracts that have not qualified since 2013, indicated that these areas have income levels and poverty rates below the required benchmarks to benefit from the HUBZone program. 

```{r filter, echo=FALSE}

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
Futhermore, we can filter and sort states by the top 15 -- revealing which states in the U.S. have tracts in which HUBZone benefits have flowed into wealthy neighborhoods, rather than the communities it was intended to help. 

```{r result, echo=FALSE}

top_15_states <- head(filter_qualified_4_yr, 15)
```


----
Graphing the 2016-2019 data to highlight which states have the highest level of contracts awarded to wealthy Census tracts

```
ggplot(top_15_states , aes(x = total, y = reorder(state, total))) +
    geom_point() +
    theme(
      panel.grid.major.x = element_blank (), 
      panel.grid.minor.x = element_blank (),
      panel.grid.major.y = element_line ( colour = "grey60" ,
    linetype = "dashed")
    )
```
<img alt="HUBZone Top Firms" height="524" src="https://github.com/Jdharden/washpost-hubzone_wp/raw/master/dc_grid/hubzone.png?raw=true" width="640" />
