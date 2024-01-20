source("C:/Users/pedro/Desktop/ICG/R 2/Codes_analysis_figs/0_Load_hillshade_shp.R")
######################################################################################
######################################################################################

MoNEW      <- read_sf(dsn = "C:/Users/pedro/Desktop/ICG/inventories/MoNEW_15019.shp") %>% as.data.frame()


#import raster data (MoNOE predictions)
MoNOE_pred =    raster("C:/Users/pedro/Desktop/ICG/grids/pred_gam_final_adj_fix_fill_class.tif")



#Create a SPDF from the inventories
MoNEW_spdf      <- SpatialPointsDataFrame(MoNEW [,20:21],   MoNEW) 

#Assigning the same CRS as the predictions
crs(MoNEW_spdf)    = crs(MoNOE_pred)

mapviewOptions(basemaps = c("CartoDB.Positron"),
               raster.palette = grey.colors,
               vector.palette = colorRampPalette(c("snow", "cornflowerblue", "grey10")),
               na.color = "NA",
               layers.control.pos = "topright",
               #fgb = TRUE,
               mapview.maxpixels=Inf,
               plainview.maxpixels=Inf,
               raster.size=Inf,
               #georaster = TRUE,
               #viewer.suppress = TRUE
)



mapview(MoNEW_spdf,        zcol = "source",        cex=3, lwd=0.5, layer.name = 'Source')













library(sf)
library(leaflet)

# Read the data
LA <- sf::st_read(dsn = "C:/Users/pedro/Desktop/ICG/inventories/LowerAustria_M34.shp")
MoNEW <- sf::st_read(dsn = "C:/Users/pedro/Desktop/ICG/inventories/MoNEW_15019.shp")

# Ensure LA and MoNEW are in the same CRS
MoNEW <- sf::st_transform(MoNEW, st_crs(LA))

# Transform both to WGS84
LA_wgs84 <- st_transform(LA, 4326)
MoNEW_wgs84 <- st_transform(MoNEW, 4326)

# Your leaflet code
m <- leaflet(options = leafletOptions(minZoom = 8, maxZoom = 12)) %>%
  addTiles() %>% leafem:: addMouseCoordinates()%>%
  #leaflet.extras::addHeatmap(data = st_coordinates(MoNEW_wgs84), max = 50, radius = 10, blur = 10) %>%
  addCircleMarkers(data = MoNEW_wgs84, 
                   radius = 1/4,      # adjust as desired
                   color = "blue",  # adjust as desired
                   stroke = FALSE,  # to remove the border
                   fillOpacity = .3) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = LA_wgs84, color = "black", fillOpacity = 0, weight = 3) %>%
  
  addMiniMap(position = "topleft", tiles = providers$OpenStreetMap.Mapnik, toggleDisplay = TRUE) %>%
  addScaleBar()

# Save the map and screenshot
mapview::mapshot(m, url = "C:/Users/pedro/Desktop/ICG/Plots_figures/invent_heatmap_pts.html")
webshot::webshot("C:/Users/pedro/Desktop/ICG/Plots_figures/invent_heatmap.png")
