##############
## server.R ##
##############
library(dplyr)
library(ggplot2)
library(shiny)
library(leaflet)
library(geojsonio)
library(scales)
# Reads in data
honey_production_data <- read.csv(file = "data/honeyproduction.csv", stringsAsFactors = FALSE)

my_server <- function(input, output, session) {
  map <- reactive({
    correct_state <- state.abb[match(input$obs_state, state.name)]
    select(filter(honey_production_data, year >= input$obs_year & correct_state == state), year, state, 
           totalprod, numcol)
  })
  
  graph <- reactive({
    column_names <- c("State", "# of Colonies", "Yield", "Production", "Stocks", "Price (per LB)", 
                      "Prod Value", "Year")
    names(honey_production_data) <- column_names
    correct_state <- state.abb[match(input$obs_state, state.name)]
    filter(honey_production_data, Year >= input$obs_year & correct_state == State)
  })
  
  country_average <- reactive({
    honey_production_data %>% 
      filter(year >= input$obs_year) %>% 
      group_by(year) %>% 
      summarize(col = mean(numcol))
  })
  
  bins <- c(100000, 1000000, 5000000, 10000000, 20000000, 30000000, 40000000, 50000000)

  map_viz <- reactive({
    
    # Filters the data so that it could be mapped correctly.
    states <- geojson_read("data/us_states.json", what = "sp")
    names(states@data) <- "state"
    single_year <- honey_production_data %>% 
      filter(year == input$obs_year)
    single_year$state <- state.name[match(single_year$state, state.abb)]
    states@data <- left_join(states@data, single_year, by = "state") 

    # Orders the bins and colors that will be used for the map, and creates labels as well.
    pal <- colorBin("YlOrRd", domain = states@data$totalprod, bins = bins)
    labels <- sprintf(
      "<strong>%s</strong><br/>%g Lbs produced",
      states@data$state, states@data$totalprod
    ) %>% lapply(htmltools::HTML)
    
    # Gives the center of a given state
    coords <- data.frame(state.name, state.center)
    center <- filter(coords, state.name == input$obs_state)
    
    # Creates the map visualization
    leaflet(states) %>%
      setView(center$x, center$y, 5) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('pk.eyJ1IjoiaGFyam90ZCIsImEiOiJjamhxajlxMHkwMnhyMzZwcHg0OXB4b
                                 TlmIn0.xCU7EJo0WQ1jW-CvwFhfGw'))
      ) %>%  
      addPolygons(
        fillColor = ~pal(states@data$totalprod),
        color = "white",
        dashArray = "3",
        fillOpacity = "0.7",
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7, 
          bringToFront = TRUE
        ), 
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(
        pal = pal, values = ~states@data$totalprod, opacity = 0.7, title = NULL,
        position = "bottomright"
      )
    
  })

  output$country <- renderLeaflet(
    map_viz()
  )

  output$graph_output <- renderPlot({
    ggplot(map(), mapping = aes(year, numcol, color = "red")) + 
      geom_point() +
      geom_line() + 
      geom_smooth(country_average(), mapping = aes(year, col), color = "black") +
      labs(x = "Year", y = "# of Colonies", 
           title = "Colonies") + 
      theme(legend.position = "none")
  })

  output$table <- renderTable({
    graph()
  })
}

shinyServer(my_server)
