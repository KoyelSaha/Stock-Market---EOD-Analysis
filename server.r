library(readtext)
library(ggplot2)

library(tidyverse)
library(tidyquant)

library(reshape2)

library(dplyr)

source('helpers.r')

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
    
    output$summary_first <- renderPlot(ggplot(eod_subset(), aes(x=Date, y=Adj..Close, group=1)) +
                                         geom_line() +
                                         geom_ma(ma_fun=SMA, n=100, linetype='solid', color='red', size=1) +
                                         labs(x = '',
                                              y = 'Adjusted Closing price'))
                                       
    output$summary_second <- renderPlot(ggplot(melt(eod_subset()[ ,c('Open', 'Close', 'High', 'Low')]), 
                                               aes(variable, value)) +
                                          geom_boxplot() +
                                          labs(y = ''))
    
    output$summary_third <- renderPlot(ggplot(eod_subset(), aes(x = Volume)) +
                                          geom_histogram(bins = 300, fill = "red") +
                                          scale_x_log10() +
                                          theme(panel.background = element_rect(fill = 'light blue', colour = 'black')))
    
    output$summary_fourth <- renderPlot(ggplot(eod_subset(), aes(x = Close)) +
                                          geom_histogram(bins = 300, fill = "red") +
                                          scale_x_log10() +
                                          theme(panel.background = element_rect(fill = 'light blue', colour = 'black')))
    
    # Hypothesis Testing:
    final <- reactive(get_final(eod_data()))
    final_2 <- reactive(get_final_2(final()))
    
    mean_rank <- reactive(mean(final_2()$rank_average))
    
    output$monthly_normalised <- renderPlot(ggplot(final(), aes(x = date, y = average, group = 1)) +
                                              geom_line() +
                                              theme(axis.line = element_line(colour = "black"),
                                                    panel.grid.major = element_blank(),
                                                    panel.grid.minor = element_blank(),
                                                    panel.border = element_blank(),
                                                    panel.background = element_blank(),
                                                    legend.position = 'none') +
                                              labs(x = '',
                                                   y = ''))
                                            
    output$volatility_ranking <- renderPlot(ggplot(final_2(), aes(x=Month_, y=rank_average)) +
                                              geom_bar(aes(fill = max_dev), stat = 'identity') +
                                              geom_label(aes(label = round(rank_average, 2)), y = 1) +
                                              labs(x = 'Month',
                                                   y = 'Average rank') +
                                              theme(axis.line = element_line(colour = "black"),
                                                    panel.grid.major = element_blank(),
                                                    panel.grid.minor = element_blank(),
                                                    panel.border = element_blank(),
                                                    panel.background = element_blank(),
                                                    legend.position = 'none') + 
                                              scale_x_continuous(breaks = 1:12) +
                                              geom_hline(aes(yintercept = mean_rank()), color = 'blue', size = 1) +
                                              annotate('text', x = -0.9, y = mean_rank() + 0.3, label = round(mean_rank(), 2), color = 'blue', size = 5) +
                                              scale_fill_manual(values = c('#595959', 'red'))
                                            )
    
    output$hypothesis_test <- renderUI(HTML(hypothesis_result(final_2())))
    

}
