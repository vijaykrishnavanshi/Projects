library(shiny)

# Define UI for application that Plots a Linear 
# relation between as response and input

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Linear Regression"),
  
  # Sidebar with a Dynamic input and a file input 
  sidebarLayout(
    sidebarPanel(
      fileInput("file", label = h3("File input")), 
      uiOutput("rows"),
      uiOutput("uiv"),
      uiOutput("uir"),
      uiOutput("dslider"),
      uiOutput("dslider2"),
      uiOutput("linesr")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       tableOutput("coeftable"),
       br(),br(),
       textOutput("coeff"),
       br(),br(),
       plotOutput("distPlot"),
       plotOutput("coff")
       
    )
  )
))
