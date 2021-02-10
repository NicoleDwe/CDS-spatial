##-----------------------------------------------##
##    Author: Adela Sobotkova                    ##
##    Institute of Culture and Society           ##
##    Aarhus University, Aarhus, Denmark         ##
##    adela@cas.au.dk                             ##
##-----------------------------------------------##

#### Goals ####

# - Understand the provided datasets
# - Learn how to reproject spatial data
# - Limit your data into an area of interest
# - Create a new map

# We highlighted all parts of the R script in which you are supposed to add your
# own code with: 

# /Start Code/ #

print("Hello World") # This would be your code contribution

# /End Code/ #

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

# We will use two data sets: `srtm` and `zion`.
# The first one is an elevation raster object for the Zion National Park area, and the second one is an sf object with polygons representing borders of the Zion National Park.

srtm <- raster(system.file("raster/srtm.tif", package = "spDataLarge"))
zion <- read_sf(system.file("vector/zion.gpkg", package = "spDataLarge"))

# Additionally, the last exercise (IV) will used the masked version of the `lc_data` dataset.

# study_area <- read_sf("data/study_area.gpkg")
# lc_data <- raster("data/example_landscape.tif")
# lc_data_masked <- mask(crop(lc_data, study_area), study_area)

#### Exercise I ####

# 1. Display the `zion` object and view its structure.
# What can you say about the content of this file?
# What type of data does it store? 
# What is the coordinate system used?
# How many attributes does it contain?
# What is its geometry?
# 2. Display the `srtm` object and view its structure.
# What can you say about the content of this file? 
# What type of data does it store?
# What is the coordinate system used? 
# How many attributes does it contain?
# How many dimensions does it have? 
# What is the data resolution?

# Your solution (type answer to the questions as code comments and the code used)

# /Start Code/ #

# 1. Displaying zion object and viewing its structure

?zion
# content: contains data of the zion national park

class(zion)
# type of data it stores: vector data

head(zion)
st_crs(zion)
# coordinate system: the coordinate system is the UTM Zone 12 (Northern Hemisphere)
# attributes: it has 11 attributes + the geographic/spatial information (= 12 columns)
# dimensions: it has 2 dimensions (x, y)

# 1. Displaying strm object and viewing its structure

?srtm
# content: elevation raster of zion nnational part 

# this functions prints out all the "meta-data" together, rather than me having to call each of the functions
# so I know there is other specific functions, but this is just easier
ratify(srtm)
# type of data: raster data
# coordinate system: the corrdinate system is the WGS 84
# attributes: I guess it contains one attribute of elevation (+ the spatial information)
# dimensions: 457 rows, 465 cells
# resolution: 0.0008333333, 0.0008333333 (x, y)

# /End Code/ #

#### Exercise II ####

# 1. Reproject the `srtm` dataset into the coordinate reference system used in the `zion` object. 
# Create a new object `srtm2`
# Vizualize the results using the `plot()` function.
# 2. Reproject the `zion` dataset into the coordinate reference system used in the `srtm` object.
# Create a new object `zion2`
# Vizualize the results using the `plot()` function.

# Your solution

# /Start Code/ #

# 1: Reprojecting srtm to the crs of the zion

# getting crs info of the zion object
st_crs(zion)

# because raster needs a proj4 string, I took the info from the st_crs and googled to find the proj4 string to do the transformation
# here is the link: https://www.spatialreference.org/ref/epsg/wgs-84-utm-zone-12n/
# defining utm12
utm12 <- "+proj=utm +zone=12 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

# transform the srtm and save as srtm2
srtm2 <- projectRaster(srtm, crs = utm12, method = "ngb")

# plot srtm2
plot(srtm2)

# 2: Reprojecting zion to the crs of the srtm object

# transform the zion dataset using the crs of the srtm
zion2 <- st_transform(zion, crs = crs(srtm))

# plot zion2
plot(zion2)
plot(st_geometry(zion2)) # for simple visualisation

# /End Code/ #
