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
spotify.jambase <- "79db19b5259746888cc2eb93fdbbdd25"

base.uri.spotify <- "https://api.spotify.com"
search.spotify <- "/v1/search"
uri.spotify <- paste0(base.uri.spotify, search.spotify)
query.spotify <- list(type = "artist", q = "Kanye West") # q will have to be an interactive ariable # Obtained from Jambase API
response.spotify <- GET(uri.spotify, query = query.spotify)
body.spotify <- content(response.spotify, "text")
data.spotify <- fromJSON(body.spotify)
results.spotify <- data.spotify$artists$items$id[[1]]

artist.spotify <- "/v1/artists/"
uri.artist.spotify <- paste0(base.uri.spotify, artist.spotify, results.spotify)
response.artist.spotify <- GET(uri.artist.spotify)
body.artist.spotify <- content(response.artist.spotify, "text")
data.artist.spotify <- fromJSON(body.artist.spotify)




artist.name <- "chance the rapper" 
base.uri.jambase <- "http://api.jambase.com"
resource.artist.jambase <- "/artists"
# Only if we want specific artist
# uri.artist.jambase <- paste0(base.uri.jambase, resource.artist.jambase)
# query.artist.jambase <- list(name = artist.name, api_key = key.jambase, o = "json")
# response.artist.jambase <- GET(uri.artist.jambase, query = query.artist.jambase)
# body.artist.jambase <- content(response.artist.jambase, "text")
# data.artist.jambase <- fromJSON(body.artist.jambase)
# results.artist.jambase <- data.artist.jambase$Artists
# results.artist.id.jambase <- results.artist.jambase$Id

# Grabs information about event
resource.venue.jambase <- "/events"
uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
# query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key.jambase, o = "json")
query.venue.jambase <- list(zipCode = 98277, api_key = key.jambase , o = "json")
response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
body.venue.jambase <- content(response.venue.jambase, "text")
data.venue.jambase <- fromJSON(body.venue.jambase)
results.venue.jambase <- as.data.frame(data.venue.jambase$Events)
relevant.results.venue.jambase <- results.venue.jambase$Venue
date.venue.jambase <- results.venue.jambase$Date
relevant.results.venue.jambase <- mutate(relevant.results.venue.jambase, date = date.venue.jambase)
us.results.venue.jambase <- relevant.results.venue.jambase %>% filter(Country == "US")

