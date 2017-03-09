library(shiny)
library(dplyr)
library(httr)
library(jsonlite)
library(knitr)
library(ggplot2)

#Jambase Key
#key1.jambase <- "27ye9d7m5mpepbejcxzme6pd"
key1.jambase <- "6bnahwpm27pesua7ehycppxh"
#key2.jambase <- "vbtqtqkcmhp5w8bbx4f5999m"
 key2.jambase <- "8qgdfttz4xd2abmbxqwrswjv" ### DO NOT USE THIS ONE ###

# Not a key, just an ID/secret, should still be able to obtain information about
# from spotify without a key though
# spotify.jambase <- "79db19b5259746888cc2eb93fdbbdd25"

artist.name <- "Joey Bada$$" # This variable should be reactive or change
# depending on jambase api
base.uri.jambase <- "http://api.jambase.com"
resource.artist.jambase <- "/artists"

# Only if we want specific artist

uri.artist.jambase <- paste0(base.uri.jambase, resource.artist.jambase)
query.artist.jambase <- list(name = artist.name, api_key = key1.jambase, o = "json")
response.artist.jambase <- GET(uri.artist.jambase, query = query.artist.jambase)
body.artist.jambase <- content(response.artist.jambase, "text")
data.artist.jambase <- fromJSON(body.artist.jambase)
results.artist.jambase <- data.artist.jambase$Artists
results.artist.id.jambase <- results.artist.jambase$Id[[1]]

# Grabs information about event
# Right now this code will get event data based on zip code
### DO NOT RUN THE CODE BELOW MROE THAN ONCE ###
###                                          ###
resource.venue.jambase <- "/events"
uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key2.jambase, o = "json")
response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
body.venue.jambase <- content(response.venue.jambase, "text")
data.venue.jambase <- fromJSON(body.venue.jambase)
###                                             ###
### DO NO NOT RUN THE CODE ABOVE MORE THAN ONCE ###

results.venue.jambase <- as.data.frame(data.venue.jambase$Events)
relevant.results.venue.jambase <- results.venue.jambase$Venue
date.venue.jambase <- results.venue.jambase$Date
relevant.results.venue.jambase <- mutate(relevant.results.venue.jambase, date = 
                                           date.venue.jambase)
us.results.venue.jambase <- relevant.results.venue.jambase %>% filter(Country == "US") %>%
  filter(Latitude != 0) %>% filter(Longitude != 0)
us.results.venue.jambase <- unique(us.results.venue.jambase)


# This section of code will find the ID of a desired artist
artist.name <- "" # Dummy variable. This variable should grab an artist name from the dataset from jambase
base.uri.spotify <- "https://api.spotify.com"
search.spotify <- "/v1/search"
uri.spotify <- paste0(base.uri.spotify, search.spotify)
query.spotify <- list(type = "artist", q = "Kanye West") # q will have to be an interactive ariable # Obtained from Jambase API
response.spotify <- GET(uri.spotify, query = query.spotify)
body.spotify <- content(response.spotify, "text")
data.spotify <- fromJSON(body.spotify)
results.spotify <- data.spotify$artists$items$id[[1]]

# This section of code will get the genre of an artist
artist.spotify <- "/v1/artists/"
uri.artist.spotify <- paste0(base.uri.spotify, artist.spotify, results.spotify)
response.artist.spotify <- GET(uri.artist.spotify)
body.artist.spotify <- content(response.artist.spotify, "text")
data.artist.spotify <- fromJSON(body.artist.spotify)
results.artist.spotify <- data.artist.spotify[["genres"]]

# This section of code will get the albums of an artist 
# This part is a bit weird because Spotify may have multiple different IDs
# for one album so you could end up with multiple of the same album in a dataset
uri.artist.album.spotify <- paste0(uri.artist.spotify, "/albums")
response.albums.spotify <- GET(uri.artist.album.spotify)
body.album.spotify <- content(response.albums.spotify, "text")
data.album.spotify <- fromJSON(body.album.spotify)
results.album.spotify <- data.album.spotify$items
