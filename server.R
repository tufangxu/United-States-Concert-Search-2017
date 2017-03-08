library(leaflet)

server <- function(input, output) {
  
  output$artist.name <- renderText({
    user.artist.name <- input$search.input
    paste0("Here are some concerts happening for ", user.artist.name, "...")
  })
  
  output$map <- renderLeaflet({
    testmap <- leaflet(data = results.venue.location) %>% addMarkers(lng = ~Longitude, lat = ~Latitude, popup = content) %>% addProviderTiles(providers$OpenStreetMap.France)
    testmap
  })
  
  output$concertlist <- renderTable(results.venue.jambase)
  
}
