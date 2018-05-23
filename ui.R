##########
## ui.R ##
##########
library(rbokeh)
library(shiny)
library(shinydashboard)

my_ui <- dashboardPage(
  dashboardHeader(title = "Honey Production"),
  dashboardSidebar(),
  dashboardBody(),
  skin = "yellow"
)

shinyUI(my_ui)
