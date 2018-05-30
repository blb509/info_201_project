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
  
}

shinyServer(my_server)
