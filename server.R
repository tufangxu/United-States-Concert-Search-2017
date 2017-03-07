server <- function(input, output) {
  output$summary <- renderUI({
    HTML(paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=', input$search.input, '&key=AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI" allowfullscreen></iframe>'))
  })


}


google.map.api.key <- "AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI"

geoSearch <- function(input) {
  google.map.api <- "AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI"
  html.doc <- paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=',
                     input, "&key=", google.map.api.key, "allowfullscreen></iframe>")
  return(html.doc)
}

geoSearch("Seattle")


