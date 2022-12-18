# =====================================================================#
# File name: reactlog.R
# This is code to create: shiny reactive log
# Authored by and feedback to: @mjfrigaard
# Last updated:  2022-12-04
# MIT License
# Version: 1.0
# =====================================================================#


# 1) RESTART R/PKGS ------------------------------------------------------
# restart R for a fresh session and load the packages (install if needed)
library(shiny)
library(reactlog)

# 2) CONFIGURE/ENABLE REACTLOG --------------------------------------------
# run the code below to have reactlog running in the background 
options(shiny.reactlog = TRUE)
# enable the reactlog 
reactlog::reactlog_enable()

# 3) RUN THE APP  ---------------------------------------------------------
# run the application in reactives/noreactive.R
runApp("reactives/noreactive.R")

# after the plot and table are created, stop the application.

shiny::reactlogShow()


# 5) RESTART R AGAIN -------------------------------------------------------
# restart R for another fresh session and re-load the packages 
library(shiny)
library(reactlog)
# 6) ENABLE REACTLOG ------------------------------------------------------
# enable the reactlog 
reactlog::reactlog_enable()
# 3) RUN THE APP  ---------------------------------------------------------
# run the application in reactives/reactive.R
runApp("reactives/reactive.R")

shiny::reactlogShow()
