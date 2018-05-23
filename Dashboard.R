library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Honey Production"),
  dashboardSidebar(),
  dashboardBody(),
  skin = "yellow"
)

server <- function(input, output) { }

shinyApp(ui, server)

