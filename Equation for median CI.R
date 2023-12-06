# Median 95% CI function. https://stackoverflow.com/questions/62444003/calculation-of-confidence-intervals-of-the-median-in-ggplot

#Run the following 2 code blocks in any window prior to running ggplot to add the functions to your environment.

quantile_cl <- function(y, q=0.5, conf.level = 0.95, na.rm=TRUE) {
  alpha <- 1 - conf.level
  if (na.rm) y <- y[!is.na(y)]
  n <- length(y)
  l <- qbinom(alpha/2, size=n, prob = q)
  u <- 1 + n - l
  ys <- sort.int(c(-Inf, y, Inf), partial = c(1 + l, 1 + u))
  data.frame(
    y = quantile(y, probs = q, na.rm=na.rm, type = 8),
    ymin = ys[1 + l],
    ymax = ys[1 + u]
  )
}

median_cl <- function(y, conf.level=0.95, na.rm=TRUE) quantile_cl(y, q=0.5, conf.level=conf.level, na.rm=na.rm) # generates a function that calculates with the 95% CI non parametric and the median 

# Can use this function with stat_summary to plot 95% CI of median and median on a ggplot. Example:
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_violin(aes(fill = Species), trim = FALSE) +
  stat_summary(fun.data = median_cl, size = 0.25, color = "black")


