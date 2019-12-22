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
      tableOutput(outputId='company_eod')
    )
  ),
  
)
