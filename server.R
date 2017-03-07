server <- function(input, output) {
  output$summary <- renderUI({
    HTML(paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=', input$search.input, '&key=AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI" allowfullscreen></iframe>'))
  })
  
  # make tabe interactive
  search.input <- reactive({
    key.jambase <- "27ye9d7m5mpepbejcxzme6pd"
    artist.name <- input$search.input
    base.uri.jambase <- "http://api.jambase.com"
    resource.artist.jambase <- "/artists"
    uri.artist.jambase <- paste0(base.uri.jambase, resource.artist.jambase)
    query.artist.jambase <- list(name = artist.name, api_key = key.jambase, o = "json")
    response.artist.jambase <- GET(uri.artist.jambase, query = query.artist.jambase)
    body.artist.jambase <- content(response.artist.jambase, "text")
    data.artist.jambase <- fromJSON(body.artist.jambase)
    results.artist.jambase <- data.artist.jambase$Artists
    results.artist.id.jambase <- results.artist.jambase$Id
    
    resource.venue.jambase <- "/events"
    uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
    query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key.jambase, o = "json")
    response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
    body.venue.jambase <- content(response.venue.jambase, "text")
    data.venue.jambase <- fromJSON(body.venue.jambase)
    results.venue.jambase <- data.venue.jambase$Events
    return(results.venue.jambase)
  })
}
 search.artist <- reactive{
   
 }

output$table <- renderTable({
  
})

google.map.api.key <- "AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI"

geoSearch <- function(input) {
  google.map.api <- "AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI"
  html.doc <- paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=',
                     input, "&key=", google.map.api.key, "allowfullscreen></iframe>")
  return(html.doc)
}

geoSearch("Seattle")


