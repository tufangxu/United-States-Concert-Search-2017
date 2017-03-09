library(shiny)
library(httr)
library(jsonlite)
library(knitr)
library(V8)
library(leaflet)
library(dplyr)
library(ggplot2)
library(htmltools)

# ui representing how the page will look and the contents of the page
ui <- bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.css"),
  includeCSS("Leaflet.markercluster-1.0.3/dist/MarkerCluster.Default.css"),
  includeCSS("style.css"),
  includeScript("Leaflet.markercluster-1.0.3/dist/leaflet.markercluster.js"),
  
  # Depicts how map will look on the page
  leafletOutput("map", width = "100%", height = "100%"),
  
  # Determines contents and placing of panel on the page
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = F, top = 0, left = 60, right = "auto", bottom = "auto",
                width = 275, height = "100%", 
                h1("Best Band of 2017"),
                selectInput(
                  'map.style',
                  "Choose your map style:",
                  list(
                    "Plain Gray" = providers$Esri.WorldGrayCanvas,
                    "States" = providers$CartoDB.Positron,
                    "Cities" = providers$Hydda.Full
                  ),
                  selected = providers$Esri.WorldGrayCanvas
                ),
                
                textInput(
                'search.input',
                'Enter Your Favorite Artist Name',
                value = ""
                ),
                
                textOutput('results'),
                h3(" "),
                # Represents search button
                actionButton("go", "Search"),
                
                # Date range input that goes from the current date to a year later
                dateRangeInput('dateRange',
                               label = 'Date range input:',
                               start = Sys.Date(), end = Sys.Date() + 365
                ),

                #downloadButton('downloadData', 'Download Concert Information'),
                
                # Brief description of people who worked on project
                h5(id = "words", "Designed by Nathan Magdalera, Shelley Tsui,"),
                h5(" Tufang Xu, and Zegang Cheng."),
                h6("University of Washington"),
                h6("INFO 201, Winter Quarter, 2017"),
                h3(""),
                h6("Best Band of 2K17 powered by JamBase"),
                h6(a("http://developer.jambase.com/", 
                     href="http://developer.jambase.com/", 
                     target="_blank"))
                )

)
