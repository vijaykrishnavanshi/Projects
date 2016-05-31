
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
  fitModel <- reactive({
    x    <- dataInput()
    if (is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(r)|is.null(x))
      return()
    lm(x[[input$response]][1:input$rowcount]~x[[input$variable]][1:input$rowcount])
  })

  output$rows<-renderUI({
    if (is.null(input$file))
      return()
    sliderInput("rowcount","Data Points to be used : ",min = 10,max = dim(dataInput())[1],value=10)
  })  
  output$uir <- renderUI({
    if (is.null(input$file))
      return()
    
    # Depending on input$input_type, we'll generate a different
    # UI component and send it to the client.
    radioButtons(
                        "response", "Response",
                        choices = names(dataInput()),
                        selected=names(dataInput())[1]
                      )
  })
  output$uiv <- renderUI({
    if (is.null(input$file))
      return()
    
    # Depending on input$input_type, we'll generate a different
    # UI component and send it to the client.
    radioButtons(
      "variable", "Feature",
      choices = names(dataInput()),
      selected=names(dataInput())[2]
    )
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
  output$dslider <- renderUI({
    if (is.null(input$file))
      return()
    x    <- dataInput()
    if (is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(x))
      return()
    sliderInput("ranger",
                "Range - Response",
                min = ceiling(min(x[[input$response]])),
                max = floor(max(x[[input$response]])),
                value = c(ceiling(min(x[[input$response]])),floor(max(x[[input$response]]))))
  })
  output$dslider2 <- renderUI({
    if (is.null(input$file))
      return()
    x    <- dataInput()
    if (is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(x))
      return()
    sliderInput("rangev",
                "Range - Input",
                min = ceiling(min(x[[input$variable]])),
                max = floor(max(x[[input$variable]])),
                value = c(ceiling(min(x[[input$variable]])),floor(max(x[[input$variable]]))))
  })
  output$distPlot <- renderPlot({
    x<-dataInput()
    # generate bins based on input$bins from ui.R
    r<-fitModel()
    if (is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(r)|is.null(x))
      return()
    plot(x[[input$variable]][1:input$rowcount],x[[input$response]][1:input$rowcount],ylim=c(input$ranger[1],input$ranger[2]),xlim=c(input$rangev[1],input$rangev[2]),xlab="Input",ylab="Response",main="Linear Fitted Model")
    abline(r)
  })
  output$coff<-renderPlot({
    x<-dataInput()
    r<-fitModel()
    if (is.null(x)|is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(r)|is.null(x))
      return()
    Feature=x[[input$variable]][1:input$rowcount]
    plot(Feature,residuals(r),main="Plots",xlim=c(input$rangev[1],input$rangev[2]))
    abline(h=0)
    n=length(Feature)
    if(input$lin=="Yes")
    {
    for(i in 1:n)
    {
      lines(x=c(Feature[i],Feature[i]),y=c(residuals(r)[i],0))
    }
    }
  })
  output$coeftable<-renderTable({
    r<-fitModel()
    if (is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(r))
      return()
    summary(r)$coefficients
  })
  output$coeff<-renderText({
    x<-dataInput()
    r<-fitModel()
    if (is.null(input$variable)|is.null(input$rowcount)|is.null(input$response)|is.null(r)|is.null(x))
      return()
    p=coefficients(r)
    print(paste("Correlation : ",cor(x[[input$response]][1:input$rowcount],x[[input$variable]][1:input$rowcount])))
  })
  
})
