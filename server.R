library(shiny)
library(httr)
library(jsonlite)
library(V8)
library(leaflet)
library(dplyr)
library(ggplot2)
library(htmltools)

#getCurrentLocation <- function() {
#  google.key <- "AIzaSyC5I1rQ5lsm_NFBiFWz398ryJYl-eq5p-Y"
#  base.uri <- "https://www.googleapis.com/geolocation/v1/geolocate?key="
#  uri <- paste0(base.uri, google.key)
#  response <- POST(uri)
#  body <- fromJSON(content(response, "text"))
#  location <- as.data.frame(body) %>% 
#    select(Longitude = location.lng, Latitude = location.lat)
#  return(location)
#}

# Variable representing a vector of API keys
keys <- c("88erjhqbwn7jn8qmutp2j33m", "vbtqtqkcmhp5w8bbx4f5999m",
          "dfk3af5t35b77s82xwhf3s5s", "z63mttrgw9ef9xrqwyrvxbw8",
          "8rpgprp9x6zhmg8e4t2rukw6", "6ssgmhmv284qmrqmmqwhxnse",
          "6bnahwpm27pesua7ehycppxh", "7vhca48td8q4sbyfgn4m5r3j",
          "tx7hr6d2sa972suc6hujkahk", " n9e4d8n75w3mwq2aegx4qd6z")

# Variable representing a vector of spare API keys
keys1 <- c("6kttawrfk64hx4eakd3akw5d", "hwvb4wmft9jkx64m5mcwmz44",
          "95mxt475k4vzfa7azu2vdfc6", "7vhca48td8q4sbyfgn4m5r3j",
          "t4pjfp4r6hzx5hwpm2ysffq9", "mvxt9ehjyngwv6g6jhe9vjhg",
          "ymm7yw65aebbr8xbmcaq3jng", "cqvyku9hmp4s4bpnv3fsv49v")

# Variable representing a vector of spare API keys
keys2 <- c("27ye9d7m5mpepbejcxzme6pd", "wnkk6hgmqqc94cp9w6kswawq",
            "7spn9c4evr25hg3armxdgxzm", "h2mf82ty853atrzuxrq4qqh3",
           "2sc8ruvsdxcny3st7cnjn6mu", "sk6xdqchyhzgmzqdyygn9dv3",
           "mscunr5afsew9j77v4n8ackj", "2yp75kvb8c2z35k2uawc5mtv")

#Do not use the 5th key, it will be used in shinyapps.io
# key1.jambase <- keys[9]
# key2.jambase <- keys2[1]
# key.jambase <- "8qgdfttz4xd2abmbxqwrswjv" ### DO NOT USE THIS ONE ###


# 
base.uri.jambase <- "http://api.jambase.com"

# Variable function that gets the artist ID from the jambase API
getArtistID <- function(artist.name) {
  key1.jambase <- sample(keys, 1)
  resource.artist.jambase <- "/artists"
  uri.artist.jambase <- paste0(base.uri.jambase, resource.artist.jambase)
  query.artist.jambase <- list(name = artist.name, api_key = key1.jambase, o = "json")
  response.artist.jambase <- GET(uri.artist.jambase, query = query.artist.jambase)
  body.artist.jambase <- content(response.artist.jambase, "text")
  data.artist.jambase <- fromJSON(body.artist.jambase)
  results.artist.jambase <- data.artist.jambase$Artists
  results.artist.id.jambase <- results.artist.jambase$Id[[1]]
  return(results.artist.id.jambase)
}

# Variable function that gets the events that the artist will have
getVenue <- function(artist.name) {
  key2.jambase <- sample(keys2, 1)
  results.artist.id.jambase <- getArtistID(artist.name)
  resource.venue.jambase <- "/events"
  uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
  query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key2.jambase, o = "json")
  response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
  data.venue.jambase <- fromJSON(content(response.venue.jambase, "text"))
  results.venue.jambase <- as.data.frame(data.venue.jambase$Events)
  
  # Returns null if there are no events happening
  if(nrow(results.venue.jambase) == 0) {
    return(NULL)
  }
  
  relevant.results.venue.jambase <- results.venue.jambase$Venue
  date.venue.jambase <- results.venue.jambase$Date
  relevant.results.venue.jambase <- mutate(relevant.results.venue.jambase, date = 
                                          date.venue.jambase)
  us.results.venue.jambase <- relevant.results.venue.jambase %>% 
                              filter(Country == "US") %>%
                              filter(Latitude != 0) %>% filter(Longitude != 0)
  us.results.venue.jambase <- unique(us.results.venue.jambase)
  return(us.results.venue.jambase)
}


# Variable that gets the genre of an artist
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
    if(info.concerts == "unspecifically name") {
      return(m)
    }
    
    #get current location
    #problem: cannot use when hosting on a server
    
    #info.concerts[seq(2 ,nrow(info.concerts)+1),] <- info.concerts[seq(1 ,nrow(info.concerts)),]
    #info.concerts[1, ] <- NA
    #currentLocation <- getCurrentLocation()
    #info.concerts[1, "Latitude"] <- currentLocation[1, "Latitude"]
    #info.concerts[1, "Longitude"] <- currentLocation[1, "Longitude"]
  
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
    
    m <- leaflet(data = info.concerts, options = leafletOptions(minZoom = 2)) %>%
      setView(lng = -100, lat = 37, zoom = 5) %>% 
      setMaxBounds(-180, -180, 180, 180)
      
    #if(input$timeline) {
    #  m <- addPolylines(m, ~Longitude, ~Latitude, weight = 1, opacity = 1) 
    #}
      m <- addProviderTiles(m, input$map.style) %>% 
      addAwesomeMarkers(~Longitude, ~Latitude, popup = ~info, label = ~htmlEscape(Name),
                 clusterOptions = markerClusterOptions(), icon = icons)
      return(m)
    })

  
  output$downloadData <- downloadHandler(
    filename = "infomation.csv",
    content = function(file) {
      write.csv(info.concerts, file)
    }
  ) 
  
}


