library(shiny)
library(dplyr)
library(httr)
library(jsonlite)
library(knitr)
library(ggplot2)

server <- function(input, output) {
  # returns the artist name
  search.input <- reactive({
    zipcode <- input$search.input
  })
  
  # make the date range reactive
  date <- reactive({
    date <- input$date
  })
}
  





