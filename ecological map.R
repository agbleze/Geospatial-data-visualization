# load libraries
library(terra)
library(sf)         
library(spData)        # load geographic data
library(spDataLarge)   # load larger geographic data
library(raster)
library(rasterVis)
library(ggmap)
library(leaflet)
#library(leafletR)
library(ggplot2)
library(tidyverse)
library(tmap)
library(tmaptools)
library(mapview)
library(mapdeck)
## file path to ecological ecosystems
ecological_es_mean_file_path <-  "~/Desktop/AGGREGATE/Ecological_ES_Mean.tif"

ecological_es_sum_file_path <- "~/Desktop/AGGREGATE/Ecological_ES_SUM.tif"
economic_es_mean_filepath <- "~/Desktop/AGGREGATE ECONOMIC/Economic_ESmean_Rescale.tif"
economic_es_mean_resam_filepath <- "~/Desktop/AGGREGATE ECONOMIC/Economic_ES_MEAN_Clip1_Resam.tif"
social_es_mean_filepath <- "~/Desktop/AGGREGATE-social/Social_ES_Mean.tif"

ecological_prioritized_filepath <- "~/Desktop/PRIORITIZE ES/Ecological_ES_Prioritized_mean.tif"
economic_prioritized_filepath <- "~/Desktop/PRIORITIZE ES/Economic_ES_Prioritized_mean.tif"
social_prioritized_filepath <- "~/Desktop/PRIORITIZE ES/SOcial_ES_Prioritized_mean.tif"
equal_weight_filepath <- "~/Desktop/PRIORITIZE ES/Equal_Weighting_All.tif"

ecological_priori_hotspot_filepath <- "~/Desktop/HOTSPOT ANALYSIS/ONLY HOTSPOTS COLDSPOTS NON-SIG/Ecological_ES_Prioritized_mean_Points_Hotspot.tif"
economic_priori_hotspot_filepath <- "~/Desktop/HOTSPOT ANALYSIS/ONLY HOTSPOTS COLDSPOTS NON-SIG/Economic_ES_Prioritized_mean.tif"
social_priori_hotspot_filepath <- "~/Desktop/HOTSPOT ANALYSIS/ONLY HOTSPOTS COLDSPOTS NON-SIG/SOcial_ES_prioritized_mean_Hotspot.tif"
## read raster files
ecological_es_sum_raster <- raster(ecological_es_sum_file_path)
ecological_es_mean_raster <- raster(ecological_es_mean_file_path)
economic_es_mean_raster <- raster(economic_es_mean_filepath)
economic_es_mean_resam_raster <- raster(economic_es_mean_resam_filepath)
social_es_mean_raster <- raster(social_es_mean_filepath)

ecological_prioritized_raster<- raster::raster(ecological_prioritized_filepath)
economic_prioritized_raster <- raster::raster(economic_prioritized_filepath)
social_prioritized_raster <- raster::raster(social_prioritized_filepath)
equal_weight_raster <- raster(equal_weight_filepath)

raster(ecological_priori_hotspot_filepath) -> ecological_priori_hotspot_raster
raster(economic_priori_hotspot_filepath) -> economic_priori_hotspot_raster
raster(social_priori_hotspot_filepath) -> social_priori_hotspot_raster

### plot raster
ecol <- raster::plot(ecological_es_sum_raster)
raster::plot(ecological_es_mean_raster)
raster::plot(economic_es_mean_raster)

raster::plot(economic_es_mean_resam_raster)
raster::plot(social_es_mean_raster)
raster::plot(ecological_prioritized_raster)
raster::plot(economic_prioritized_raster)
raster::plot(social_prioritized_raster)
raster::plot(equal_weight_raster)
raster::plot(ecological_priori_hotspot_raster)
raster::plot(economic_priori_hotspot_raster)
raster::plot(social_priori_hotspot_raster)

tm_shape(ecological_priori_hotspot_raster) + tm_raster()

############### filepath to shapefiles
## file path to france shapefiles
france_shp_filepath <- "~/Desktop/FranceProjected.shp"
fran_adm3_filepath <- "~/Desktop/FRA_adm/FRA_adm3.shp"
fran_adm0_filepath <- "~/Desktop/FRA_adm/FRA_adm0.shp"

soc_mean_hotspot_shp_filepath <- "~/Desktop/HOTSPOT ANALYSIS/SOcial_ES_prioritized_mean_hotspot.shp"

soc_mean_hotspot_shp$Gi_Bin
soc_mean_hotspot_shp$GiPValue


## read shp
france_shp <- sf::read_sf(france_shp_filepath)
france_shp_tmp <- tm_shape(france_shp) + tm_polygons()
fran_adm3_shp <- sf::read_sf(fran_adm3_filepath)
soc_mean_hotspot_shp <- st_read(soc_mean_hotspot_shp_filepath)
fran_adm0_shp <- st_read(fran_adm0_filepath)
#tm_shape(soc_mean_hotspot_shp) + tm_style(style = "bw")

### plot shp
plot_sf(fran_adm3_shp$geometry)
View(soc_mean_hotspot_shp) ## view shp dataframe
plot_sf(soc_mean_hotspot_shp[6])
(fran_adm3_shp_tmap <- tm_shape(fran_adm3_shp) + tm_polygons())
fran_adm0_tmap <- tm_shape(fran_adm0_shp) + tm_polygons()

plot_sf(fran_adm0_shp)
View(fran_adm0_shp)
qtm(fran_adm0_shp)
## plot raster
raster_load <- raster("Ecological_ES_Mean.tif")
plot(raster_load)
plot(raster_load) 
qtm(raster_load)

tmap::tm_raster(raster_load)
raster_tmap <- tmap::tm_shape(raster_load) + tm_raster() 
tmap_mode("plot")
raster_tmap
raster_tmap + france_shp_tmp

### check projections
crs_ecolo <- raster::crs(raster_load)
st_crs(fran_adm3_shp)
st_crs(fran_adm3_shp) <- crs_ecolo
fran_adm3_shp <- st_transform(fran_adm3_shp, crs = crs_ecolo)
st_crs(fran_adm0_shp) <- crs_ecolo
fran_adm0_shp<- st_transform(fran_adm0_shp, crs = crs_ecolo)
View(fran_adm3_shp) ## view dataframe of shapefile
plot_sf(fran_adm3_shp[3]) ## plot column 3
plot_sf(fran_adm0_shp)


#### create tmap objects
hotspot_economic_priori_tm <- tm_shape(economic_priori_hotspot_raster) + tm_raster()
hotspot_ecological_priori_tm <- tm_shape(ecological_priori_hotspot_raster) + tm_raster()
hotspot_social_priori_tm<- tm_shape(social_priori_hotspot_raster) + tm_raster()

tmap_arrange(hotspot_ecological_priori_tm, hotspot_economic_priori_tm, hotspot_social_priori_tm)


tm_shape(fran_adm3_shp) + tm_polygons(col = "NAME_1") 
tm_shape(fran_adm3_shp) + tm_polygons(col = "ID_1", n = 10, palette = "BuGn")


## animated maps
# es_hotspots <- tm_shape(ecological_priori_hotspot_raster) + tm_raster() + 
#   tm_shape(economic_priori_hotspot_raster) + tm_raster() +
#   tm_shape(social_priori_hotspot_raster) + tm_raster()
# 
# tmap_animation(es_hotspots, filename = "es_anim.gif", delay = 25)


urb_anim = tm_shape(world) + tm_polygons() + 
  tm_shape(urban_agglomerations) + tm_dots(size = "population_millions") +
  tm_facets(along = "year", free.coords = FALSE)
urban_animation <- tmap_animation(urb_anim, filename = "urb_anim.gif", delay = 25)
urban_animation
tmap_mode("view")

#### use tmap to create interactive map, faceted and synced 
world_coffee <- left_join(world, coffee_data, by = "name_long")
facets <- c("coffee_production_2016", "coffee_production_2017")
tm_shape(world_coffee) + tm_polygons(facets) + tm_facets(nrow = 1, sync = TRUE)

View(world_coffee)
View(world)
View(coffee_data)

## use mapview to create interactive web map
mapview::mapview(fran_adm3_shp)
mapview::mapview(ecological_es_mean_raster) 

trails%>%
  st_transform(crs(franconia)) %>%
  st_intersection(franconia[franconia$district == "oberfranken",]) %>%
  st_collection_extract("LINE") %>%
  mapview(color = "red", lwd = 3, layer.name = "trails") +
  mapview(franconia, zcol = "district", burst = TRUE) +
  breweries

View(trails)
View(franconia)
crs(trails)
crs(franconia)

library(mapdeck)
MAPBOX <- "pk.eyJ1IjoiYWdibGV6ZSIsImEiOiJja3RxYjJsdTgwNHFiMm9xZXlvazU4Z2Q3In0._u5Q5XKA-T1HCCkyzRq5iw"
set_token(Sys.getenv("MAPBOX"))
crash_data = read.csv("https://git.io/geocompr-mapdeck")
crash_data = na.omit(crash_data)
ms = mapdeck_style("dark")
mapdeck(style = ms, pitch = 45, location = c(0, 52), zoom = 4) %>%
  add_grid(data = crash_data, lat = "lat", lon = "lng", cell_size = 1000,
           elevation_scale = 50, layer_id = "grid_layer",
           colour_range = viridisLite::plasma(6))

m <- leaflet() %>%
  addTiles()
m

tmap_mode("plot")
