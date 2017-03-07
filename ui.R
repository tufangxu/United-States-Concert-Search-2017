

library(shiny)
library(shinyjs)
library(V8)
library(leaflet)

ui <- bootstrapPage(

  includeCSS("Leaflet.markercluster/dist/MarkerCluster.css"),
  includeCSS("Leaflet.markercluster/dist/MarkerCluster.Default.css"),
  includeScript("Leaflet.markercluster/dist/leaflet.markercluster.js"),
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  selectInput(
    'map.style',
    "Choose your map style:",
    list(
      NASAGIBS.ViirsEarthAtNight2012 = providers$NASAGIBS.ViirsEarthAtNight2012,
      Esri.WorldGrayCanvas = providers$Esri.WorldGrayCanvas
    ),
    selected = providers$Esri.WorldGrayCanvas
  ),
  
  leafletOutput("map", width = "100%", height = "100%")
  
  
)

