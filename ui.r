library(shiny)

# Grid layout dimensions
sidebar = 3
main_panel = 12 - sidebar

# Main panel tab for Candle-Stick plot
plot_tab <- tabPanel('Plot', h4(textOutput('plot_title')), plotOutput('eod_plot'))

# Main Panel tab for descriptive statistics.
summary_tab <- tabPanel('Summary',
                        h4(textOutput('summary_title')),
                        fluidRow(
                          column(main_panel, verbatimTextOutput('summary'))
                        ),
                        
                        fluidRow(
                          column(main_panel, plotOutput('summary_first'))
                        ))

# Main Panel tab for raw data.
table_tab <- tabPanel('Table', tableOutput('company_eod'))


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
                  plot_tab,
                  summary_tab,
                  table_tab)
    )
  ),
  
)

