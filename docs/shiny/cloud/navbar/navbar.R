#=====================================================================#
# File name: navbar.R
# This is code to create: navbarPage layout
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
#=====================================================================#

library(shiny)


# navbarPage() -------
ui <- navbarPage(

  ## App title ------
  title = "Title of your app",

  ## navbarMenu (TABS 1 & 2) -----
  navbarMenu(
    "navbarMenu", # this is going to show up in the navbar

    ### LANDING PAGE "tabPanel 1" ----
    tabPanel(
      title = "tabPanel 1", # this is our landing page and 
                            # first item in dropdown
      #### SIDEBAR 1 ----
      sidebarLayout(

        ##### sidebarPanel() 
        sidebarPanel("sidebarPanel", width = 3),

        ##### MAIN PANEL 1 -----------------------
        mainPanel(
          h1("mainPanel"),
          column(
            width = 6,
            tags$pre("column 1 (width = 6)")
          ),
          column(
            width = 6,
            tags$pre("column 2 (width = 6)"),
          )
        )
      )
    ),
    ### SECOND TAB ("tabPanel 2") ----
    tabPanel(
      title = "tabPanel 2",
      #### SIDEBAR 2 ----
      sidebarLayout(
        sidebarPanel("sidebarPanel (width = 4)", 
          width = 4),
        ##### MAIN PANEL 2 ("mainPanel 2/tabPanel 2") -----
        mainPanel(
          h1("mainPanel 2 for tabPanel 2"),
          column(
            width = 8,
            tags$pre("column(width = 8)")
          ),
          column(
            width = 4,
            tags$pre("column(width = 4)")
          )
        )
      )
    )
  ),
  ### TAB 3 ("tabPanel 3") ----
  tabPanel(
    title = "tabPanel 3",
    #### SIDEBAR ("tabPanel 3") -----
    sidebarLayout(
      sidebarPanel("sidebarPanel (default width)"),
      mainPanel(
        h1("Two tabPanels in tabsetPanel:"),
        ###### TAB SETS ("tabPanel 3") ------
        tabsetPanel(
          type = "tabs",
          ###### ["tabPanel 1"] ----
          tabPanel("tabPanel 3b"
          ),
          ####### ["tabPanel 2"] ----
          tabPanel("tabPanel 3b"
          )
        )
        
      )
      
    )
    
  ),
  ### TAB 4 ("tabPanel 4") ----
  tabPanel(
    title = "tabPanel 4",
    #### SIDEBAR ("tabPanel 4") ----
    sidebarLayout(
      sidebarPanel("sidebarPanel for tabPanel 4"),
      ##### MAIN PANEL ("two column layout") -----
      mainPanel(
        h1("two column layout"),
        column(width = 6,
          tags$pre("column(width = 6)")
        ),
        column(
          6,
          tags$pre("column(width = 6)")
        )
      )
    )
  ),
  tabPanel(
    title = "tabPanel 5",
    #### SIDEBAR ("tabPanel 5") -----
    sidebarLayout(
      sidebarPanel("sidebarPanel for tabPanel 5"),
      ##### MAIN PANEL 5 ("three column layout") -----
      mainPanel(
        h1("three column layout"),
        column(
          width = 4,
          tags$pre("column(width = 4)")
        ),
        column(
          width = 4,
          tags$pre("column(width = 4)")
        ),
        column(
          width = 4,
          tags$pre("column(width = 4)")
        )
      )
    )
  )
)


server <- function(input, output, session) {


}

shinyApp(ui, server)
