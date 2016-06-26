library(shiny)

shinyServer(function(input, output) {
  dataInput<-reactive({
    inFile <- input$file
    validate(
      need(!is.null(inFile), "")
    )
    r=read.csv(inFile$datapath, nrows = 150)
    return(r)
  })
  fitted_model<-reactive({
    if(is.null(input$degree)|is.null(input$response)|is.null(input$variable))
      return()
    data=dataInput()
    res=input$response
    tar=input$variable
    deg=input$degree
    m=lm(data[[res]]~poly(data[[tar]],deg))
    return(m)
  })
  
  output$list_response<-renderUI({
    if (is.null(input$file))
      return()
    
    radioButtons(
      "response", "Response",
      choices = names(dataInput()),
      selected=names(dataInput())[1]
    )
  })
  
  output$list_input<-renderUI({
    if (is.null(input$file))
      return()
    
    radioButtons(
      "variable", "Feature",
      choices = names(dataInput()),
      selected=names(dataInput())[2]
    )
    })

  output$degree_ui<-renderUI({
    if (is.null(input$file))
      return()
    
    sliderInput("degree",
                "Degree of polynomial you want to fit : ",
                max = 5,
                min = 1,
                value= 2
                )
  })
  output$Plot2 <- renderPlot({
    if (is.null(input$file) | is.null(input$degree))
      return()
    f_model=fitted_model()
    plot(f_model,1)
    
  })
  output$summary <- renderTable({
    if (is.null(input$file) | is.null(input$degree))
      return()
    f_model=fitted_model()
    summary(f_model)$coefficients
  })
  output$Plot1 <- renderPlot({
    if (is.null(input$file) | is.null(input$degree))
      return()
    
    f_model=fitted_model()
    plot(dataInput()[[input$variable]],fitted.values(f_model),type = 'l')
  })
  
})
