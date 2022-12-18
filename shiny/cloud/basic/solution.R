# =====================================================================#
# File name: solution.R
# This is code to create: basic shiny app
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
# =====================================================================#

# pkgs --------------------------------------------------------------------
library(shiny)
library(tibble)
library(dplyr)

ui <- fluidPage(
  headerPanel(title = "My App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "mean",
        label = "Mean",
        min = 1,
        max = 10,
        value = 2,
        step = 0.5
      )
    ),
    mainPanel(
      tableOutput(outputId = "tbl")
    )
  )
)

server <- function(input, output) {
    
  tbl_data <- reactive({
    tibble(mean_input = rnorm(
                         n = 10,
                      mean = input$mean)) %>% 
      mutate(mean_input = round(mean_input, digits = 1))
  })

  output$tbl <- renderTable({
        tbl_data()
  }, digits = 1)
  
}

shinyApp(ui = ui, server = server)
