library(readtext)
library(ggplot2)

library(tidyverse)
library(tidyquant)

library(reshape2)

main_url <- "https://www.quandl.com/api/v3/datasets/WIKI/"
api_key <- readtext('secrets.txt')$text

my_read_csv <- function (path) {
  df <- read.csv(path)
  df$Date <- as.Date(df$Date)
  
  return(df)
}

server <- function(input, output, session) {
    
    # Fetch data from Quandl API.
    eod_data <- reactive(my_read_csv(paste(main_url, input$company_code, '/data.csv?api_key=', api_key, sep='')))
    
    observe({
    updateDateRangeInput(session, 'date_range',
                         min = min(eod_data()$Date),
                         max = max(eod_data()$Date),
                         start = min(eod_data()$Date),
                         end = max(eod_data()$Date))
      })
    
    eod_subset <- reactive(
      {
        df <- eod_data()
        df <- subset(df, as.numeric(Date) > as.Date(input$date_range[1]))
        
        return(df)
      }
    )

    # Display raw data.
    output$company_eod <- renderTable(eod_data())
    
    # Generate Candle-Stick chart.
    output$eod_plot <- renderPlot(eod_subset() %>%
                                    ggplot(aes(x=Date, y=Close)) +
                                    geom_candlestick(aes(open=Open, high=High, low=Low, close=Close)) +
                                    theme_tq())
    
    # Descriptive Statistics.
    output$summary_title <- renderText(paste('Descriptive statistics for', input$company_code))
    output$summary <- renderPrint({summary(eod_subset()[, c('Open', 'Close', 'High', 'Low')])})
    
    output$summary_first <- renderPlot(ggplot(eod_subset(), aes(x=Date, y=Close, group=1)) +
                                         geom_line() +
                                         geom_ma(ma_fun=SMA, n=100, linetype='solid', color='red', size=1))
                                       
    output$summary_second <- renderPlot(ggplot(melt(eod_subset()[ ,c('Open', 'Close', 'High', 'Low')]), 
                                              aes(variable, value)) +
                                          geom_boxplot())
    

}
