library(tidyverse)
library(shiny)


uah <- read_delim("Student Loan Debt by School 2020-2021.csv")

ui <- fluidPage(
  titlePanel("PS06 Problem Set"), 
  tabsetPanel(type = "tabs",
              tabPanel("General Information", dataTableOutput("sample"),
                       p("Hello there"))
  )
)


server <- function(input, output) {
  output$sample <- renderDataTable({
    uah %>% 
      head(3)
  })
  
}

shinyApp(ui = ui, server = server)
