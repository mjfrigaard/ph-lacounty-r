#=====================================================================#
# File name: noreactive.R
# This is code to create: no reactives shiny app
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
#=====================================================================#

# pkgs --------------------------------------------------------------------
library(shiny)
library(skimr)
library(tidyverse)

ui <- fluidPage(
    headerPanel(title = "Reactives App"),
    sidebarLayout(
        sidebarPanel(
            sliderInput(
                inputId = "n",
                label = "N",
                min = 1,
                max = 1000,
                value = 100,
                step = 10
            ),
            sliderInput(
                inputId = "mean",
                label = "Mean",
                min = 1,
                max = 50,
                value = 10,
                step = 0.5
            ),
            sliderInput(
                inputId = "sd",
                label = "SD",
                min = 1,
                max = 100,
                value = 25,
                step = 5
            )
        ),
        mainPanel(tableOutput(outputId = "tbl"),
            plotOutput(outputId = "grph"))
    ))

server <- function(input, output) {
    
    output$tbl <- renderTable({
        
        skim_rnorm <- skimr::skim(
            tibble(rnorm_var = rnorm(
            n = input$n,
            mean = input$mean,
            sd = input$sd)))
        
        skim_rnorm %>%
            dplyr::select(contains("numeric"), 
                -numeric.mean, -numeric.sd) %>%
            tibble::as_tibble() %>%
            dplyr::rename_with(.data = ., 
                ~ gsub("numeric.", "", .x, fixed = TRUE))
    })
    
    output$grph <- renderPlot({
        tibble(rnorm_var = rnorm(
            n = input$n,
            mean = input$mean,
            sd = input$sd
        )) %>% 
            ggplot(aes(x = rnorm_var)) +
            geom_histogram() + 
            labs(x = "rnorm() inputs")
    })
    
}

shinyApp(ui = ui, server = server)

