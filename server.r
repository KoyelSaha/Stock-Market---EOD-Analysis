library(readtext)
library(ggplot2)

library(tidyverse)
library(tidyquant)

main_url <- "https://www.quandl.com/api/v3/datasets/WIKI/"
api_key <- readtext('secrets.txt')$text

server <- function(input, output, session) {
    
    eod_data <- reactive(read.csv(paste(main_url, input$company_code, '/data.csv?api_key=', api_key,
                               sep='')))
    
    output$company_eod <- renderTable(eod_data())
    
    output$summary <- renderPrint({summary(eod_data()[, c('Open', 'Close', 'High', 'Low')]
                                           )})

    output$eod_plot <- renderPlot(eod_data() %>%
                                    ggplot(aes(x=Date, y=Close)) +
                                    geom_candlestick(aes(open=Open, high=High, low=Low, close=Close)) +
                                    theme_tq())
  
}
