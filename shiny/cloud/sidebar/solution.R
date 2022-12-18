#=====================================================================#
# File name: solution.R
# This is code to create: solution for sidebar app
# Authored by and feedback to: @mjfrigaard
# Last updated: 2022-12-04
# MIT License
# Version: 1.0
#=====================================================================#

# Load packages -----------------------------------------------------
library(shiny)
library(tidyverse)


# Define UI ---------------------------------------------------------
ui <- fluidPage(
  titlePanel(title = "fluidPage: Sidebar layout"),
  sidebarLayout(sidebarPanel(
  sliderInput(inputId = "mean",
              label = "Mean",
              min = 1,
              max = 10,
              value = 5,
              step = 1)
  ),
    mainPanel(
        numericInput(inputId = "sd",
              label = "Standard Deviation",
              min = 1,
              max = 10,
              value = 2,
              step = 1),
      tableOutput(outputId = "tbl")
    )
    )
)

# Define server function --------------------------------------------
server <- function(input, output) {
  
  output$tbl <- renderTable(
    tibble::tibble(
      MEAN = rnorm(n = 10, mean = input$mean, sd = 2),
      SD = rnorm(n = 10, mean = input$mean, sd = input$sd),
    )
    
  )
}
# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)
