#### Krusikal-Wallis test with Dunn's multiple comparison adjustment

# reorder column values
df$x <- factor(df$x,
               levels = c("18", "TSA18", "19", "methyl19"))

# Calculate p values - family test (Kruskal-Wallis)
df_p <- df %>%
  ungroup() %>% 
  kruskal_test(y ~ x) %>% 
  add_significance()

df_p

# Calculate pairwise comparison p-values
df_p_multi <- df %>%
  ungroup() %>%
  dunn_test(y ~ x, p.adjust.method = "BH") %>%
  add_xy_position(x = "x")

df_p_multi