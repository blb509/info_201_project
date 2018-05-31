##########
## ui.R ##
##########
library(rbokeh)
library(shiny)
library(leaflet)
library(shinydashboard)
library(leaflet)
library(maps)
library(scales)

my_ui <- dashboardPage(
  dashboardHeader(title = "Honey Production"),
  dashboardSidebar(
    # Includes every menu option to pick from
    sidebarMenu(
      id = "sidebarmenu",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Nation", tabName = "nation", icon = icon("map")),
      conditionalPanel(
        "input.sidebarmenu == 'nation'",
        selectInput("yearchoice",
          label = "Select Year",
          choices = honey_production_data$year
        )
      ),
      menuItem("State", tabName = "state", icon = icon("map-marker")),
      conditionalPanel(
        "input.sidebarmenu == 'state'",
        sliderInput("obs_year", "Year:", value = 1, min = 1998, max = 2012, sep = ""),
        selectInput("obs_state", "State:", state.name)
      ),
      menuItem("Summary", tabName = "summary", icon = icon("book")),
      menuItem("Reference", tabName = "refer", icon = icon("graduation-cap"))
    )
  ),

  # The content in each of the menu options
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "refer",
        h1(id = "refer_page", "References"),
        tags$head(tags$style("#refer_page{color: black;
                              font-size: 72px;
                              font-family: 'Georgia';
                             }")),
        tags$head(tags$style("#about{color: black;
                             font-size: 18px;
                             font-family: 'Georgia';
                             text-align: center;
                             ")),
        box(id = "sidebar",
            img(src = "USDA.png", height = 100, width = 200),
            br(),
            br(),
            br(),
            p(id = "about", "Thanks to the NASS, who has collected statistics
              on the number of honey bee colonies and U.S. honey production for decades,
              this data visualization was made possible. Working under the USDA, NASS
              has conducted the 'Bee and Honey Inquiry Survey' since 1986. More information
              can be found", a("HERE.", href = "https://www.nass.usda.gov/Surveys/Guide_to_NASS_Surveys/Bee_and_Honey/")),
            br(),
            br(),
            img(src = "EPA.png", height = 100, width = 200),
            br(),
            br(),
            br(),
            p(id = "about", "The United States Environmental Protection Agency Provided us
              with information about the Colony Collapse Disorder. It is also a great 
              agency that has been taking action to protect pollinators since 2007. For more
              information about the Colony Collapse Disorder, pollinator health concerns and
              various other pollination issues visit:", a("EPA", href = "https://www.epa.gov/pollinator-protection/colony-collapse-disorder"))
        )
      ),
      tabItem(
        tabName = "nation",
        box(
          title = "United States", solidHeader = TRUE,
          width = 14, status = "primary",
          leafletOutput("map")
        ),
        fluidRow(
          valueBoxOutput("avg"),
          valueBoxOutput("yearselected"),
          valueBoxOutput("total")
        )
      ),
      tabItem(
        tabName = "state",
        fluidRow(
          box(
            title = "Honey Produced (per State)", width = 6, solidHeader = TRUE, background = "olive",
            leafletOutput("country")
          ),
          box(
            title = "Plot", width = 6, solidHeader = TRUE, background = "olive",
            plotOutput("graph_output")
          ),
          box(
            title = "Table", width = 12, align = "center", solidHeader = TRUE, background = "black",
            tableOutput("table")
          )
        )
      ),
      tabItem(
        tabName = "summary",
        box(
          title = "Amount of Colonies VS Honey Yield per Colony", solidHeader = TRUE,
          background = "olive",
          width = 12,
          plotOutput("scatter", height = 400)
        ),
        box(
          p("Through our research and analysis of the data, we have found that honey bees and their
            production of honey is affected by a number of factors. Those factors can at times combine
            to cause CCD. The colony collapse disorder (CCD), is when a majority of worker bees leave
            a hive and cause hive to fail. CCD was first given a name in 2006 when many farmers were
            reporting that they were losing very high numbers of their hives, losses ranging from 30-90
            percent of hives. Over time research has found that CCD is linked to a number of factors
            such as change in habitat, new diseases, and pesticide poisoning. Extreme cases of CCD
            caused honey production to decrease most in the years 2006 - 2008. We see this in that the
            average of honey production from 1998 - 2005 being 4,481,717 pounds produced while from
            2006 - 2012 the average production was 3,792,727 pounds. While CCD is an example of how
            things can go wrong with honey production, Hawaii is an example of things going the right way.
            Hawaii has had the highest yield ever with 136 pounds of honey per colony. It also has the
            second highest yield ever as well and consistently has one of the highest yields every year.
            This has much to do with Hawaii's climate and the origin of honey bees. Honey bees originated
            in Europe when Europe had a tropical region. So Hawaii's tropical climate coupled with its
            extreme plant diversity is the reason why it has such high yields and why states with similar
            climates like Florida also consistently have high yields.")
      )),
      tabItem(
        tabName = "home",
        img(src = "bee.png"),
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
                we can take a deeper look into why the industry is struggling
                and simultaneously raise awareness about an important issue."),
        tags$br(),
        tags$br(),
        tags$br(),
        tags$br(),
        sidebarLayout(
          sidebarPanel(
            id = "sidebar",
            h1(strong("Colony Collapse Disorder")),
            p(id = "sidebarText", 'CCD or Colony Collapse Disorder is defined as "The sudden mass disappearance
                             of the majority of worker bees in a colony." In the winter of 2006 bee keepers
                             reported an unusual high loss of bees from their hives yet found very few dead bees
                             near the colony. Due to the substantial loss of worker bees, hives that experienced CCD
                             would die off. Researchers have blamed the cause of CCD on anything from pesticides
                             to the bees level of stress but the main reason is still a mystery.')
          ),
          sidebarPanel(
            id = "sidebar",
            h1(strong("Overall Questions")),
            p(
              id = "sidebarText", "How did the colony collapse disorder of 2006 affect honey production?",
              br(), br(), "How does environment affect honey production?",
              br(), br(), "What was the difference between the average production from 1998 - 2005 and 2006 - 2012 (post colony collapse disorder)?",
              br(), br(), "Which state consistently had the best yield, how is it different than other states?",
              br(), br(), br(), br(), br(), br()
            ),
            width = 8
          )
        ),
        sidebarLayout(
          sidebarPanel(
            id = "sidebar",
            h1(strong("Why Bees?")),
            p(id = "sidebarText", "Why create a data visualization about honey production
              and bees? When it comes to bee's and honey they are both often overlooked 
              and taken for granted. Many people do not realize the importance of bees, let
              alone honey. Pollination by honey bee colonies accounts for at least $15 billion
              of the U.S. agriculture's value annually. Along with this, honey has many different
              uses from a natural sweetener to a cure for sore throats and colds. With so much
              relying on honey bees it is important we keep these creatures healthy and safe."),
            width = 8
          ),
          sidebarPanel(
            id = "sidebar",
            h1(strong("Resources")),
            img(src = "USDA.png", height = 55, width = 110),
            a("USDA Honey Production", href = "https://www.nass.usda.gov/Surveys/Guide_to_NASS_Surveys/Bee_and_Honey/"),
            br(),
            br(),
            img(src = "EPA.png", height = 55, width = 110),
            a("Colony Collapse Disorder", href = "https://www.epa.gov/pollinator-protection/colony-collapse-disorder")
          )
        )
      )
    )
  ),
  skin = "yellow"
)

shinyUI(my_ui)
