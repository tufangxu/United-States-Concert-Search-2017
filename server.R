

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
    
    
    #info.concerts <- read.csv("infomation.csv")
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
  
  # make the date range reactive in #yyyy-mm-dd format
  
  output$downloadData <- downloadHandler(
    filename = "infomation.csv",
    content = function(file) {
      write.csv(info.concerts, file)
    }
  ) 
  
}


