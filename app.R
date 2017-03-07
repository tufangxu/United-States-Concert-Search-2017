
library(httr)
library(jsonlite)

getCurrentLocation <- function() {
  google.key <- "AIzaSyC5I1rQ5lsm_NFBiFWz398ryJYl-eq5p-Y"
  base.uri <- "https://www.googleapis.com/geolocation/v1/geolocate?key="
  uri <- paste0(base.uri, google.key)
  response <- POST(uri)
  body <- fromJSON(content(response, "text"))
  location <- as.data.frame(body) %>% 
    select(long = location.lng, lat = location.lat)
  return(location)
}


insertRow <- function(existingDF, newrow, r) {
  existingDF[seq(r+1,nrow(existingDF)+1),] <- existingDF[seq(r,nrow(existingDF)),]
  existingDF[r,] <- newrow
  existingDF
}
