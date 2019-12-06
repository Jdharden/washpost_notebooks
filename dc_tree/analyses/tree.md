---
title: "District Tree Removals"
output:
  html_document:
    df_print: paged
  word_document: default
data: '2019-12-02'
---

#### The following dataset is a breakdown of special tree permits and workorders in DC. Special Tree Permits illustrate how often private property owners in D.C. request to have trees removed throughout the city each fiscal year. Work orders on the other hand are city initiated removals in which the city removes trees because of health reasons and/or hazards. 

## Analyzing Special Tree Permits

```{r message=FALSE, warning=FALSE, paged.print=FALSE}

#loading the dataset | datasets accurate as of Dec 1 
library(tidyverse)
tree_permits_data <- read_csv("~/Desktop/Special_Tree_Permit (2).csv")
tree_removal_wo <- read_csv("~/Desktop/tree_removal_wo.csv")
```

```{r message=FALSE, warning=FALSE, paged.print=FALSE}

Status_filter <- c(tree_permits_data, 'Issued', 'Approved (Pending Payment)')

#pivoting the datasets
trees_removed <- select(tree_permits_data, FiscalYear, Status, NeighborhoodNames, TotalTreeCount) %>%
  group_by(FiscalYear) %>% # NeighborhoodNames removed
  filter(Status %in% c('Issued', 'Approved (Pending Payment)'), FiscalYear < 2020) %>%
  summarise(
    total_tree = sum(TotalTreeCount)
  )

# Ward breakdown fiscal year FY 2012 through FY 2020 (Dec 3)
trees_rm_neighborhood <- select(tree_permits_data, Ward, FiscalYear, Status, NeighborhoodNames, TotalTreeCount, TreeFundAmount) %>%
  filter(Status %in% c('Issued', 'Approved (Pending Payment)')) %>%
  group_by(Ward) %>% 
  summarise(
    total_tree = sum(TotalTreeCount),
    fund_amount = sum(TreeFundAmount)
  ) #Looking at tree removal by ward 

```


#### The following breakdown shows how many trees have been removed by ward by special tree permits. It also shows how much (In real dollars) property owners paid toward the tree fund to have trees removed. 


```{r}

top_neighborhoods <- arrange(trees_rm_neighborhood, desc(total_tree)) # sorting tree removal 

top_neighborhoods

```
