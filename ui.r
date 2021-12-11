### Application name : CA1 B9DA101 - Statistics for Data Analytics
### Course : MSc (Data Analytics) - Sep 2019 - Group A 
### Developed by : Koyel Saha (10521711) / Monil Modi (10521306) / Parth Thakur (10520930)
### College : Dublin Business School 
### URL : https://parth-thakur.shinyapps.io/EOD_Analysis/


library(shiny)

source('main_panel.R')

ui <- fluidPage(
  
  titlePanel('Stock Market - EOD Analysis.'),
  hr(),
  
  fluidRow(
    
    column(sidebar_width, h4('Select Company:'),
      textInput(inputId='company_code', 
                label='Enter Company Code', 
                value='GOOG'),
      
      dateRangeInput(inputId = 'date_range', label = 'Select Range of data:'),
      
      submitButton('Submit')
      ),
    
    column(main_panel_width,
      tabsetPanel(type='tabs',
                  plot_tab,
                  summary_tab,
                  table_tab,
                  hypothesis_tab,
                  glm_tab)
    )
  )
)

