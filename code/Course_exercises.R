# sourse some packages and functions --------------------------------------

# you can use Ctr+Shift+R to insert new code section - these show up in the toc
#you can source several packages and functions, listed in one file
source("code/packages_and_functions.R")







# plotting with ggplot ----------------------------------------------------

#a simple plot from the iris dataset (part of base R)

iris %>%  #we use a pipe to input the data to ggplot
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +  #we use + to add different elements of the plot
  geom_point(aes(shape=Species)) +
  scale_shape_manual(values=c(3,18,22))+
  scale_size_manual(values=c(1,2,3))+
  geom_smooth() +
  theme_minimal()

#another plot
ggplot(data=diamonds, mapping=aes(x = carat, y = price, color = cut))+
  geom_point()

#a histogram
ggplot(data=diamonds) + 
  geom_histogram(aes(x=carat), binwidth=0.1) +
  geom_freqpoly(mapping=aes(x=carat, color=cut), binwidth=0.1)

#change the theme of the plot
iris %>%  
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_boxplot(notch = TRUE) +
  theme_minimal()


# faceting ----------------------------------------------------------------
#Facetting by species
iris %>%  
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  theme_minimal() +
  facet_wrap(vars(Species))

#Download dataset later
ggplot(datasets:airquality)+
  aes(x=Month,y=Ozone,colour=Day)+
  geom_point(shape="circle filled",
  size=1.5)+
  scale_color_gradient()

#install.packages("esquisse")
#try the Esquisse 'ggplot2 builder' add-on
library(esquisse)
#View port was weirdly shaped, use browser version if this occurs
esquisse::esquisser(iris, viewer = "browser")
esquisser()
# modify legends ----------------------------------------------------------

#another plot - changing the legends
#iris_plot <- would put the plot into the environment
iris %>%  
  ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  theme_minimal() +
  facet_wrap(vars(Species)) +
  labs(x = "x axis label", y = "y axis label") +
  theme_minimal() +
  theme(legend.position = "top")

#saving a plot
#if multiple functions with the same name we could do
#ggplot2:: ggsave(...)
ggsave("pictures/iris_test.png", bg = "white",width = 5000, height = 5000, units="px")


#Removing/Omiting NAs from Plot

airquality %>% 
  drop_na(Ozone) %>%
  ggplot(aes(x = Ozone))+
  geom_bar(stat="bin")
#Imputation Of NAs - example
ggplot(data = MyData,aes(x= the_variable, fill=the_variable, na.rm = TRUE)) + 
  geom_bar(stat="bin", na.rm = TRUE)

# Tibbles - tidy your data ------------------------------------------------

vignette("tibble")

#A simple tibble
  
tb <- tibble(variable_1 = c(1,2,3,4,5,6), 
             variable_2 = c(2,3,4,5,6,7),
             variable_3 =  c("a", "a", "a", "b", "b", "c"))
tb %>%
  ggplot(aes(x = variable_1, y = variable_2, color = variable_3)) +
  geom_point()

#A more realistic example - 1
  
tb <- tibble(genotype = c("wt","wt","wt","mut","mut","mut"), 
             eye_color = c("red", "red", "red", "white", "white", "white"),
             eye_size =  c(35, 39, 33, 12, 14, 11))
tb
tb %>%
  ggplot(aes(x = genotype, y = eye_size, color = eye_color)) +
  geom_point()

#A more realistic example - 2

tb <- tibble(inhibitor = c("DMSO","DMSO","DMSO","drug1","drug1","drug1","drug1","drug1","drug1"), 
             activity = c(32,34,23,67,65,57, 56,64,62),
             replicate =  c("rep1", "rep1", "rep1", "rep1", "rep1", "rep1", "rep2", "rep2", "rep2"))
tb
tb %>%
  ggplot(aes(x = inhibitor, y = activity, color = replicate)) +
  geom_point()


# Example dataset from from Barnali ---------------------------------------

Syn_data <- read_csv("data/a-Syn-Data.csv")
Syn_data
#manual changes for bec
colnames(Syn_data) <- c("Time", "aSyn...2", "aSyn...3", "aSyn...4", "aSyn-DMSO...5" ,"aSyn-DMSO...6" ,"aSyn-DMSO...7", "aSyn_D2_13uM...8","aSyn_D2_13uM...9","aSyn_D2_13uM...10",   "aSyn_D3_0.67mM...11", "aSyn_D3_0.67mM...12", "aSyn_D3_0.67mM...13")
colnames(Syn_data)
#Need to do some tidying...

#use piping %>% and pivot_longer to convert into long form
Syn_tb <- Syn_data %>%
  rename_with(~ gsub("_", "-", .x, fixed = TRUE)) %>%
  rename_with(~ gsub("...", "_", .x, fixed = TRUE)) %>%
  pivot_longer(matches("aSyn"), 
               names_to = c("condition", "sample"), names_sep = "_",
               values_to = "fluorescence") %>%
  group_by(condition)

Syn_tb
#Let's plot the tidied tibble

Syn_tb %>%
  ggplot(aes(x = Time, y = fluorescence, color = condition)) +
  geom_smooth() +
  theme_minimal()

ggsave("pictures/synuclein_data.png", bg = "white")


# Example data from Kei ---------------------------------------------------

Ca <- read_csv("data/WTvsNOS11_cPRC_INNOS.csv")
Ca
#Example data from Kei - first let's rename some variables 
(Ca <- Ca %>% 
    rename(genotype = phenotype, intensity = intesnsity)
)

#Example data from Kei
Ca %>% 
  ggplot(aes(x = frame, y = intensity, color = genotype, 
             group = genotype)) +
  geom_smooth(level = 0.99, size = 0.5, span = 0.1, method = "loess") +
  geom_line(aes(group = sample), size =  0.5, alpha = 0.25) +
  theme_dark() +
  facet_wrap(vars(cell))
#Aes group used as without it would model it as a distribution/continuous 

ggsave("pictures/Kei_NOS_data.png", bg = "white")


# Example data from Tom ---------------------------------------------------

#Example data from Tom - not raw data
filo <- read_csv("data/Tom_filopodia_analyses.csv")
filo

#Example data from Tom - raw data

filo_raw <- read_csv("data/spine activity_raw.csv")
filo_raw

#Example data from Tom - let's tidy it up
filo_raw_tb_int <- filo_raw %>%
  rename_with(~ gsub("SR_R", "SR-R", .x, fixed = TRUE)) %>%
  rename_with(~ gsub("_Area!!", "-Area!!", .x, fixed = TRUE)) %>%
  rename_with(~ gsub("Time::Relative Time!!R", "time", .x, fixed = TRUE)) %>%
  rename_with(~ gsub("_IntensityMean!!", "-IntensityMean!!", .x, fixed = TRUE)) %>%
  pivot_longer(matches("Channel"), 
               names_to = c("channel", "region", "measurement"), 
               names_sep = "_|::",
               values_to = "value") %>%
  filter(measurement == 'IntensityMean')
filo_raw_tb_int

#Let's plot the tidied tibble

filo_raw_tb_int %>%
  ggplot(aes(x = time, y = value, color = region)) +
  geom_line(aes(group = region)) +
  theme_minimal()

ggsave("pictures/Tom_filo_data.png", bg = "white")

#methods for smooth curves DRM (dose response model from drc package)
# Creating a new section --------------------------------------------------

#CTRL + SHIFT + R to insert a line break to create a new section, adding to the table of contents for the r file

# Assemble multi-panel figures with cowplot and patchwork -----------------

### read the images with readPNG from pictures/ folder


#install.packages("magick")
library(magick)
img1 <- readPNG("pictures/Platynereis_SEM_inverted_nolabel.png")
img2 <- readPNG("pictures/synuclein_data.png")
img3 <- readPNG("pictures/Kei_NOS_data.png")
img4 <- readPNG("pictures/Tom_filo_data.png")
img5 <- readPNG("pictures/MC3cover-200um.png")

### convert to image panel and add text labels with cowplot::draw_image and draw_label

panelA <- cowplot::ggdraw() + cowplot::draw_image(img1, scale = 1) + 
  draw_label("Platynereis larva", x = 0.35, y = 0.99, fontfamily = "sans", fontface = "plain",
             color = "black", size = 11, angle = 0, lineheight = 0.9, alpha = 1) +
  draw_label(expression(paste("50 ", mu, "m")), x = 0.27, y = 0.05, fontfamily = "sans", fontface = "plain",
             color = "black", size = 10, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("head", x = 0.5, y = 0.85, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("sg0", x = 0.52, y = 0.67, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1)
panelA
#Make panels B-D
panelB <- ggdraw() + draw_image(img2)
panelC <- ggdraw() + draw_image(img3)
panelD <- ggdraw() + draw_image(img4)
panelB
panelC
panelD
    

# Adding scale bars -------------------------------------------------------

panelE <- ggdraw() + draw_image(img5, scale = 1) + 
  draw_line(x = c(0.1, 0.3), y = c(0.07, 0.07), color = "black", size = 0.5)
panelE


# Assemble figure with patchwork ------------------------------------------

# First, we define the layout with textual representation (cool and intuitive!)

layout <- "ABCDE"

#define figure panels, layout, annotations and theme
Figure1 <- panelA + panelB + panelC + panelD + panelE +
  patchwork::plot_layout(design = layout, heights = c(1, 1)) +
  patchwork::plot_annotation(tag_levels = "A") &
  ggplot2::theme(plot.tag = element_text(size = 12, face='plain'))

#save figure as png (pdf also works)
ggsave("figures/Figure1.png", limitsize = FALSE, 
       units = c("px"), Figure1, width = 4000, height = 800, bg = "white")

getwd()
#Change the layout of the panels
  
# Change the textual layout definition
# We also need to change the dimensions of the exported figure
#Cool Layout options
#cowplot arrows
layout <- 
  "CCCCBBBB
   CCCCBBBB
   ##AAAAEE
   ##AAAAEE
   DDAAAAEE
   DDAAAAEE"
Figure1 <- panelA + panelB + panelC + panelD + panelE +
  patchwork::plot_layout(design = layout, widths = c(1,1), heights = c(1, 1)) +
  patchwork::plot_annotation(tag_levels = "a") &
  ggplot2::theme(plot.tag = element_text(size = 12, face='bold'))
#can use external image editing software like fiji or gimp
ggsave("figures/Figure1_layout2.png", limitsize = FALSE, 
       units = c("px"), Figure1, width = 5000, height = 3200, bg = "white")

