
library(markdown)
library(httr)
library(jsonlite)
library(dplyr)
library(shiny)
library(leaflet)


# base.uri.spotify <- "https://api.spotify.com"
# spotify.search <- "v1/search"
# uri.spotify <- paste0(base.uri.spotify, spotify.search)


key.jambase <- "vbtqtqkcmhp5w8bbx4f5999m"



content <- paste(results.venue.location$Name, results.venue.location$Address, results.venue.location$City, results.venue.location$State)

ui <- navbarPage(strong("Concert Listings!"),
                 tabPanel("View Concerts",
                          sidebarLayout(
                            sidebarPanel(
                              textInput(
                                "search.input",
                                "Search:"
                              ),
                              textOutput("zipcode")
                            ),
                            mainPanel(
                              #htmlOutput("summary")
                              leafletOutput("map")
                              
                            )
                          )
                          ),
                 tabPanel("List Concerts",
                          dataTableOutput("concertlist")),
                 tabPanel("About", includeMarkdown("ABOUT.md"),
                          img(src = "jambase140x70.gif", align = "bottom")),
                 theme = "bootstrap.css"
                 )
