library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(shiny)

ui <- fluidPage(
  titlePanel(
    h1('123'),
    windowTitle = "123"
  ),
  sidebarLayout(
    sidebarPanel(
      textInput(
        'search.input',
        'Search:'
      )
    ), 
    
    mainPanel(
      htmlOutput("summary"),
      plotOutput("map")
    )
  )
)
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)

