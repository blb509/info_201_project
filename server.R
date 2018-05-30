##############
## server.R ##
##############
library(dplyr)
library(tidyr)
library(ggplot2)
library(shiny)
library(leaflet)
library(plotly)
library(maps)
library(tidyr)
library(scales)
library(geojsonio)
library(geojson)

# Reads in data
honey_production_data <- read.csv(file = "data/honeyproduction.csv", stringsAsFactors = FALSE)

#This makes the server for the apps
my_server <- function(input, output, session) {
  output$scatter <- renderPlot({
    ggplot(honey_production_data) +
      geom_point(aes(x = numcol, y = yieldpercol, color = year)) +
      scale_y_continuous(name = "Pounds of Honey Yielded Per Colony", labels = comma) +
      scale_x_continuous(name = " Number of Colonies", labels = comma) +
      geom_smooth(aes(x = numcol, y = yieldpercol), model = lm, size = 1.5)
  })
  
  #This is the bins or breaks used in the map
  bins  <- seq(min(honey_production_data$totalprod,na.rm=T), max(honey_production_data$totalprod,na.rm=T), l = 8)
  
  #This is the reactive function and in this 
  #The us states map is being produced.
  map_nation <- reactive({
    states <- geojsonio::geojson_read("data/us_states.json", what = "sp")
    names(states@data) <- "state"
    single_year <- honey_production_data %>%
      filter(year == input$yearchoice)
    single_year$state <- state.name[match(single_year$state, state.abb)]
    states@data <- left_join(states@data, single_year, by = "state")
    
   #This is the function used to fill the color in the map
   pal <- colorBin("YlOrRd", domain = states@data$totalprod, bins = bins)
   
   #This is the labels
   labels <- labels <- sprintf(
     "<strong>%s</strong><br/>%g Honey Production",
     states$state, states$totalprod
   ) %>% lapply(htmltools::HTML)
   
   #Used to produce the map.
   leaflet() %>%
      setView(-96, 37.8, 4) %>%
      addPolygons(data = states,
                  fillColor = ~pal(states@data$totalprod),
                  weight = 1,
                  smoothFactor = 0.5,
                  dashArray = "3",
                  color = "blue",
                  fillOpacity = 0.8,
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels)%>%
     addLegend(pal = pal,
               values = states@data$totalprod,
               opacity = 0.7,
               title = "Total Production",
               position = "bottomleft")
   })
  
  #This renders the map
  output$map <- renderLeaflet({
    map_nation()
  })
  
  #This render the value box with avg production.
  output$avg <- renderValueBox({
      States <- filter(honey_production_data, year == input$yearchoice) %>%
      summarise(TotalAvg = mean(totalprod))
    avg <- round(States$TotalAvg[1], digits = 2)
    valueBox(
      paste0(avg), "Average Production", icon = icon("product-hunt"),
      color = "red")
  })
  
  #This render the value box with year selected
  output$yearselected <- renderValueBox({
    valueBox(
      paste0(input$yearchoice), "Year Selected", icon = icon("calendar"),
      color = "blue")
  })
  
  #This render the value box with total prodction
  output$total <- renderValueBox({
    States <- filter(honey_production_data, year == input$yearchoice) %>%
      summarise(Total = sum(totalprod))
    total <- round(States$Total[1], digits = 2)
    valueBox(
      paste0(total), "Total Production", icon = icon("product-hunt"),
      color = "yellow")
  })
}
  
#This is used to take in the server create to 
#run the app.
shinyServer(my_server)

