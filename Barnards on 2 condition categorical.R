# Barnard's test on categorical data with only two conditions being tested, no multiple comparisons.

library(Barnard)
library(tidyverse)
library(ggpubr)

# Import data and add column with intact proportion and n values
cat_df_2 <- read.csv("cat_df.csv") %>%
  filter(Condition %in% c("DMSO", "B8")) %>%
  mutate(proportion_intact = NOTRUP/(NOTRUP +RUP), n = NOTRUP + RUP)

# Set one set of variables as the "control" values and save these numbers as values

DMSO_df <- cat_df_2 %>%
  filter(Condition == "DMSO")

DMSO_i <- DMSO_df$NOTRUP
DMSO_r <- DMSO_df$RUP

# Calculate Barnard's (very slow!) and wrangle df for graphing.

stats_df <- cat_df_2 %>%
  rowwise() %>%
  mutate('p' = barnard.test(DMSO_i, NOTRUP, DMSO_r, RUP)$p.value[2]
  ) %>%
  add_significance() %>%
  filter(Condition != "DMSO") %>%
  mutate(group2 = "B8", group1 = "DMSO") %>%
  select(group1, group2, proportion_intact, n, p, p.signif) %>%
  mutate(y.position = 0.88)
  
stats_df

#Set sample order for graphing
cat_df_2$Condition <- factor(cat_df_2$Condition,
                      levels = c("DMSO", "B8"))

# Graph with ggplot2

plot <- cat_df_2 %>%
  ggplot(aes(x = Condition, y = proportion_intact)) +
  geom_bar(fill = "#0072B2", lwd = 0.25, stat = "identity") +
  ylab("Proportion intact MN") +
  xlab("") +
  stat_pvalue_manual(stats_df, label = "p.signif", y.position = "y.position", label.size = 3) +
  theme_classic() +
  theme(legend.position = "none")

plot
