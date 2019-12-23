library(shiny)

source('main_panel.r')

ui <- fluidPage(
  
  titlePanel('Stock Market - EOD Analysis.'),
  hr(),
  
  fluidRow(
    
    column(sidebar_width, h4('Select Company:'),
      textInput(inputId='company_code', 
                label='Company Code', 
                value='GOOG'),
      
      dateRangeInput(inputId = 'date_range', label = 'Select Range of data:'),
      
      submitButton('Submit')
      ),
    
    column(main_panel_width,
      tabsetPanel(type='tabs',
                  plot_tab,
                  summary_tab,
                  table_tab)
    )
  )
)

