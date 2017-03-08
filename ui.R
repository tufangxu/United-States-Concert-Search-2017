
ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.css"),
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.Default.css"),
  includeCSS("style.css"),
  includeScript("Leaflet.markercluster-1.0.3/dist/leaflet.markercluster.js"),
  
  leafletOutput("map", width = "100%", height = "100%"),
  
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = F, top = 0, left = "auto", right = "auto", bottom = "auto",
                width = "auto", height = "auto", 
                
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
                )
  )
  
)

