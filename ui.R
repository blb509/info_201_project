##########
## ui.R ##
##########
library(rbokeh)
library(shiny)
library(shinydashboard)

my_ui <- dashboardPage(
  dashboardHeader(title = "Honey Production"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Nation", tabName = "nation", icon = icon("map"),
               selectInput("datachoice", label = "Data",
                           honey_production_data_long$data),
               selectInput("yearchoice", label = "Year",
                           honey_production_data_long$year)),
      menuItem("State", tabName = "state", icon = icon("map-marker")),
      menuItem("Summary", tabName = "summary", icon = icon("book")),
      menuItem("Reference", tabName = "refer", icon = icon("graduation-cap"))
    )
  ),
  dashboardBody(
    fluidRow(
      leafletOutput("plot")
    )
  ),
  skin = "yellow"
)

shinyUI(my_ui)
