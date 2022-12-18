# =====================================================================#
# File name: solution.R
# This is code to create: shiny tables app solution
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
# =====================================================================#



# pkgs --------------------------------------------------------------------
library(shiny)
library(tidyverse)
library(reactlog)
options(shiny.reactlog = TRUE)
reactlog::reactlog_enable()

# table pkgs
library(kableExtra)
library(gt)
library(DT)
library(reactable)
# data
library(NHANES)
NHANES <- NHANES::NHANES
# create names
all_nhanes_col_names <- purrr::set_names(names(NHANES))
# sample names
nhanes_col_names <- base::sample(
  x = all_nhanes_col_names,
  size = 8, replace = FALSE)

# UI ----------------------------------------------------------------------


ui <- fluidPage(
  headerPanel(title = "Shiny Tables"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4(code("NHANES"), "Data"),
      selectInput(
        inputId = "columns",
        label = "Select Columns",
        choices = nhanes_col_names,
        selected = nhanes_col_names[1:3],
        multiple = TRUE,
        selectize = TRUE
      )
    ),
    mainPanel(
      fluidRow(
        h2("Static Tables"),
        column(
          width = 12,
          selectInput(
            inputId = "static_tbl",
            label = "Select Table Display",
            choices = c(
              "shiny" = "shiny",
              "kable" = "kable",
              "gt" = "gt"
            ),
            selected = "shiny"
          ),
          shiny::uiOutput(outputId = "static_output")
        )
      ),
      fluidRow(
        h2("Dynamic Tables"),
        column(
          width = 12,
          selectInput(
            inputId = "dynamic_tbl",
            label = "Select Table Display",
            choices = c(
              "DT" = "DT",
              "reactable" = "reactable"
            ),
            selected = "DT"
          ),
          shiny::uiOutput(outputId = "dynamic_output")
        )
      )
    )
  )
)

# server ------------------------------------------------------------------

server <- function(input, output, session) {
    
  table_data <- reactive({
    req(input$columns)
    dplyr::select(
      NHANES,
      all_of(input$columns)
    ) %>%
      dplyr::slice_sample(
        n = 10,
        replace = FALSE
      )
  })

  observeEvent(input$static_tbl, handlerExpr = {
    if (input$static_tbl == "shiny") {
      output$static_output <- renderTable(
        {
          table_data()
        },
        striped = TRUE,
        spacing = "m",
        position = "left"
      )
    } else if (input$static_tbl == "kable") {
      output$static_output <- function() {
        table_data() %>%
          knitr::kable("html") %>%
          kableExtra::kable_styling(
            kable_input = .,
            position = "left",
            bootstrap_options = "condensed",
            full_width = FALSE
          )
      }
    } else {
      output$static_output <- render_gt(
        {
          table_data() %>%
            gt::gt(data = .)
        },
        align = "left"
      )
    }
  })

  observeEvent(eventExpr = input$dynamic_tbl, handlerExpr = {
    if (input$dynamic_tbl == "DT") {
      output$dynamic_output <- shiny::renderUI({
        table_data() %>%
          DT::datatable(
            data = .,
            options = list(dom = "ft")
          )
      })
    } else {
      output$dynamic_output <- shiny::renderUI({
        table_data() %>%
          reactable::reactable(
            data = .,
            resizable = TRUE,
            striped = TRUE,
            wrap = FALSE,
            outlined = TRUE,
            compact = TRUE
          )
      })
    }
  })
}


# run ---------------------------------------------------------------------


shinyApp(ui = ui, server = server)
