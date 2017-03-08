

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
    #info.concerts <- read.csv("infomation.csv")

    if(is.null(info.concerts)) {
      return(m)
    }
    
    # Time Range Bug
    
    #info.concerts$date <- as.Date(info.concerts$date)
    #start.date <- input$date[1] %>% as.character()
    #end.date <- input$date[2] %>% as.character()
    info.concerts <- mutate(info.concerts, info = paste0("Date: ", date,"<br/>",
                                                        "Name: ", Name,"<br/>",
                                                        "Address: ", Address,", ", 
                                                        City,", ", State)) 
    #%>% 
     # filter(date > start.date & date < end.date)
    
    leaflet(data = info.concerts, options = leafletOptions(minZoom = 2)) %>%
      setView(lng = -100, lat = 37, zoom = 5) %>% 
      setMaxBounds(-180, -180, 180, 180) %>% 
      #addPolylines(~Venue.Longitude, ~Venue.Latitude, weight = 1, opacity = 0.2) %>% 
      addProviderTiles(input$map.style) %>% 
      addMarkers(~Longitude, ~Latitude, popup = ~info, label = ~htmlEscape(Name),
                 clusterOptions = markerClusterOptions())
    })
  
  
  # make the date range reactive in #yyyy-mm-dd format
  
  output$downloadData <- downloadHandler(
    filename = "infomation.csv",
    content = function(file) {
      write.csv(info.concerts, file)
    }
  ) 
  
}


