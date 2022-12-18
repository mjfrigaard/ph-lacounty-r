#=====================================================================#
# File name: solution.R
# This is code to create: Box vs. Violin shiny app solution
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
#=====================================================================#



# pkgs --------------------------------------------------------------------
library(shiny)
library(tidyverse)
library(rlang)
library(NHANES)


# data --------------------------------------------------------------------
NHANES <- NHANES::NHANES


# 2-level factors ---------------------------------------------------------
fct_2levels <- c("SurveyYr", "Gender", "Diabetes", 
    "SleepTrouble", "PhysActive", "Alcohol12PlusYr", 
    "SmokeNow", "Smoke100", "RegularMarij", 
    "HardDrugs", "SexEver", "SameSex")

# all factors ------------------------------------------------------------
factor_names <- NHANES %>% 
    select(where(is.factor)) %>% 
    names()

# 2+ levels factors -------------------------------------------------------
fct_2plus_levels <- setdiff(x = factor_names, y = fct_2levels)


# numeric name ------------------------------------------------------------
numeric_names <- NHANES %>% 
    select(where(is.numeric)) %>% 
    names()

numeric_names <- numeric_names[numeric_names != "ID"]

num_var <- "Age"
cat_var <- "AgeDecade"
grp_var <- "SurveyYr"

boxolin <- function(data, xvar, yvar, color_var, facet_var) {
  x <- rlang::sym(xvar)
  y <- rlang::sym(yvar)
  c <- rlang::sym(color_var)
  g <- rlang::parse_exprs(facet_var)

  p <- ggplot2::ggplot(data,
          ggplot2::aes(x = !!x, y = !!y, fill = !!c)) +
            ggplot2::geom_jitter(aes(fill = !!c), 
                width = 0.125, height = 0.125, 
                alpha = 2/3, shape = 21,  
                color = "white", size = 1.5, 
                show.legend = FALSE) + 
            ggplot2::geom_boxplot(alpha = 1/2,
                show.legend = FALSE) +
            ggplot2::geom_violin(alpha = 1/2,
                show.legend = FALSE) +
      ggplot2::theme_minimal() + 
      ggplot2::facet_wrap(vars(!!!g), scales = "free") + 
            labs(x = xvar, y = yvar, 
                title = paste0("Distribution of y = ", yvar, " by x = ",
                         xvar, " and group = ", facet_var))
  return(p)
}

ui <- fluidPage(
  headerPanel(title = "Boxolin Graph"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "num_var",
        label = "Numeric Variable", 
        choices = numeric_names, 
        selected = "SleepHrsNight"
      ),
      selectInput(
        inputId = "cat_var",
        label = "Category",
        choices = fct_2plus_levels, 
        selected = "MaritalStatus"
      ),
      selectInput(
        inputId = "facet_var",
        label = strong("Group", code("facet")), 
        choices = fct_2levels, 
        selected = "SleepTrouble"
      ),
    checkboxInput(
        inputId = "flip", 
        label = "flip axis?", 
        value = FALSE)
    ),
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output, session) {
    
    plot_data <- reactive({
        dplyr::select(NHANES, 
            all_of(input$num_var),
            all_of(input$cat_var),
            all_of(input$facet_var)) %>% 
        dplyr::filter(
            !is.na(across(all_of(input$cat_var))),
            !is.na(across(all_of(input$facet_var))),
            !is.na(across(all_of(input$num_var))))
    })
        
  output$plot <- renderPlot(
      
    if (input$flip == TRUE) {
        
        boxolin(data = plot_data(), 
            yvar = input$cat_var, 
            xvar = input$num_var, 
            color_var = input$cat_var, 
            facet_var =  input$facet_var)
        
    } else {
        
        boxolin(data = plot_data(), 
            xvar = input$cat_var, 
            yvar = input$num_var, 
            color_var = input$cat_var, 
            facet_var =  input$facet_var)
        
    }
  )
}

shinyApp(ui = ui, server = server)
