### Application name : CA1 B9DA101 - Statistics for Data Analytics
### Course : MSc (Data Analytics) - Sep 2019 - Group A 
### Developed by : Koyel Saha (10521711) / Monil Modi (10521306) / Parth Thakur (10520930)
### College : Dublin Business School 
### URL : https://parth-thakur.shinyapps.io/EOD_Analysis/


library(shiny)

# Grid layout dimensions
sidebar_width = 3
main_panel_width = 12 - sidebar_width

# Main panel tab for Candle-Stick plot
plot_tab <- tabPanel('Plot', h4(textOutput('plot_title')), plotOutput('eod_plot'),
                       HTML('Company code refers to NASDAQ symbols and can be found at: <a href=\'http://eoddata.com/stocklist/NASDAQ/F.htm\'> EOD Stock list </a> <br>
                             Press the \'Submit\' button to start the app.')
                     )


####>>>>BEGIN>>>> Monil Modi (10521306) >>>>

# Main Panel tab for descriptive statistics.
summary_tab <- tabPanel('Summary',
                        h4(textOutput('summary_title')),
                        fluidRow(
                          column(main_panel_width, verbatimTextOutput('summary'))
                        ),
                        
                        fluidRow(
                          column(main_panel_width, plotOutput('summary_first'))
                        ),
                        
                        fluidRow(
                          column(main_panel_width, plotOutput('summary_second'))
                        ),
                        
                        fluidRow((
                          column(main_panel_width,
                                 h4('Distribution of Volume:'),
                                 plotOutput('summary_third'))
                        ),
                        
                        fluidRow(
                          column(main_panel_width, 
                                 h4('Distribution of Closing Price:'),
                                 plotOutput('summary_fourth'))
                        )))

# Main Panel tab for raw data.
table_tab <- tabPanel('Table', tableOutput('company_eod'))

####<<<<END<<<< Monil Modi (10521306) <<<<

####>>>>BEGIN>>>> Parth Thakur (10520930) >>>>

# Main Panel tab for hypothesis testing.
hypothesis_tab <- tabPanel('Hypothesis Test',
                           h2('There Exists a month where volatility is different than the rest.'),
                           HTML('<h4>H<sub>0</sub>: Volatility is consistent in all months. <br>'),
                           HTML('H<sub>1</sub>: A certain month has higher or lower volatility. </h4><br>'),
                           HTML('<p> Mathematically: <br>
                                 H<sub>0</sub>: \u03bc = \u03bc<sub>0</sub> <br>
                                 h<sub>1</sub>: \u03bc \u2260 \u03bc<sub>0</sub>'),
                           br(),
                           p('Many people believe in the "Sell in May and go away" saying. Does this hold true for the stock currently in consideration?
                              We test this by finding out if a month exists where the stock experiences high volatility. If that month is May, the saying holds true.
                              Others believe in the October effect, the January effect, etc. These effects will also be tested.'),
                           HTML('<h3>Monthly normalised volume for given company: </h3>
                                <p>The spikes observed are relatively high periods of trading. Notice the spike in 2008 due to the financial crises. <br></p>'),
                           plotOutput(outputId = 'monthly_normalised'),
                           HTML('We need an Avegare Monthly Volatility Ranking (AVMR). <br>
                              AVMR is calculated by the following steps: <br>
                                1. Group the dataset by Month for each year. <br>
                                2. Calculate the average close price for each month. <br>
                                3. Rank each month from 1 to 12 based on the average close price. <br>
                                4. Group this dataset by month. <br>
                                5. Calculate average rank of each month. <br>
                               <br>
                              This average rank is the AVMR.'),
                           h3('Average Monthly Volatility Ranking:'),
                           plotOutput(outputId = 'volatility_ranking'),
                           
                           h3('Test of hypothesis:'),
                           htmlOutput(outputId = 'hypothesis_test')
                           )
####<<<<END<<<< Parth Thakur (10520930) <<<<

####>>>>BEGIN>>>> Koyel Saha (10521711) >>>>

glm_tab <- tabPanel('GLM',
                    h2('GLM Model'),
                    h4('Summary of the model generated:'),
                    verbatimTextOutput(outputId = 'glm_first'),
                    h4('Predicted and Actual value plot together:'),
                    plotOutput(outputId = 'glm_second'))

####<<<<END<<<< Koyel Saha (10521711) <<<<