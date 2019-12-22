library(readtext)
library(ggplot2)

library(tidyverse)
library(tidyquant)

library(reshape2)

main_url <- "https://www.quandl.com/api/v3/datasets/WIKI/"
api_key <- readtext('secrets.txt')$text

server <- function(input, output, session) {
    
    # Fetch data from Quandl API.
    eod_data <- reactive(read.csv(paste(main_url, input$company_code, '/data.csv?api_key=', api_key,
                               sep='')))
    
    # Display raw data.
    output$company_eod <- renderTable(eod_data())
    
    # Generate Candle-Stick chart.
    output$eod_plot <- renderPlot(eod_data() %>%
                                    ggplot(aes(x=Date, y=Close)) +
                                    geom_candlestick(aes(open=Open, high=High, low=Low, close=Close)) +
                                    theme_tq())
    
    # Descriptive Statistics.
    output$summary_title <- renderText(paste('Descriptive statistics for', input$company_code))
    output$summary <- renderPrint({summary(eod_data()[, c('Open', 'Close', 'High', 'Low')])})
    output$summary_first <- renderPlot(ggplot(eod_data(), aes(x=Date, y=Close, group=1)) +
                                         geom_line() +
                                         geom_ma(ma_fun=SMA, n=100, linetype='solid',
                                                 color='red', size=1))
    output$summary_second <- renderPlot(ggplot(melt(eod_data()[ ,c('Open', 'Close', 'High', 'Low')]), 
                                              aes(variable, value)) +
                                         geom_boxplot())
        
  
}
