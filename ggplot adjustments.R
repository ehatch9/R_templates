# ggplot commands
library(tidyverse)
library(ggprism)
library(ggpubr)

#set color scheme
colors <- c("Lamina gap" = "magenta", "MN" = "black")

plot1 <- ggplot(df_filt, aes(x = time)) +
  geom_point(aes(y = gap_fold, color = "MN"), size = 0.2) +
  geom_smooth(aes(y = gap_fold, color = "MN"), linewidth=0.5, alpha = 0.25) +
  scale_y_continuous(breaks = seq(0, 3, 0.5), guide = guide_prism_minor(), expand = c(0, 0)) + #  breaks = axis major ticks, min, max, major tick distance, guide = add minor ticks halfway, expand = start y axis at 0
  geom_hline(yintercept= 1, linetype="dashed") +
  coord_cartesian(xlim = c(0,425)) + # good for geom_point plots with models
  scale_x_continuous(expand = c(0,0), guide = guide_prism_minor()) + #guide = add minor ticks halfway, expand = start x axis at 0
  scale_x_discrete(limits = c("D", "A", "B"), breaks=c("A","B","D"), labels=c("Dose 0.5", "Dose 1", "Dose 2")) + #limits changes order of plot, breaks tells which ones to display, labels changes the labels of the categories
  scale_x_discrete(labels = str_wrap(c("CTRL Nup153", "CTDNEP1 Nup153", "CTRL Nup133", "CTDNEP1 Nup133"), width = 10)) + # can wrap label text using library(stringr) and function str_wrap. Should be able to wrap labels automatically using scale_x_discrete(labels = function(x) str_wrap(x, width = 10)), but I couldn't get it to work.
  labs(title = "", # set title text
       x = "Time (m)", # set x axis label
       y = bquote('MN area ('*mu*'m'^{2}*')'), # set y axis label with symbol
       color = "",# set legend title
       tag = "A") + # add subfigure title
  #scale_color_manual(values = colors) + # Use to add colors from list
  scale_color_brewer(palette = "Dark2") + # use color brewer palette for color
  theme_classic(base_size = 6, 
                base_color = "black", 
                base_family = "sans") + # should eliminate some text from theme, but haven't tested.
  guides(color= guide_legend(override.aes=list(fill=NA))) + # eliminates SEM background.
  facet_wrap(~object_number) + # facets plots
  annotate("text", x = 12, y = 0.9, label = "GLM model RCC1 ~ volume = *", size = 2) +
  theme(plot.title = element_text(size = 7, vjust = -5, hjust = 0.5, color = "black", family = "sans"),
    axis.text.x = element_text(size=7, color = "black", family = "sans", angle = 45),
        axis.text.y = element_text(size=7, color = "black", family = "sans"),
        text = element_text(size = 7, color = "black", family="sans"),
        axis.ticks= element_line(color = "black"), 
        legend.background = element_rect(fill = NA, color = "black"), # transparent under text, outline with black box 
        legend.text=element_text(size=6), # set font size of legend labels
        legend.position = c(0.75, 0.88), # set legend position in relation to graph (0-1)
        legend.title=element_text(size=6), # set font size of legend title
        legend.key.size = unit(0.5, "cm"), # set size of legend
        strip.text.x = element_text(size = 5, margin = margin(2,0,2,0, "cm"))) # set size of facet strip

ggsave("MN area vs lamina gap area.png", plot = plot1, units = "in", width = 2, height= 2, dpi=600)

library(patchwork)
patched <- MN_5 + PN_5 + plot_3 + plot_4 + 
  plot_layout(ncol = 4) +
  plot_annotation(tag_levels = list(c("A", "", "B", ""))) & 
  theme(plot.tag = element_text(size = 7, hjust = 0, vjust = 0, face = "bold"), 
        plot.tag.position = c(-0.065, 0.9))


library(see)
scale_color_oi(order = c(1, 2, 3, 7, 9))

# chr 1 = 2, chr 18 = 7, chr 19 = 9, chr 17 = 1