#### Krusikal-Wallis test with Dunn's multiple comparison adjustment
# Non-parametric Anova

library(tidyverse)
library(rstatix)
library(ggbeeswarm)
library(ggpubr)

c_df <- read.csv("continuous_df.csv")

# order column values
c_df$protein <- factor(c_df$protein,
               levels = c("Ran", "RCC1", "Nup153", "TPR"))

# Calculate p values - family test (Kruskal-Wallis)
df_p <- c_df %>%
  ungroup() %>% 
  kruskal_test(mn_pn ~ protein) %>% # format for formula is test(y ~ x)
  add_significance()

df_p

# If x delineators are contained in multiple columns (such as after melting data) can use the following syntax:

df_p<- df_melt %>%
  kruskal_test(value ~ interaction(siRNA, series)) %>%
  add_significance()

df_p

# Calculate pairwise comparison p-values
# I'm not sure how to pick the best p.adjust.method. BH is most likely to give you statistical significance. 
# can also specify what comparisons you want to do. Template is in the chisquare template.

df_p_multi <- c_df %>%
  ungroup() %>%
  dunn_test(mn_pn ~ protein, p.adjust.method = "BH") %>% 
  add_xy_position(x = "protein")

df_p_multi

# for some reason interaction(var1, var2) is not working with dunn_test. Instead, can use unite(NewCol, c("var1", "var2")) to generate a column that can be used for test.

# add pairwise p-values to plot. Preloaded 95% median CI function from R code into environment prior to running ggplot.

plot_all <- c_df %>% 
  ggplot(aes(x = protein, y=mn_pn, color = protein)) +
  geom_beeswarm(show.legend = FALSE, alpha = 0.5, cex = 1)+
  stat_summary(fun.data = median_cl, size = 0.25, color = "black") +
  stat_pvalue_manual(df_p_multi, tip.length = 0) +
  theme_classic()

print(plot_all)
