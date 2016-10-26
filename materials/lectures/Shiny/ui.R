library(shiny)

shinyUI(fluidPage(
  titlePanel("StockVis"),
  sidebarLayout(sidebarPanel(
                  helpText("Choose stock symbol"),
                  textInput("symb", "Symbol", "SPY"),
                  dateRangeInput("dates", "Date range",
                                 start="2013-01-01",
                                 end=as.character(Sys.Date())),
                  br(),
                  br(),
                  
                  checkboxInput("log", "Plot y axis on log scale", value=FALSE)),
                mainPanel(plotOutput("plot"))
  )
))