library(shiny)
library(httr)
library(jsonlite)
library(V8)
library(leaflet)
library(dplyr)
library(ggplot2)
library(htmltools)

getCurrentLocation <- function() {
  google.key <- "AIzaSyC5I1rQ5lsm_NFBiFWz398ryJYl-eq5p-Y"
  base.uri <- "https://www.googleapis.com/geolocation/v1/geolocate?key="
  uri <- paste0(base.uri, google.key)
  response <- POST(uri)
  body <- fromJSON(content(response, "text"))
  location <- as.data.frame(body) %>% 
    select(Longitude = location.lng, Latitude = location.lat)
  return(location)
}

insertRow <- function(existingDF, newrow, r) {
  existingDF[seq(r+1,nrow(existingDF)+1),] <- existingDF[seq(r,nrow(existingDF)),]
  existingDF[r,] <- newrow
  existingDF
}


keys <- c("27ye9d7m5mpepbejcxzme6pd", "vbtqtqkcmhp5w8bbx4f5999m",
          "dfk3af5t35b77s82xwhf3s5s", "z63mttrgw9ef9xrqwyrvxbw8",
          "8rpgprp9x6zhmg8e4t2rukw6", "6ssgmhmv284qmrqmmqwhxnse")

#Do not use the 5th key, it will be used in shinyapps.io
key.jamebase <- keys[5]
# key.jambase <- "8qgdfttz4xd2abmbxqwrswjv" ### DO NOT USE THIS ONE ###

# Not a key, just an ID/secret, should still be able to obtain information about
# from spotify without a key though
# spotify.jambase <- "79db19b5259746888cc2eb93fdbbdd25"

# depending on jambase api
base.uri.jambase <- "http://api.jambase.com"



getArtistID <- function(artist.name) {
  resource.artist.jambase <- "/artists"
  uri.artist.jambase <- paste0(base.uri.jambase, resource.artist.jambase)
  query.artist.jambase <- list(name = artist.name, api_key = key.jamebase, o = "json")
  response.artist.jambase <- GET(uri.artist.jambase, query = query.artist.jambase)
  body.artist.jambase <- content(response.artist.jambase, "text")
  data.artist.jambase <- fromJSON(body.artist.jambase)
  results.artist.jambase <- data.artist.jambase$Artists
  results.artist.id.jambase <- results.artist.jambase$Id
  return(results.artist.id.jambase)
}

getVenue <- function(artist.name) {
  results.artist.id.jambase <- getArtistID(artist.name)
  resource.venue.jambase <- "/events"
  uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
  query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key.jamebase, o = "json")
  response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
  data.venue.jambase <- fromJSON(content(response.venue.jambase, "text"))
  results.venue.jambase <- as.data.frame(data.venue.jambase$Events)
  if(nrow(results.venue.jambase) == 0) {
    return(NULL)
  }
  relevant.results.venue.jambase <- results.venue.jambase$Venue
  date.venue.jambase <- results.venue.jambase$Date
  relevant.results.venue.jambase <- mutate(relevant.results.venue.jambase, date = 
                                             date.venue.jambase)
  us.results.venue.jambase <- relevant.results.venue.jambase %>% filter(Country == "US") %>%
    filter(Latitude != 0) %>% filter(Longitude != 0)
  us.results.venue.jambase <- unique(us.results.venue.jambase)
  return(us.results.venue.jambase)
}


getGenre <- function(artist.name) {
  # This section of code will find the ID of a desired artist
  base.uri.spotify <- "https://api.spotify.com"
  search.spotify <- "/v1/search"
  uri.spotify <- paste0(base.uri.spotify, search.spotify)
  # q will have to be an interactive ariable # Obtained from Jambase API
  query.spotify <- list(type = "artist", q = "Kanye West") 
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
  return(results.artist.spotify)
}


server <- function(input, output) {
  
  output$map <- renderLeaflet({
    input$go
    artist <- isolate(input$search.input)
    
    m <- leaflet(options = leafletOptions(minZoom = 2)) %>%
          setView(lng = -100, lat = 37, zoom = 5) %>% 
          setMaxBounds(-180, -180, 180, 180) %>% 
          addProviderTiles(input$map.style)
    if(artist == "" | is.na(artist) | is.null(artist)) {
      return(m)
    }
    
    
    info.concerts <- getVenue(artist)
    info.concerts[seq(2 ,nrow(info.concerts)+1),] <- info.concerts[seq(1 ,nrow(info.concerts)),]
    info.concerts[1, ] <- NA
    currentLocation <- getCurrentLocation()
    info.concerts[1, "Latitude"] <- currentLocation[1, "Latitude"]
    info.concerts[1, "Longitude"] <- currentLocation[1, "Longitude"]
  
    if(is.null(info.concerts)) {
      return(m)
    }
    
    info.concerts$date <- as.vector(substring(info.concerts$date, 1, 10))
    info.concerts$date <- as.Date(info.concerts$date, "%Y-%m-%d")
    
    start.date <- input$dateRange[1] %>% as.character() %>% as.Date()
    end.date <- input$dateRange[2] %>% as.character() %>% as.Date()
    info.concerts <- mutate(info.concerts, info = paste0("Date: ", date,"<br/>",
                                                        "Name: ", Name,"<br/>",
                                                        "Address: ", Address,", ", 
                                                        City,", ", State)) %>% 
      filter(is.na(date) | date > start.date & date < end.date)
    
    info.concerts[1, "info"] = "Current Location"
    info.concerts$Name <- as.vector(info.concerts$Name)
    info.concerts[1, "Name"] = "Current Location"
    info.concerts$color = "blue"
    info.concerts[1, "color"] = "red"
    
    if(nrow(info.concerts) < 1) {
      return(m)
    }
    
    icons <- awesomeIcons(
      icon = 'ios-close',
      iconColor = 'black',
      library = 'ion',
      markerColor = info.concerts$color
    )
    
    leaflet(data = info.concerts, options = leafletOptions(minZoom = 2)) %>%
      setView(lng = -100, lat = 37, zoom = 5) %>% 
      setMaxBounds(-180, -180, 180, 180) %>% 
      addPolylines(~Longitude, ~Latitude, weight = 1, opacity = 1) %>% 
      addProviderTiles(input$map.style) %>% 
      addAwesomeMarkers(~Longitude, ~Latitude, popup = ~info, label = ~htmlEscape(Name),
                 clusterOptions = markerClusterOptions(), icon = icons)
    })

  
  output$downloadData <- downloadHandler(
    filename = "infomation.csv",
    content = function(file) {
      write.csv(info.concerts, file)
    }
  ) 
  
}


