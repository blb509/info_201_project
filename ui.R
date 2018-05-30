##########
## ui.R ##
##########
library(rbokeh)
library(shiny)
library(leaflet)
library(shinydashboard)

my_ui <- dashboardPage(
  dashboardHeader(title = "Honey Production"),
  dashboardSidebar(
    sidebarMenu( id = "sidebarmenu",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Nation", tabName = "nation", icon = icon("map")),
      conditionalPanel("input.sidebarmenu == 'nation'",
                       selectInput("yearchoice", label = "Select Year", 
                                   choices = honey_production_data$year)),
      menuItem("State", tabName = "state", icon = icon("map-marker")),
      menuItem("Summary", tabName = "summary", icon = icon("book")),
      menuItem("Reference", tabName = "refer", icon = icon("graduation-cap"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "nation",
              box(
                title = "United States", solidHeader = TRUE,
                width = 14, status = "primary",
                leafletOutput('map')
              ),
              fluidRow(
                valueBoxOutput('avg'),
                valueBoxOutput('yearselected')
              ))
    )
  ),
  skin = "yellow"
)

shinyUI(my_ui)
