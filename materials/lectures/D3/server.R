# a simple example with rCharts and Shiny
# https://github.com/ramnathv/rCharts
library(shiny)
library(rCharts)
library(gapminder)
library(dplyr)

shinyServer(function(input, output) {
  output$myChart <- renderChart({
    facet <- if(input$continent) {
      "continent"
    } else {
      NULL
    }
    
    p1 <- gapminder %>%
      filter(year == input$year) %>%
      rPlot(input$x, "lifeExp", data=., type="point", facet=facet)
    p1$addParams(dom = "myChart")
    return(p1)
  })
})
