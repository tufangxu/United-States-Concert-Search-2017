
server <- function(input, output) {
  
  output$map <- renderLeaflet({

    concert.places <- as.data.frame(list(long = c(-70, -90) , lat = c(40, 50)))
    concert.places <- insertRow(concert.places, getCurrentLocation(), 1)
    leaflet(data = concert.places, options = leafletOptions(minZoom = 2)) %>%
      setView(lng = -100, lat = 37, zoom = 5) %>% 
      setMaxBounds(-180, -180, 180, 180) %>% 
      addPolylines(~long, ~lat, weight = 1, opacity = 0.2) %>% 
      addProviderTiles(input$map.style) %>% 
      addMarkers(~long, ~lat, clusterOptions = markerClusterOptions())
  })
}