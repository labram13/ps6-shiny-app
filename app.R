library(tidyverse)
library(shiny)


uah <- read_delim("Student Loan Debt by School 2020-2021.csv")

ui <- fluidPage(
  titlePanel("PS06 Problem Set"), 
  tabsetPanel(type = "tabs",
              tabPanel("General Information",
                       sidebarLayout(
                         sidebarPanel (strong("Data Description:"),
                                       tags$p(
                                         HTML("In this data set created by <em>Andy Kriebel</em>,
                              we look at loans taken out by students from 
                              various univerisities and colleges from the 
                              year/term from 2020-2021. The dataset was created
                              and published on Kaggle, a subsidiary of 
                              <strong>Google</strong>, where users publish 
                              all types of data in a data-science environment."),
                                         p(),
                                         tags$p(
                                           HTML("This dataset contains", nrow(uah), 
                                           "<strong>rows</strong> and", ncol(uah), 
                                           "<strong>columns</strong>.")),
                                         p("Here is a table of a few sample data
                                           to understand how the dataset is 
                                           sorted out."),
                                         p(),
                                         p("As you can see, the data is sorted by
                                           school. Each school then shows different
                                           column variables such as type of loan,
                                           number of loans disbursed, how much
                                           was given out, etc.")
                                       )
                         ),
                         mainPanel(
                           dataTableOutput("sample")
                         )
                       )
              ),
              tabPanel("Plot")
  )
)

server <- function(input, output) {
  output$sample <- renderDataTable({
    uah %>% 
      head(5)
  })
  
}

shinyApp(ui = ui, server = server)
