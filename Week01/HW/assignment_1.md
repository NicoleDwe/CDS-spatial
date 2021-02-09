Assignment 1: Interactive Maps with Leaflet
================
Nicole Dwenger
2021/02/02

**1. Answer:** Describe a problem or question in your field for which
spatial analysis could be applicable.

Spatial analysis could be applied to analyse the locations of terrorist
attacks in specific countries or around the world. This would also be
interesting to look at over time, i.e. where were clusters of attacks in
1990, 2000 and 2010? It would also be interesting to see whether there
are differences in who the target was, and how they differ in different
areas of the world.

**2. Answer:** List 5 data layers that you think are necessary to answer
your question/solve your problem. Find on the internet github.and then
describe examples of two or three of your listed layers.

  - Point layer of terrorist attacks: The [Global Terrorism
    Database](https://www.start.umd.edu/gtd/) has some open data, with
    information on location of attacks (country, city), but where
    available also geospatial information (long, lat) and also have some
    additional information about the attack, e.g. time, target, weapon,…
  - Polygon layer of countries: If the analysis is across the world, it
    would be necessary to have a map of polygons defining the borders of
    the countries
  - Point layer of capitals/cities: It could also be nice to have a
    layer of points of capitals/cities of the countries
  - For the polygon and point layer it would be fine to just rely on
    maps we also used in class, and which are included in leaflet,
    e.g. from esri, and the terrorist data could be laid on top of that
    (similar to what we did in class with places in Denmark)

**3. Code:** Your colleague has found some ruins during a hike in the
Blue Mountains and recorded the coordinates of structures on her
phone(RCFeature.csv). She would like to map her points but has no
computer or mapping skills. Can you make a map that she can work with
using only a browser? She needs an interactive map that she can download
to her computer and use straightaway.

**4.** Create a standalone .html map in Leaflet showing at least basic
topography and relief, and load in the table of points. Make sure she
can see the FeatureID, FeatureType and Description attributes when she
hovers over the point markers.

``` r
# packages
library(pacman)
p_load(leaflet, htmltools, htmlwidgets, tidyverse, here)

# load data
rcf <- read_csv(here("HW", "RCFeature.csv"))
# remove NA's in the data
rcf <- rcf %>% filter(!is.na(Longitude))
```

``` r
# define popup-content of markers: Feature ID, Feature Type and Description, will be used in the following maps
# <b> for bold and </br> for line breaks
popup_content <- paste(
  "<b>Feature ID:</b>", rcf$FeatureID, "<br/>",
  "<b>Feature Type:</b>", rcf$FeatureType, "<br/>",
  "<b>Description:</b>", rcf$Description
)

# simple map (width 100% to make it pretty in html document)
map <- leaflet(width = "100%") %>%
  addTiles() %>% 
  # add markers based on long, lat and add pop-up content (defined above)
  addMarkers(lng = rcf$Longitude, 
             lat = rcf$Latitude,
             popup = popup_content)
map
```

**5.** Consider adding elements such as minimap() and measure() for
easier map interaction

``` r
# map with additional elements of minimap and measure
additional_map <- leaflet(width = "100%") %>% 
  addTiles() %>% 
  addMarkers(lng = rcf$Longitude, 
             lat = rcf$Latitude,
             popup = popup_content) %>%
  # add mini map using ESRI and on the bottom right 
  addMiniMap(tiles = "Esri", toggleDisplay = TRUE,
             position = "bottomright") %>%
  # add measure, using meters/squaremeters on bottom left
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") 

additional_map
```

**6.** Explore differentiating the markers (e.g. by size using Accuracy
field)

``` r
# map in which markers are replaced with circles, which differ in size depending on accuracy 
size_map <- leaflet(width = "100%") %>% 
  addTiles() %>% 
  # change to circle markers to adjust the radius
  addCircleMarkers(lng = rcf$Longitude, 
                   lat = rcf$Latitude,
                   popup = popup_content,
                   # added radius to adjust the size based on Accuracy (*3 to have a nicer scale)
                   radius = rcf$Accuracy*3) %>%
  # add mini-map as above
  addMiniMap(tiles = "Esri", toggleDisplay = TRUE,
             position = "bottomright") %>%
  # add measure as above
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") 

size_map
```

**7.** Explore the option of clustering markers with
addMarkers(clusterOptions = markerClusterOptions()). Do you recommend
marker clustering here? When you zoom out it makes little sense to
cluster, because of course all places are clustered in the blue
mountains region. However, when zooming in it might be useful to
cluster, as features which she recorded in the same or nearby place
might be belonging to the same site/ruin.

``` r
# map with clustering of markers 
cluster_map <- leaflet(width = "100%") %>% 
  addTiles() %>% 
  # add circle markers, which differ in size (as above)
  addCircleMarkers(lng = rcf$Longitude, 
                   lat = rcf$Latitude,
                   popup = popup_content,
                   radius = rcf$Accuracy*3,
                   # add clustering of markers 
                   clusterOptions = markerClusterOptions()) %>%
  # add mini map as above
  addMiniMap(tiles = "Esri", toggleDisplay = TRUE,
             position = "bottomright") %>%
  # add measure as above
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") 

cluster_map
```

**Save final map:**

``` r
# load necessary package
library(htmlwidgets)

# save the widget
saveWidget(cluster_map, here("HW", "bluemountains_map.html"), selfcontained = TRUE)
```
