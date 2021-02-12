##-----------------------------------------------##
##    Author: Adela Sobotkova                    ##
##    Institute of Culture and Society           ##
##    Aarhus University, Aarhus, Denmark         ##
##    adela@cas.au.dk                             ##
##-----------------------------------------------##

#### Goals ####

# - Learn about Classification methods

#### Required R libraries ####

# We will use the sf, raster, and tmap packages.
# Additionally, we will use the spData and spDataLarge packages that provide new datasets.
# These packages have been preloaded to the worker2 workspace.

library(sf)
library(raster)
library(tmap)
library(spData)
library(spDataLarge)

#### Data sets #### 

# We will use a single data set:  `nz`. It is contained by the libraries
# It is an sf object with polygons representing the 16 regions of New Zealand.

#### Existing code ####

# Here are some examples of plotting population in  New Zealand.
# Your role is to create a map based on the suggestions below, 
# selecting the most meaningful classification style.

# Look at NZ population distribution
hist(nz$Population)

# This line of code applies the 'pretty' style rounding legend numbers. Try different numbers of classes.
pretty <- tm_shape(nz) + tm_polygons(col = "Population", style = "pretty", n = 4) + 
  tm_layout(main.title = "Pretty Style", main.title.size = 1, legend.text.size = 0.5, legend.position = c("left", "top"))

# "Jenks" style further smooths over the gaps
jenks <- tm_shape(nz) + tm_polygons(col = "Population", style = "jenks", n = 5) + 
  tm_layout(main.title = "Jenks Style", main.title.size = 1, legend.text.size = 0.5, legend.position = c("left", "top"))

# quantile style divides into 5 even groups
quantile <- tm_shape(nz) + tm_polygons(col = "Population", style = "quantile", n=5) + 
  tm_layout(main.title = "Quantile Style", main.title.size = 1, legend.text.size = 0.5, legend.position = c("left", "top"))

# Equal interval style divides the distribution into even groups
equal <- tm_shape(nz) + tm_polygons(col = "Population", style = "equal", n = 5) + 
  tm_layout(main.title = "Equal Style", main.title.size = 1, legend.text.size = 0.5, legend.position = c("left", "top"))

# Write maps above to objects and plot them side by side 
# with tmap_arrange() for better comparison
tmap_arrange(pretty,jenks,quantile,equal)


#### Exercise I ####

# 1. What are the advantages and disadvantages of each classification method?
# 2. Choose the best classification and create a map with easily legible legend and all other essentials.
# (Select a suitable color palette from http://colorbrewer2.org/, north arrow, scale, map title, 
# legend title, reasonable number of breaks in the classification )
# 3. Which method and how many classes did you end up using to display
# your data? Why did you select that method?
# 4. What principles did you use in arranging the parts of your map layout the way you
# did and how did you apply these principles?

# Your solution

# /Start Code/ #

# 1: Advantages and disadvantages of each classification method:
# Pretty:
  # Good: makes pretty breaks/classes, which might make it easier to understand/remember the classification
  # Bad: how well it works might also depend on how many classes you set

# Jenks 
  # Good: nice, because you find a classification that works well with your data and therefore avoids disadvantages of e.g. the equal breaks
  # Bad: the classification will be different for each dataset/map, which makes it difficult to compare maps

# Quantile 
  # Good: map will probably be pretty, because each color is represented euqally
  # Bad: some classes might only contains a small range of values (0-3), while others have a large range of values (10-100), especially, if you have outliers. 
      # In that case you would group together values which are very different, i.e. there would be little diversity in the colors in the map. 

# Equal
  # Good: easier to understand legend, and it's relation to the colors, works well when your data is spread across the entire range of values
  # Bad: if your data is not spread across all values, if your data is skewed, or if your data has outliers, a lot of the map will be in the same/similar color

# /End Code/ #