### Wilcoxon/Mann-Whitney test for differences between medians only in non-parametric tests.
# Can use K-S test for differeneces between medians or distribution - more sensitive.

library(rstatix)

# Calculate pairwise p values 
df$treat <- factor(df$treat, levels = c("DMSO_chr18", "TSA_chr18", "DMSO_chr19", "methyl_chr19")) #Set order prior to running test to add appropriate x positions

df_p <- df %>% 
  wilcox_test(y ~ x) %>% 
  add_significance() %>%
  add_xy_position(x = "x")

df_p

# Add p values to ggplot

p + 
  stat_pvalue_manual(df_p, tip.length = 0)