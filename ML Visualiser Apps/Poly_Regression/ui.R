#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Polynomial Regression "),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", label = h3("File input")), 
      uiOutput("list_input"),
      uiOutput("list_response"),
      uiOutput("degree_ui")
    ),
    
    mainPanel(
      navbarPage(
         title="Poly Regression",
         tabPanel("Plot Fitted",plotOutput("Plot1")),
         tabPanel("Plot Fit - Residual",plotOutput("Plot2")),
         tabPanel("Summary - Coefficients",tableOutput("summary"))
      )
    )
  )
))
