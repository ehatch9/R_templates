# Chi square template - hardest part is coercing dataframe to table

# Example dataframe is a dataset with treatments to be compared and counts listed in two columns - NOTRUP and RUP.

library(tidyverse)
library(rstatix)
library(ggpubr)
library(data.table)

install.packages("remotes")
remotes::install_github("FredHutch/VISCfunctions", build_vignettes = TRUE)
library(VISCfunctions)

# Import categorical data example
cat_df <- read.csv("cat_df.csv")

# Transform dataframe into a matrix
table_cat <- cat_df %>%
  column_to_rownames(var = "Condition") %>%
  as.matrix() %>%
  as.table()

#Add category names to rows and columns of matrix
condition <- rownames(table_cat)  
dimnames(table_cat) = list("Condition" = condition, "Rupture" = c("NOTRUP", "RUP"))

str(table_cat)

# Run chisquare (all vs all)
chisq.test(table_cat)

# Stop here if p-value > 0.05

# Convert contingency table to vectors of binary numbers for multiple pairwise comparison Barnard's test 
df_cases <- table_cat %>%
  counts_to_cases() %>%
  mutate(Rupture = case_match(Rupture, "NOTRUP" ~ 0, "RUP" ~ 1))

# Run multiple pairwise Barnard's test. This code converts data between df and matrices in a way I don't fully understand. 

df_B_pair_all <- df_cases %>%
  group_modify(~ as.data.frame(
    pairwise_test_bin(x = .$Rupture, group = .$Condition))) %>%
  add_significance(p.col = "ResponseTest", output.col = "p_value")

# Perform p-adjustment for multiple comparisons on selected columns (e.g. which conditions are different than DMSO?)

# Filter pairs to test and split into group1 and group2 columns
df_B_pair_adj <- df_B_pair_all %>%
  filter(Comparison %in% c("DMSO vs. D9", "DMSO vs. B8", "DMSO vs. B5")) %>%
  separate_wider_delim(cols = Comparison, delim = " vs. ", names = c("group1", "group2")) %>% 
  # run B-H comparison
  adjust_pvalue(p.col = "ResponseTest", output.col = "p.adjust", method = "BH") %>%
  add_significance(p.col = "p.adjust", output.col = "p.adjust.value") %>%
  # manually add y-values you want the significance bars to be at
  mutate(y.position = c(0.85, 0.9, 0.95)) 

# Plot (just the "pooled" values)
# Set factor levels
list <- unique(cat_df$Condition)
cat_df$Condition <- factor(cat_df$Condition,
                          levels = list)

# Add intact proportions to df
cat_df_prop <- cat_df %>%
  mutate(prop_intact = NOTRUP/(NOTRUP + RUP))

plot_all <- ggplot(cat_df_prop, aes(x = Condition, y = prop_intact)) +
  geom_bar(stat = "identity", fill = "#0072B2", color = "darkgray", lwd = 0.25) +
    add_pvalue(df_B_pair_adj, label = "p.adjust.value", y.position = "y.position", label.size = 3) +
    theme_classic()
plot_all

