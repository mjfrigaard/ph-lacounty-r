#=====================================================================#
# File name: gtrends.R
# This is code to create: create gtrendsR shiny app
# Authored by and feedback to: @mjfrigaard
# Last updated: 2022-12-13
# MIT License
# Version: 1.0
#=====================================================================#

# Load packages -----------------------------------------------------
library(shiny)
library(tidyverse)
library(plotly)


# Load data ---------------------------------------------------------
LAGoogleIOT <- read_csv("data/2022-12-15-LAGoogleIOT.csv")
LAGoogleDMA <- read_csv("data/2022-12-15-LAGoogleDMA.csv")



# Define UI ---------------------------------------------------------
ui <- fluidPage(
  titlePanel(title = "Google Trend Search Terms"),
  sidebarLayout(
    sidebarPanel(width = 3,
      # Select trend term to plot
      selectInput(inputId = "key",
                  label = strong("Trend Term"),
                  choices = unique(LAGoogleIOT$keyword),
                  selected = "COVID"),
      # Select date range to be plotted
      dateRangeInput(inputId = "date", strong("Date range"),
                     start = "2019-11-01", end = "2022-12-06",
                     min = "2004-01-01", max = "2022-12-10"),
    ),
    mainPanel(
      plotlyOutput(outputId = "lineplot",
                 height = "300px"),
      br(),
      plotlyOutput(outputId = "barplot",
                 height = "300px"),
      br(),
      tags$a(href = "https://www.google.com/",
             "Source: Google Trends",
             target = "_blank")
    )
  )
)

# Define server function --------------------------------------------
server <- function(input, output) {
  # filter data
  selected_trends <- reactive({
    req(input$date)
    validate(need(!is.na(input$date[1]) & !is.na(input$date[2]),
                  "Error: Please provide both a start and an end date."))
    validate(need(input$date[1] < input$date[2],
                  "Error: Start date should be earlier than end date."))
    LAGoogleIOT %>%
      filter(keyword == input$key,
             date > as.POSIXct(input$date[1]) &
               date < as.POSIXct(input$date[2]
               ))
  })
  
  selected_dma <- reactive({
    req(input$key)
    filter(.data = LAGoogleDMA, 
           keyword == input$key)
  })
  
  output$lineplot <- renderPlotly({
    ggp2_line <- selected_trends() %>%
      ggplot(aes(x = date, y = hits, group = keyword)) +
      geom_line(aes(color = keyword),
                show.legend = FALSE) +
      theme_minimal() + 
      theme(legend.position = 'none') + 
      labs(title = paste0("Searches for ", input$key, 
                          " from ", min(selected_trends()$date, na.rm = TRUE), 
                          " to ", max(selected_trends()$date, na.rm = TRUE)), 
           x = "Date", y = "Hits", color = "Search Term")
    
    plotly::ggplotly(ggp2_line)
    
  })
  
  output$barplot <- renderPlotly({
    
    ggp2_bar <- ggplot(selected_dma(), 
           aes(x = hits, 
               y = forcats::fct_reorder(
                 .f = location, 
                 .x = hits))) + 
      geom_col(aes(fill = hits), width = .7) +
      theme_minimal() + 
      labs(x = "Hits", y = "", fill = "Hits")
    
    plotly::ggplotly(ggp2_bar, width = 900, tooltip = c("text", "size")) %>% 
        plotly::highlight("plotly_selected")
  })
  
}
# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)
