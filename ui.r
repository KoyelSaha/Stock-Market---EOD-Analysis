library(shiny)
library(Quandl)
library(rjson)


ui <- fluidPage(
  
  titlePanel('Stock Market - EOD Analysis.'),
  hr(),
  
  fluidRow(
    
    column(3, h4('Select Company:'),
      textInput(inputId='company_code', 
                label='Company Code', 
                value='GOOG'),
      
      submitButton('Submit')
      ),
    
    column(12-3,
      tabsetPanel(type='tabs',
                  tabPanel('Plot', plotOutput('eod_plot')),
                  tabPanel('Summary', verbatimTextOutput('summary')),
                  tabPanel('Table', tableOutput('company_eod')))
    )
  ),
  
)
