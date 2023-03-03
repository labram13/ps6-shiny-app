library(tidyverse)
library(shiny)
library(forcats)
library(viridis)

student_loans <- read_delim("Student Loan Debt by School 2020-2021.csv")

ui <- fluidPage(
  titlePanel("PS06 Problem Set"), 
  tabsetPanel(type = "tabs",
              tabPanel("General Information",
                       sidebarLayout(
                         sidebarPanel (width = "auto",
                                       h3(strong("Data Description:")),
                                       p(),
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
                                           HTML("This dataset contains", nrow(student_loans), 
                                                "<strong>rows</strong> and", ncol(student_loans), 
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
                           dataTableOutput("intro")
                         )
                       )
              ),
              tabPanel("Plot",
                       sidebarLayout(
                         sidebarPanel(h3(strong("Average Loans per State:\n")),
                                      p(),
                                      p("Here, we have calculated the average
                                        loans students have taken out (total
                                        amount divided by number of schools
                                        per state) in each state. By selecting
                                        desired states to view, the average
                                        is arranged from highest to lowest. In
                                        doing so, you are able to see which states, 
                                        in comparison, loaned the most amount
                                        of money to go to school."),
                                      p(),
                                      fluidRow(
                                        column(6,
                                               radioButtons("color", "Choose color palette!",
                                                            choices = c("A", 
                                                                        "B",
                                                                        "C",
                                                                        "D"))
                                        ),
                                        column(6,
                                               uiOutput("checkboxState")
                                        )
                                      ),
                                      p("You have selected the following states: \n"),
                                      uiOutput("selected")
                         ),
                         mainPanel(
                           plotOutput("plot"),
                           textOutput("result")
                         )
                       )
              ),
              tabPanel("Table",
                       sidebarLayout(
                         sidebarPanel(h3(strong("Table of Averages:\n")),
                                      p(),
                                      p("In this table, we manipulated the same
                                        data to calculate the averages for loans
                                        taken out per state. The difference here
                                        is it isn't organized! We've provided
                                        an option to organize the results from highest
                                        to lowest just as in the graph page.
                                        The data table is also interactable so you can 
                                        search up a certain state if you would like (
                                        use abbreviations for states).
                                        )
                                        "),
                                      uiOutput("checkboxCol"),
                                      p("The Top 10 states in the current data table are: \n"),
                                      uiOutput("top10")
                         ),
                         mainPanel(
                           dataTableOutput("table")
                         )
                       )
              )
  )
)
server <- function(input, output){
  plt <- student_loans %>% 
    filter(`Loan Type` == "Total",
           !is.na(`$ of Disbursements`),
           !is.na(State)) %>% 
    group_by(State, School) %>% 
    summarize(total_loans = max(`$ of Disbursements`)) %>% 
    group_by(State) %>% 
    reframe(avg_loan = mean(total_loans))
  output$intro <- renderDataTable({
    student_loans %>% 
      head(5)
  })
  output$checkboxState <- renderUI({
    selectizeInput(
      "State", strong("Select State or Type State abbr. e.g. WA"),
      choices =  unique(student_loans$State),
      multiple = TRUE
    )
  })
  sample <- reactive({
    plt %>% 
      filter(State %in% input$State)
  })
  output$plot <- renderPlot ({
    ggplot(data = sample()) +
      geom_col(aes(x = forcats::fct_reorder(State, desc(avg_loan)), 
                   y = avg_loan, fill = State ),
               labels =scales::comma
      ) +
      scale_y_continuous(labels = scales::comma) +
      theme(legend.position="none")+
      labs(title = "Average Loans Taken Out By Students per State",
           x = "State",
           y = "$ of Average Loans") +
      scale_fill_viridis(discrete = TRUE, option = input$color)
  })
  output$result <- renderText({
    max <- sample() %>% 
      pull(avg_loan) %>% 
      max()
    if(is.infinite(max))
      paste("Please select some states to start showing showing data.")
    else
      ""
  })
  loan_table <- reactive({
    plt  %>% 
      dplyr::arrange(dplyr::desc(!!rlang::sym(input$choose)))
  })
  output$table <- renderDataTable({
    if (is.null(input$choose)){
      plt
    } else {
      loan_table()
    }
  })
  output$checkboxCol <- renderUI({
    checkboxGroupInput(
      "choose", strong("Select to arrange from highest to lowest 
                       in Average Loans per State!"),
      choices =  c("avg_loan")
    )
  })
  output$selected <- renderUI({
    HTML(paste(input$State, sep ="<br/>"))
    })
  output$top10 <- renderText({
    if (is.null(input$choose)){
      y = plt %>% head(10)
      paste(y$State, sep=",")
    } else {
      x = loan_table()
      y = x %>% head(10)
      paste(y$State)
    }
  })
}

shinyApp(ui = ui, server = server)