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
              img(src = "bee.JPG"),
              tags$br(),
              tags$br(),
              tags$br(),
              
              # Formats sidebar panels, the text of the panels and the intro text
              tags$head(tags$style((" #sidebar {
                                          background-color: #FFD54C;
                                    }"))),
              tags$head(tags$style("#sidebarText{color: black;
                                        font-size: 18px;
                                   font-family: 'Georgia';
                                   }")),
              tags$head(tags$style((" #intro {color: black;
                                    font-size: 30px;
                                    text-align: center;
                                    font-family: 'Georgia';
                                    }
                                    div.box-header {
                                    text-align: center;
                                    }"))),
              
              
              box(id = "intro", width = 12, "Honey production in the U.S. has been on a steady decline 
                  since 1998 and there isn't any sign of it stopping. Various 
                  factors play into why this is the case but the biggest comes 
                  down to the significant decline in honey bee colonies. Due to 
                  this, the honey industry has experienced large reductions in 
                  production and income. Our hope is that through this analysis 
                  we can better explain the reasons why the industry is struggling
                  and simultaneously raise awareness about a growing problem."),
              tags$br(),
              tags$br(),
              tags$br(),
              tags$br(),
              sidebarLayout(
                sidebarPanel(id = "sidebar",
                  h1(strong("Colony Collapse Disorder")),
                  p(id = "sidebarText", 'CCD or Colony Collapse Disorder is defined as "The sudden mass disappearance
                    of the majority of worker bees in a colony." In the winter of 2006 bee keepers
                    reported an unsual high loss of bees from their hives yet found very few dead bees
                    near the colony. Due to the substantal loss of worker bees hives that experienced CCD
                    would die. Researchers have blamed The cause of CCD on anything from pesticides
                    to the bees level of stress but the main reason is yet to be discoverd.')
                ),
                sidebarPanel(id = "sidebar",
                  h1(strong("Overall Questions")),
                  p(id = "sidebarText", "How did the colony collapse disorder of 2006 affect honey production?",
                      br(), br(), "How does environment affect honey production?",
                      br(), br(), "Is there any relation between number of colonies and price per pound in a given year per state?",
                      br(), br(), "Which state consistently produced more honey than the rest, how is it different than other states?"),
                  width = 8
                )
              ),
              sidebarLayout(
                sidebarPanel(id = "sidebar",
                  h1(strong("Background")),
                  p(id = "sidebarText", ""),
                  width = 8
                ),
                sidebarPanel(id = "sidebar",
                  h1(strong("Resources")),
                  img(src = "USDA.JPG", height = 55, width = 110),
                  a("USDA Honey Production", href = "https://www.nass.usda.gov/Surveys/Guide_to_NASS_Surveys/Bee_and_Honey/"),
                  br(),
                  br(),
                  img(src = "EPA.JPG", height = 55, width = 110),
                  a("Colony Collapse Disorder", href = "https://www.epa.gov/pollinator-protection/colony-collapse-disorder")
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
