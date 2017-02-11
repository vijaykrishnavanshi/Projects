library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Logistic Regression "),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", label = h3("File input")), 
      uiOutput("list_input"),
      uiOutput("list_response"),
      uiOutput("num_iters"),
      uiOutput("alpha"),
      uiOutput("degree_ui")
    ),
    
    mainPanel(
      navbarPage(
        title="Logistic Regression",
        tabPanel("Plot Fitted",plotOutput("Plot1")),
        tabPanel("Plot Fit - Residual",plotOutput("Plot2")),
        tabPanel("Summary - Coefficients",tableOutput("summary"))
      )
    )
  )
))
