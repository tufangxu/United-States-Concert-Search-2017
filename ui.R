
ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.css"),
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.Default.css"),
  includeScript("Leaflet.markercluster-1.0.3/dist/leaflet.markercluster.js"),
  
  
  selectInput(
    'map.style',
    "Choose your map style:",
    list(
      NASAGIBS.ViirsEarthAtNight2012 = providers$NASAGIBS.ViirsEarthAtNight2012,
      Esri.WorldGrayCanvas = providers$Esri.WorldGrayCanvas,
      CartoDB.Positron = providers$CartoDB.Positron,
      Hydda.Full = providers$Hydda.Full,
      Esri.WorldImagery = providers$Esri.WorldImagery
    ),
    selected = providers$Esri.WorldGrayCanvas
  ),
  
  leafletOutput("map", width = "100%", height = "100%")
  
  
)

