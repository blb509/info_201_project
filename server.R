##############
## server.R ##
##############
library(dplyr)
library(ggplot2)
library(shiny)
library(leaflet)
library(plotly)
library(maps)
library(tidyr)

# Reads in data
honey_production_data <- read.csv(file = "data/honeyproduction.csv", stringsAsFactors = FALSE)
honey_production_data_long <- gather(honey_production_data,
                                     key = data,
                                     value = value,
                                     numcol, yieldpercol, totalprod)


my_server <- function(input, output, session) {
  output$intro <- renderText({HTML(paste("Honey production in the U.S. has been on a steady decline since 1998 and there isn't any sign of it stopping. Various factors play into why this is the case but the biggest comes down to the significant decline in honey bee colonies. Due to this the honey industry has seen large reductions in production and income. Our hope is that through this analysis we can better explain the reasons why, and raise awareness."))})
  output$colony_collapse <- renderText({
    paste('CCD or Colony Collapse Disorder is defined as "The sudden mass disappearance
          of the majority of worker bees in a colony." In the winter of 2006 bee keepers
          reported an unsual high loss of bees from their hives yet very few dead bees
          near the colony were found. Due to the substantal loss of worker bees the hive
          would die. Researchers have blamed The cause of CCD on anything from pesticides
          to the bees level of stress. has been blamed on various factors but the main
          reason is yet to be pinpointed. Researchers propose that anything from pesticides
          to the bees level of stress.')
  })
  # output$questions <-
}

shinyServer(my_server)
