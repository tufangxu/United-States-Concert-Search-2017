library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)

ui <- fluidPage(

  titlePanel(
    h1('Best Band of 2017'),
    windowTitle = "Your most recent Concerts"
    
  ),
  sidebarLayout( 
    sidebarPanel(id = "sidebar",
      textInput(
        'search.input',
        'Enter Your Favorite Artist Name',
        value = "Artist"
      ),
      dateRangeInput('date', label = "Concert Date Range:", start = date(),
                   format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                     language = "en", separator = " to "),
      downloadButton('downloadData', 'Download Concert Information')
      
      ),
    
  mainPanel(style="position:fixed;margin-left:32vw;",
    htmlOutput("summary"),
    plotOutput("map"),
    tableOutput("table")
  ),
  position = c("left","right"),
  fluid = T
 )
)


