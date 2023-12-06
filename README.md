# R_templates
Repository for template and function codes for R graphing in tidyverse.

The main statistical packages I use are:
rstatix
Barnard
VISCfunctions

For adding statistics to plots in ggplot I use the following packages: 
ggpubr
ggprism

### Equation for Median CI
This function can be used in conjunction with the stat_summary function in ggplot2 to add the 95% confidence interval of the median to a graph. 95% CI is one of the best visual summaries of significance between a small number of categories. The 95% CI of the median is often asymmetric and a better visual representation than 95% CI of the mean of what a non-parametric test (e.g. KW or Mann-Whitney/Wilcoxon) is assessing. Therefore I almost always use it since our data is almost always non-gaussian. 

### KW non parametric anova plus dunns template - for comparing medians between multiple populations
Use this template to calculate and add p-values to graphs of 3 or more continuous data samples that do not fit a Gaussian distribution. KW is the "family test". If this is non-significant, do not run any more tests. If this is significant, you can identify which pairwise comparisons are contributing to the significance by performing Dunn's test.

This is one of several tests that I use through the rstatix package. It has a couple nice features. "add_significance()" adds the ns, *** etc. symbols to your p-value table. "add_x_y_position()" makes it easy to plot pairwise statistics through ggplot and ggpubr libraries. "stat_pvalue_manual()" function is from the ggpubr package.

### Mann-Whitney non parametric two sample test (aka Wilcoxon test) - to compare medians of two non-parametric samples
*Sample size must be at least 6. Same idea as KW test, but for two categories.

### Chisquare then Barnards template.
Use this to analyze categorical data with more than 2 conditions. There are definitely easier ways to do the chisquare test but this data wrangling path facilitates using the Barnard's multiple pairwise comparison package from VISC (Fred Hutch) as a post test. Uses an example dataframe with cases of NOTRUP and RUP nuclei for 4 conditions. In this template the data starts as counts and is converted to cases via an rstatix function. 

This template assumes that the chi-square family test is significant. It goes over how to perform Barnard's pairwise comparisons between all groups, filter the data table to include only desired comparisons, then perform a post-test (B-H adjustment) to get the adjusted p-value. This works well when you have a small number of groups to compare. If you want to compare a large number of groups to a single value, e.g. control, better to use Amanda's barnard's template (included in the "barnards_test_template" document).

### Barnards_test_template
This document presents multiple approaches to performing pairwise comparisons between nominal data (2-category data). We use this a ton instead of Fisher's exact test because it is more powerful than Fisher's for low n data, which describes most of our experiments.

Approach 1: Amanda's approach of adding a control observation to each row and performing barnard's as a row-wise function. For this test the input is a dataframe of counts.

Approach 2: Compare all samples to each other. Filter to include only desired comparisons, then perform a post-test to get the adjusted p-value. For this test the input is a dataframe of cases transformed into two vectors. This section is a copy of the second part of "Chisquare then Barnards template."

### Barnards on 2 condition categorical data
Input is the categorical data .csv limited to two samples - control ("DMSO") and treatment ("B8"). Employs the Barnard package to perform statistics and has a template for adding statistics to graph using ggplot and the ggpubr package command "stat_pvalue_manual".

### Non-linear regression analysis
Explanation and template coming soon. Used for analyzing one phase association curves.

### ggplot adjustmants
A running list of all the commands in ggplot I have found useful for making graphs for grants with short explanations of what they do. It's pretty cluttered. Not sure how to improve it. 


