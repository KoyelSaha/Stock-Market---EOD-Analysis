library(readtext)

main_url <- "https://www.quandl.com/api/v3/datasets/WIKI/"
api_key <- readtext('secrets.txt')$text

server <- function(input, output, session) {
    
    eod_data <- reactive(read.csv(paste(main_url, input$company_code, '/data.csv?api_key=', api_key,
                               sep='')))
    
    output$company_eod <- renderTable(eod_data())
  
}
