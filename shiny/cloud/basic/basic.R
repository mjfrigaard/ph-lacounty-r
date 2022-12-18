#=====================================================================#
# File name: basic.R
# This is code to create: layout for basic shiny app
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
#=====================================================================#

library(shiny)
library(tidyverse)

ui <- fluidPage(
  headerPanel(title = "My App"), 
        sidebarLayout(
            sidebarPanel("sidebar"), 
            mainPanel("main")
            )
        )

server <- function(input, output, session) {
    
}

shinyApp(ui = ui, server = server)
