---
title: "Barnard's test template"
author: "Emily Hatch"
date: "2023-08-22"
output: 
  html_document:
   keep_md: TRUE

---



#### Objective
Add the results of Barnard’s test to a dataframe in R

#### Pseudocode
load the necessary libraries
create a dataframe
identify the control values for comparison
use rowwise() and mutate() to create a column for the results
format to call the correct results barnard.test()$p.value[2]
Note that this will call the two-sided p-value, if you would like to switch to a 1-sided test you can change it to say barnard.test()$p.value[1]


```r
library(Barnard)
library(tidyverse)

categories <- data.frame(condition = c('DMSO', 'BLEB', 'B5', 'B6', 'B7_2uM', 'B8', 'D9', 'B7_500nM'), 
     NOTRUP = c(155, 155, 122, 163, 175, 211, 130, 168),
     RUP = c(55, 28, 38, 47, 46, 40, 58, 38))

ctrl <- categories %>% filter(grepl('DMSO', condition))

NEGctrl <- ctrl$NOTRUP
POSctrl <- ctrl$RUP

stats <- categories %>%
     rowwise() %>%
     mutate('p' = barnard.test(NEGctrl, NOTRUP, POSctrl, RUP)$p.value[2]
          ) %>%
     mutate('significant' = case_when(
          p <= 0.05 ~ '*'))
```

```
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          155
## Outcome II          55           55
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 0
## Nuisance parameter = 0 (One sided), 0.698 (Two sided)
## P-value = 0 (One sided), 1 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          155
## Outcome II          55           28
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 2.63838
## Nuisance parameter = 0.268 (One sided), 0.735 (Two sided)
## P-value = 0.00472697 (One sided), 0.00877259 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          122
## Outcome II          55           38
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 0.536122
## Nuisance parameter = 0.994 (One sided), 0.993 (Two sided)
## P-value = 0.324771 (One sided), 0.609624 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          163
## Outcome II          55           47
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 0.910334
## Nuisance parameter = 0.004 (One sided), 0.004 (Two sided)
## P-value = 0.264765 (One sided), 0.52953 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          175
## Outcome II          55           46
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 1.317
## Nuisance parameter = 0.992 (One sided), 0.993 (Two sided)
## P-value = 0.1142 (One sided), 0.225955 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          211
## Outcome II          55           40
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 2.7108
## Nuisance parameter = 0.812 (One sided), 0.238 (Two sided)
## P-value = 0.00387593 (One sided), 0.00708387 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          130
## Outcome II          55           58
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = -1.02946
## Nuisance parameter = 0.996 (One sided), 0.006 (Two sided)
## P-value = 0.242976 (One sided), 0.360819 (Two sided)
## 
## 
## Barnard's Unconditional Test
## 
##            Treatment I Treatment II
## Outcome I          155          168
## Outcome II          55           38
## 
## Null hypothesis: Treatments have no effect on the outcomes
## Score statistic = 1.89542
## Nuisance parameter = 0.019 (One sided), 0.073 (Two sided)
## P-value = 0.0322581 (One sided), 0.0591982 (Two sided)
```

I also added a column that automatically adds a star to data that is significant so you could add this to a graph easily using

geom_text(data = stats, aes(x = condition, y = 0.6, label = paste(significant)))

Note that for a large table this is going to take a good chunk of time to run, so you may need to be a bit patient.
