
library(markdown)
library(httr)
library(jsonlite)
library(dplyr)
library(shiny)
library(leaflet)


# base.uri.spotify <- "https://api.spotify.com"
# spotify.search <- "v1/search"
# uri.spotify <- paste0(base.uri.spotify, spotify.search)


key.jambase <- "vbtqtqkcmhp5w8bbx4f5999m"

artist.name <- "chance the rapper" 
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
results.venue.jambase <- flatten(results.venue.jambase)
results.venue.jambase <- filter(results.venue.jambase, Venue.Country == "US" & Venue.CountryCode == "US")
results.venue.location <- select(results.venue.jambase, Venue.Latitude, Venue.Longitude, Venue.Name, Venue.Address, Venue.City, Venue.StateCode)
colnames(results.venue.location) <- c("Latitude", "Longitude", "Name", "Address", "City", "State")

content <- paste(results.venue.location$Name, results.venue.location$Address, results.venue.location$City, ", ", results.venue.location$State)

ui <- bootstrapPage(
  tags$style(
    type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", height = "100%"),
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = F, top = 0, left = "auto", right = "auto", bottom = "auto",
                width = "auto", height = "auto",
                
                textInput("Search", "search.artist")
                
                 )
)
