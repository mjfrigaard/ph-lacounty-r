#=====================================================================#
# File name: sidebar.R
# This is code to create: sidebar app
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
    sidebarLayout(
      sidebarPanel(),
    mainPanel(
      tags$a(href = "https://shiny.rstudio.com/reference/shiny/0.14/fluidpage", 
        tags$code("fluidPage()"),
        target = "_blank")
        )
    )
)

# Define server function --------------------------------------------
server <- function(input, output) {
  
}
# Create the Shiny app object ---------------------------------------
shinyApp(ui = ui, server = server)
