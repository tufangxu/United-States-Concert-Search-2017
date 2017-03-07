library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(shiny)
 
ui <- fluidPage( 
  titlePanel(
    h1('Best Band of 2017'),
    windowTitle = "Find Concerts Near You"
    
  ),
  sidebarLayout( 
    sidebarPanel(
      textInput(
        'search.input',
        'Find Concerts Nearby:',
        value = "Enter A Zip Code"
      ),
      selectInput("concert", "Select Your Favorite Concert Information:", choice = "u")
      
    ), 
    
    mainPanel(
      htmlOutput("summary"),
      plotOutput("map"),
      tableOutput("table")
    )
  )
)
