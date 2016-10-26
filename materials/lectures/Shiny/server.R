library(shiny)
library(quantmod)

shinyServer(function(input, output) {
  output$plot <- renderPlot({
    data <- getSymbols(input$symb, src="yahoo",
                     auto.assign=FALSE,
                     from=input$dates[1],
                     to=input$dates[2])
    
    chartSeries(data, theme=chartTheme("white"), type="line", TA=NULL,
                log.scale=input$log)
  })
})