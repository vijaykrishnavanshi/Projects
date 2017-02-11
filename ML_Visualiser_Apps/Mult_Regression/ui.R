#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput("file", label = h3("File input")),
      uiOutput("splitInput"),
      uiOutput("uiv"),
      uiOutput("uir"),
      uiOutput("linesr")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Tab 1", ""),
        tabPanel("Tab 2", tableOutput("viewTestSet"))
      ),
     
       plotOutput("residPlot"),
       br(),br(),
       verbatimTextOutput("residTab"),
       textOutput("errors"),
       br(),br(),
       tableOutput("coeff")
    )
  )
))
