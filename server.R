##############
## server.R ##
##############
library(dplyr)
library(ggplot2)
library(shiny)
library(leaflet)
library(plotly)

# Reads in data
honey_production_data <- read.csv(file = "data/honeyproduction.csv", stringsAsFactors = FALSE)


my_server <- function(input, output, session) {

}

shinyServer(my_server)