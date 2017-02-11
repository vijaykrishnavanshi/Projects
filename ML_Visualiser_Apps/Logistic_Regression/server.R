#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  dataInput<-reactive({
    inFile <- input$file
    validate(
      need(!is.null(inFile), "")
    )
    r=read.csv(inFile$datapath, nrows = 150)
    return(r)
  })
  output$list_input<-renderUI({
    if (is.null(input$file))
      return()
    radioButtons(
      "inputs", "Features",
      choices = names(dataInput()),
      selected=names(dataInput())[1]
    )
  })
  output$list_response<-renderUI({
    if (is.null(input$file))
      return()
    
    radioButtons(
      "response", "Response",
      choices = names(dataInput()),
      selected=names(dataInput())[2]
    )
  })
  output$num_iters<-renderUI({
    if(is.null(input$file))
      return()
    sliderInput(
      "num_iter","No. of Iterations",
      min = 0,
      max = 100,
      value = 10
      )
  })
  output$alpha <- renderUI({
    if(is.null(input$file))
      return()
    sliderInput(
      "alpha","Learning Step",
      min = 0.001,
      max = 3.001,
      value = 1.500,
      step = 0.001
      )
  })
})
