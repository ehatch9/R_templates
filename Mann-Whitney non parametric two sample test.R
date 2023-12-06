### Wilcoxon/Mann-Whitney test for differences between 2 medians in non-parametric tests
# I prefer this over the K-S non-parametric test because K-S assess differences between medians or distribution - more likely to give you "significance" but often not clear that a change in distribution is biologically significant. Sometimes it is. Depends on your question. 

library(tidyverse)
library(rstatix)
library(ggbeeswarm)
library(ggpubr)

# Import values and filter to two groups
c_df <- read.csv("continuous_df.csv") %>%
  filter(protein %in% c("Ran", "RCC1"))

# order column values
c_df$protein <- factor(c_df$protein,
                       levels = c("Ran", "RCC1"))

df_p <- c_df %>%
  ungroup() %>% 
  wilcox_test(mn_pn ~ protein) %>% # format for formula is test(y ~ x)
  add_significance() %>%
  add_xy_position()

df_p

# Add p values to ggplot

plot_all <- c_df %>% 
  ggplot(aes(x = protein, y=mn_pn, color = protein)) +
  geom_beeswarm(show.legend = FALSE, alpha = 0.5, cex = 1)+
  stat_summary(fun.data = median_cl, size = 0.25, color = "black") +
  stat_pvalue_manual(df_p, tip.length = 0) +
  theme_classic()

print(plot_all)

# If the x value is the combination of 2 columns, need to make a new column uniting the variables prior to using this equation: unite(NewCol, c("var1", "var2"))
