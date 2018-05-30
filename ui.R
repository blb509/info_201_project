##########
## ui.R ##
##########
library(rbokeh)
library(shiny)
library(shinydashboard)
library(leaflet)
library(maps)

test <- map('state')
my_ui <- dashboardPage(
  dashboardHeader(title = "Honey Production"),
  dashboardSidebar(
    sidebarMenu( id = 'sidebarmenu',
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Nation", tabName = "nation", icon = icon("map")),
      menuItem("State", tabName = "state", icon = icon("map-marker")),
      conditionalPanel("input.sidebarmenu == 'state'", 
                       sliderInput("obs_year", "Year:", value = 1, min = 1998, max = 2012, sep = ''), 
                       selectInput("obs_state", "State:", state.name)),
      menuItem("Summary", tabName = "summary", icon = icon("book")),
      menuItem("Reference", tabName = "refer", icon = icon("graduation-cap")) 
      )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "state",
              fluidRow(
                box(
                  title = "Honey Produced (per State)", width = 6, solidHeader = TRUE, background = "olive",
                  leafletOutput('country')
                ),
                box(
                  title = "Plot", width = 6, solidHeader = TRUE, background = "olive",
                  plotOutput('graph_output')
                ), 
                box(
                  title = "Table", width = 12, align = "center" ,solidHeader = TRUE, background = "black", 
                  tableOutput('table')
                ) 
              )
      )
    )
  ),
  skin = "yellow"
)

shinyUI(my_ui)
