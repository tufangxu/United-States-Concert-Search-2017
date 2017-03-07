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
        value = "Enter Artist's Name"
      ),
      dateRangeInput('date', label = "Concert Date Range:", start = date(),
                   format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                     language = "en", separator = " to ")
      
    ),
    mainPanel(
      htmlOutput("summary"),
      plotOutput("map"),
      tableOutput("table")
    )
  )
)

