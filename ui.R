library(shiny)
library(dplyr)
library(httr)
library(jsonlite)
library(knitr)

library(ggplot2)

# base.uri.spotify <- "https://api.spotify.com"
# spotify.search <- "v1/search"
# uri.spotify <- paste0(base.uri.spotify, spotify.search)


key.jambase <- "27ye9d7m5mpepbejcxzme6pd"
artist.name <- "chance the rapper" # Need to get this from Spotify 
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