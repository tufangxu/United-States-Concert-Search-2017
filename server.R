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
  
  # make the date range reactive in #yyyy-mm-dd format
  date <- reactive({
    date <- input$date
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste(input$dataset, '.csv', sep='') 
    },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  ) 
  
  
}
  





