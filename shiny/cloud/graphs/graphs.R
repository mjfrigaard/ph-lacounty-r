#=====================================================================#
# File name: graphs.R
# This is code to create: Box vs. Violin shiny app 
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
#=====================================================================#



ui <- fluidPage(
  headerPanel(title = "Box vs. Violin"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "n",
        label = "Sample",
        min = 20,
        max = 500,
        value = 100,
        step = 20
      ),
      sliderInput(
        inputId = "mean",
        label = "Mean",
        min = 1,
        max = 5,
        value = 2.5,
        step = 0.5
      ),
      sliderInput(
        inputId = "sd",
        label = "Standard Deviation",
        min = 5,
        max = 25,
        value = 10,
        step = 1
      )
    ),
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output, session) {
    
    plot_data <- reactive({
        tibble::tibble(
          rnorm_var = rnorm(
            n = input$n,
            mean = input$mean,
            sd = input$sd
          ))
    })
        
  output$plot <- renderPlot(
      
      ggplot(data = __________, 
          mapping = aes(x = "", y = rnorm_var)) +
            geom_violin(fill = "firebrick", alpha = 1 / 2) +
            geom_boxplot(fill = "dodgerblue", alpha = 1 / 2) +
          
      labs(x = "", y = "rnorm() value", 
          title = paste0("Distribution of n = ", 
              __________)) +
          
      ggplot2::theme_minimal()
  )
}

shinyApp(ui = ui, server = server)
