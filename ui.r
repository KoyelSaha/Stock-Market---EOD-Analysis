library(shiny)
library(Quandl)
library(rjson)


ui <- fluidPage(
  
  titlePanel('Stock Market - EOD Analysis.'),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput(inputId='company_code', 
                label='Company Code', 
                value='GOOG'),
      
      submitButton('Submit')
    ),
    
    mainPanel(
      tabsetPanel(type='tabs',
                  tabPanel('Plot', plotOutput('eod_plot')),
                  tabPanel('Summary', verbatimTextOutput('summary')),
                  tabPanel('Table', tableOutput('company_eod')))
    )
  ),
  
)
