

library(shiny)
library(leaflet)
library(dplyr)
server <- function(input, output) {
  
  output$map <- renderLeaflet({

    concert.places <- as.data.frame(list(long = c(-40, - 50, - 70, - 90) , lat = c(30, 10, 40, 50)))
    concert.places <- insertRow(concert.places, getCurrentLocation(), 1)
    leaflet(data = concert.places) %>%
      setView(lng = -100, lat = 35, zoom = 4) %>% 
      addMarkers(~long, ~lat, label = ~"123", clusterOptions = markerClusterOptions()) %>% 
      addPolylines(~long, ~lat) %>% 
      addProviderTiles(input$map.style)
  })
}