
library(shiny)
source("helper.R")
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
  
  splitData<-reactive({
    x<-dataInput()
    if(!is.null(input$response) | !is.null(input$feature))
    {
      z<-x[,c(input$response,c(input$feature))]
    }
    else
      z=x
    print(input$splitRatio)
    return(splitdf(z,seed=123,input$splitRatio/100.))
  })
  
  fitModel <- reactive({
    y   <- splitData()
    lm(y$trainset)
  })
  
  
  output$splitInput<-renderUI({
    if (is.null(input$file))
      return()
    numericInput("splitRatio","% of data as training set : ",min = 10,max = 90,step=0.1,value=80)
  })  
  
  output$linesr <- renderUI({
    if (is.null(input$file))
      return()
    
    radioButtons(
      "lin", "Do you Want Lines in you Residual Plot :  ",
      choices = c("Yes","No"),
      selected="Yes"
    )
  })
  
  output$uir <- renderUI({
    if (is.null(input$file))
      return()
    
    radioButtons(
      "response", "Response (Select only which is not used as Input) ",
      choices = names(dataInput()),
      selected=names(dataInput())[1]
    )
  })
  output$uiv <- renderUI({
    if (is.null(input$file))
      return()
    checkboxGroupInput(
      "feature", "Feature",
      choices = names(dataInput()),
      selected=names(dataInput())[2]
    )
  })
  
  output$residPlot<-renderPlot({
    x<-splitData()
    r<-fitModel()
    n=dim(x$trainset)[1]
    plot(1:n,residuals(r),main="Residual Plots of each Data Point",xlab="Data Point",ylab="Residuals")
    abline(h=0)
    if(input$lin=="Yes")
    {
      for(i in 1:n)
      {
        lines(x=c(i,i),y=c(residuals(r)[i],0))
      }
    }
  })
  output$residTab<-renderText({
    r<-fitModel()
    summary(summary(r)$residuals)
  })
  output$errors<-renderText({
    s<-splitData()
    r<-fitModel()
    print(paste0("RMSE Test : ",rmse(r,s$testset,input$response),"\n\nRMSE Train : ",rmse(r,s$trainset,input$response)))
  })
  output$coeff<-renderTable({
    r<-fitModel()
    summary(r)$coefficients
  })
  output$viewTrainingSet<-renderTable({
    splitData()$trainset
  })
  output$viewTestSet<-renderTable({
    splitData()$testset
  })
})
