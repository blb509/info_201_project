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
    tabItems(
      tabItem(tabName = "home",
              img(src = "bee.JPG"), # https://www.mybeeline.co/en/p/how-can-we-differentiate-100-pure-honey-and-adulterated-honey
              tags$br(),
              tags$br(),
              tags$br(),
              tags$head(tags$style((" #sidebar {
                                          background-color: #FFD54C;
              }
                                    
                                    "))),
              tags$head(tags$style((" #intro {color: black;
                                    font-size: 30px;
                                    text-align: center;
                                    font-family: 'Georgia';
                                    }
                                    div.box-header {
                                    text-align: center;
                                    }
                        "))),
              textOutput("intro"),
              tags$br(),
              tags$br(),
              tags$br(),
              sidebarLayout(
                sidebarPanel(id = "sidebar",
                  h1(strong("Colony Collapse Disorder")),
                  textOutput("colony_collapse"),
                  tags$head(tags$style("#colony_collapse{color: black;
                                        font-size: 18px;
                                        font-family: 'Georgia';
                                        }"))
                ),
                sidebarPanel(id = "sidebar",
                  h1(strong("Overall Questions")),
                  textOutput("questions"),
                  width = 8
                )
              )
    )),
    fluidRow(
      leafletOutput("plot")
    )
  ),
  skin = "yellow"
)

shinyUI(my_ui)
