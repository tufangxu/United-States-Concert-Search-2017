library(shiny)
library(httr)
library(jsonlite)
library(V8)
library(leaflet)
library(dplyr)
library(ggplot2)
library(htmltools)

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

# Variable representing base URI for API usage
base.uri.jambase <- "http://api.jambase.com"

# Variable function that gets the artist ID from the jambase API and returns it to wherever it is called
getArtistID <- function(artist.name) {
  key1.jambase <- sample(keys, 1) # Gets a random key from API vector
  resource.artist.jambase <- "/artists"
  uri.artist.jambase <- paste0(base.uri.jambase, resource.artist.jambase)
  
  # Query to be used for artists search
  query.artist.jambase <- list(name = artist.name, api_key = key1.jambase, o = "json")
  response.artist.jambase <- GET(uri.artist.jambase, query = query.artist.jambase)
  body.artist.jambase <- content(response.artist.jambase, "text")
  data.artist.jambase <- fromJSON(body.artist.jambase)
  results.artist.jambase <- data.artist.jambase$Artists
  
  # Selects first appearing result from dataframe
  results.artist.id.jambase <- results.artist.jambase$Id[[1]]
  return(results.artist.id.jambase)
}

# Variable function that gets the events that the artist will have
getVenue <- function(artist.name) {
  key2.jambase <- sample(keys2, 1) # Gets a random key from API vector
  
  # Calls getArtistID function to get the ID of desired artist
  results.artist.id.jambase <- getArtistID(artist.name)
  resource.venue.jambase <- "/events"
  uri.venue.jambase <- paste0(base.uri.jambase, resource.venue.jambase)
  
  # Query to search through events 
  query.venue.jambase <- list(artistID = results.artist.id.jambase, api_key = key2.jambase, o = "json")
  
  if (is.null(query.venue.jambase$artistID)) {
    return("NULL")
  }
  
  response.venue.jambase <- GET(uri.venue.jambase, query = query.venue.jambase)
  data.venue.jambase <- fromJSON(content(response.venue.jambase, "text"))
  
  # Dataframe of results
  results.venue.jambase <- as.data.frame(data.venue.jambase$Events)
  
  # Returns null if there are no events happening
  if(nrow(results.venue.jambase) == 0) {
    return("NULL")
  }
  
  relevant.results.venue.jambase <- results.venue.jambase$Venue
  date.venue.jambase <- results.venue.jambase$Date
  relevant.results.venue.jambase <- mutate(relevant.results.venue.jambase, date = 
                                             date.venue.jambase)
  
  # Variable that filters out lat and long coords that are 0 and any locations not within the US
  us.results.venue.jambase <- relevant.results.venue.jambase %>% 
    filter(Country == "US") %>%
    filter(Latitude != 0) %>% filter(Longitude != 0) 
  
  us.results.venue.jambase <- unique(us.results.venue.jambase)
  return(us.results.venue.jambase)
}

server <- function(input, output) {
  
  # Renders map with artist locations whenever prompted to
  output$map <- renderLeaflet({
    input$go
    artist <- isolate(input$search.input)
    
    # Renders map with desired style
    m <- leaflet(options = leafletOptions(minZoom = 2)) %>%
      setView(lng = -100, lat = 37, zoom = 5) %>% 
      setMaxBounds(-180, -180, 180, 180) %>% 
      addProviderTiles(input$map.style)
    
    # If artist doesn't exist, map defaults to regular settings.
    if(artist == "" | is.na(artist) | is.null(artist)) {
      return(m)
    }
    
    
    # Variable representing dataframe obtained from artist
    info.concerts <- getVenue(artist)
    
    # Defaults to default settings if concert doesn't exist or artist doesn't exist
    if(info.concerts == "unspecifically name" | info.concerts == "NULL" | is.null(info.concerts)) {
      output$results <- renderText({
        return("Artist doesn't exist or no events or no events in given dates")
      })
      return(m)
    }
    
    # Variable representing concert data as a number
    info.concerts$date <- as.vector(substring(info.concerts$date, 1, 10))
    
    # Variable that changes representaive order of date
    info.concerts$date <- as.Date(info.concerts$date, "%Y-%m-%d")
    
    # Variable representing start date
    start.date <- input$dateRange[1] %>% as.character() %>% as.Date()
    
    # Variable representing end date
    end.date <- input$dateRange[2] %>% as.character() %>% as.Date()
    
    
    # Variable that adds a new column of data representing information about the concert
    info.concerts <- mutate(info.concerts, info = paste0("Date: ", date,"<br/>",
                                                         "Name: ", Name,"<br/>",
                                                         "Address: ", Address,", ", 
                                                         City,", ", State)) %>% 
      filter(is.na(date) | date > start.date & date < end.date)
    
    # If there are no dates in between the date range selected from input, returns to default map
    if (nrow(info.concerts) < 1) {
      output$results <- renderText({
        return("Artist doesn't exist or no current events or no events in given dates")
      })
      return(m)
    }  
    
    info.concerts$Name <- as.vector(info.concerts$Name)
    info.concerts$color = "blue"
    info.concerts[1, "color"] = "blue"
    
    # Checks again to see if there is dataframe is smaller than 1 row, and defaults
    # to regular map settings if so.
    if(nrow(info.concerts) < 1) {
      return(m)
    }
    
    # Variable representing icon/image to be used for locations
    icons <- awesomeIcons(
      icon = 'ios-close',
      iconColor = 'black',
      library = 'ion',
      markerColor = info.concerts$color
    )
    
    # Renders map with desired style
    m <- leaflet(data = info.concerts, options = leafletOptions(minZoom = 2)) %>%
      setView(lng = -100, lat = 37, zoom = 5) %>% 
      setMaxBounds(-180, -180, 180, 180)
    
    # Returns empty string if search worked fine
    output$results <- renderText({
      return(" ")
    })
    
    # Renders map with desired style and renders every icon
    m <- addProviderTiles(m, input$map.style) %>% 
      addAwesomeMarkers(~Longitude, ~Latitude, popup = ~info, label = ~htmlEscape(Name),
                        clusterOptions = markerClusterOptions(), icon = icons)
    return(m)
  })
  
  # Returns the initial text output for initial render
  output$results <- renderText({
    return(" ")
  })
  
  
}