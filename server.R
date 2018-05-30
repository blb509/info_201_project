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
library(scales)

# Reads in data
honey_production_data <- read.csv(file = "data/honeyproduction.csv", stringsAsFactors = FALSE)
honey_production_data_long <- gather(honey_production_data,
                                     key = data,
                                     value = value,
                                     numcol, yieldpercol, totalprod)


my_server <- function(input, output, session) {
  output$scatter <- renderPlot({
    ggplot(honey_production_data) +
      geom_point(aes(x = numcol, y = yieldpercol, color = year)) +
      scale_y_continuous(name = "Pounds of Honey Yielded Per Colony", labels = comma) +
      scale_x_continuous(name = " Number of Colonies", labels = comma) +
      geom_smooth(aes(x = numcol, y = yieldpercol), model = lm, size = 1.5)
  })
}

shinyServer(my_server)
