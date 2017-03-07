library(shiny)
library(dplyr)
library(httr)
library(jsonlite)
library(knitr)
library(ggplot2)

server <- function(input, output) {
  output$summary <- renderUI({
    HTML(paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=', input$search.input, '&key=AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI" allowfullscreen></iframe>'))
  })
  
  search.input <- reactive({
    zipcode <- input$search.input
    # returns the zip code
  })
  
  key.jambase <- "27ye9d7m5mpepbejcxzme6pd"
  base.uri.jambase <- "http://api.jambase.com"
  resource.artist.jambase <- "/artists"
  # Grabs information about event
  # Right now this code will get event data based on zip code
  zip.code <- search.input()
  resource.venue.jambase <- "/events"
  uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
  # query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key.jambase, o = "json")
  query.venue.jambase <- list(zipCode = zip.code, api_key = key.jambase , o = "json")
  response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
  body.venue.jambase <- content(response.venue.jambase, "text")
  data.venue.jambase <- fromJSON(body.venue.jambase)
  results.venue.jambase <- as.data.frame(data.venue.jambase$Events)
  relevant.results.venue.jambase <- results.venue.jambase$Venue
  date.venue.jambase <- results.venue.jambase$Date
  relevant.results.venue.jambase <- mutate(relevant.results.venue.jambase, date = date.venue.jambase)
  us.results.venue.jambase <- relevant.results.venue.jambase %>% filter(Country == "US")
}


google.map.api.key <- "AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI"

geoSearch <- function(input) {
  google.map.api <- "AIzaSyCiqFj9PmX3bNs40cqpAXkPmsDHxt9TYoI"
  html.doc <- paste0('<iframe width="100%" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/search?q=',
                     input, "&key=", google.map.api.key, "allowfullscreen></iframe>")
  return(html.doc)
}

geoSearch("Seattle")


