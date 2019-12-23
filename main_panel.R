library(shiny)

# Grid layout dimensions
sidebar_width = 3
main_panel_width = 12 - sidebar_width

# Main panel tab for Candle-Stick plot
plot_tab <- tabPanel('Plot', h4(textOutput('plot_title')), plotOutput('eod_plot'))

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
                        ))

# Main Panel tab for raw data.
table_tab <- tabPanel('Table', tableOutput('company_eod'))