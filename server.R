library(leaflet)

server <- function(input, output) {
  
  #output$summary <- renderUI({
  #  HTML(paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=', input$search.input, '&key=AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI" allowfullscreen></iframe>'))
  #})
  
  output$zipcode <- renderText({
    user.zipcode <- input$search.input
    paste0("Here are some concerts happening within ", user.zipcode, "...")
  })
  
  output$map <- renderLeaflet({
    testmap <- leaflet() %>% addMarkers(lng = -117.21192, lat = 32.75369, popup = "Testing") %>% addTiles()
    testmap
  })
  
  output$concertlist <- renderTable(results.venue.jambase)
  
}