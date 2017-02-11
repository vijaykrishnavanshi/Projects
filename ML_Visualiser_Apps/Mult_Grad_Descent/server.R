#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
source("Helper.R")
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  dataInput<-reactive({
    inFile <- input$file
    
    validate(
      need(!is.null(inFile), "Please Upload a CSV file containing data to be visualised")
    )
    
    r=read.csv(inFile$datapath, nrows = 150)
    return(r)
  })
  output$distPlot <- renderPlot({
    
    r=dataInput()
    theta=c(0,0)
    ans=grad_desc_regression(instdf(subsetdf(r,c("x"))),r[["y"]],theta,0.1,100)
    plot(1:100,ans$jhist)
  
  })
  
})
