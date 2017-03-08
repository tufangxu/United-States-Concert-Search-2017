
ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.css"),
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.Default.css"),
  includeCSS("style.css"),
  includeScript("Leaflet.markercluster-1.0.3/dist/leaflet.markercluster.js"),
  
  leafletOutput("map", width = "100%", height = "100%"),
  
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = F, top = 0, left = "auto", right = 0, bottom = "auto",
                width = "auto", height = "100%", 
                
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
                
                textInput(
                'search.input',
                'Enter Your Favorite Artist Name',
                value = "Artist"
                ),
                dateRangeInput('date', label = "Concert Date Range:", start = date(),
                               format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                                language = "en", separator = " to "),
                
                downloadButton('downloadData', 'Download Concert Information')
                )

)
