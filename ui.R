library(shiny)
library(httr)
library(jsonlite)
library(V8)
library(leaflet)
library(dplyr)
library(ggplot2)
library(htmltools)

ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.css"),
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.Default.css"),
  includeCSS("style.css"),
  includeScript("Leaflet.markercluster-1.0.3/dist/leaflet.markercluster.js"),
  
  leafletOutput("map", width = "100%", height = "100%"),
  
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = F, top = 0, left = "auto", right = 0, bottom = "auto",
                width = "auto", height = "100%", 
                h1("Best Band of 2017"),
                selectInput(
                  'map.style',
                  "Choose your map style:",
                  list(
                    NASAGIBS.ViirsEarthAtNight2012 = providers$NASAGIBS.ViirsEarthAtNight2012,
                    Esri.WorldGrayCanvas = providers$Esri.WorldGrayCanvas,
                    CartoDB.Positron = providers$CartoDB.Positron,
                    Hydda.Full = providers$Hydda.Full,
                    Esri.WorldImagery = providers$Esri.WorldImagery
                  ),
                  selected = providers$Esri.WorldGrayCanvas
                ),
                
                textInput(
                'search.input',
                'Enter Your Favorite Artist Name',
                value = "Justin Bieber"
                ),
                actionButton("go", "Go"),
                
                dateRangeInput('dateRange',
                               label = 'Date range input:',
                               start = Sys.Date(), end = Sys.Date() + 365
                ),
                
                checkboxInput(
                  'timeline',
                  'Show the time line',
                  F
                ),
                downloadButton('downloadData', 'Download Concert Information'),
                
                
                h5(id = "words", "Designed by Nathan Magdalera, Shelley Tsui,"),
                h5(" Tufang Xu, and Zegang Cheng."),
                h6("University of Washington"),
                h6("INFO 201, Winter Quarter, 2017")
                )

)
