##############
## server.R ##
##############
library(dplyr)
library(tidyr)
library(ggplot2)
library(shiny)
library(leaflet)
library(geojsonio)
library(scales)
library(plotly)
library(maps)
library(geojson)

# Reads in data
honey_production_data <- read.csv(file = "data/honeyproduction.csv", stringsAsFactors = FALSE)

my_server <- function(input, output, session) {
  map <- reactive({
    correct_state <- state.abb[match(input$obs_state, state.name)]
    select(
      filter(honey_production_data, year >= input$obs_year & correct_state == state), year, state,
      totalprod, numcol
    )
  })

  graph <- reactive({
    column_names <- c(
      "State", "# of Colonies", "Yield", "Production", "Stocks", "Price (per LB)",
      "Prod Value", "Year"
    )
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
        accessToken = Sys.getenv("pk.eyJ1IjoiaGFyam90ZCIsImEiOiJjamhxajlxMHkwMnhyMzZwcHg0OXB4b\n                                 TlmIn0.xCU7EJo0WQ1jW-CvwFhfGw")
      )) %>%
      addPolygons(
        fillColor = ~ pal(states@data$totalprod),
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
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = pal, values = ~ states@data$totalprod, opacity = 0.7, title = NULL,
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
      labs(
        x = "Year", y = "# of Colonies",
        title = "Colonies"
      ) +
      theme(legend.position = "none")
  })

  output$table <- renderTable({
    graph()
  })

  output$scatter <- renderPlot({
    ggplot(honey_production_data) +
      geom_point(aes(x = numcol, y = yieldpercol, color = year)) +
      scale_y_continuous(name = "Pounds of Honey Yielded Per Colony", labels = comma) +
      scale_x_continuous(name = " Number of Colonies", labels = comma) +
      geom_smooth(aes(x = numcol, y = yieldpercol), model = lm, size = 1.5)
  })

  # This is the bins or breaks used in the map
  bins2 <- seq(min(honey_production_data$totalprod, na.rm = T), max(honey_production_data$totalprod, na.rm = T), l = 8)

  # This is the reactive function and in this
  # The us states map is being produced.
  map_nation <- reactive({
    states <- geojsonio::geojson_read("data/us_states.json", what = "sp")
    names(states@data) <- "state"
    single_year <- honey_production_data %>%
      filter(year == input$yearchoice)
    single_year$state <- state.name[match(single_year$state, state.abb)]
    states@data <- left_join(states@data, single_year, by = "state")

    # This is the function used to fill the color in the map
    pal <- colorBin("YlOrRd", domain = states@data$totalprod, bins = bins2)

    # This is the labels
    labels <- labels <- sprintf(
      "<strong>%s</strong><br/>%g Honey Production",
      states$state, states$totalprod
    ) %>% lapply(htmltools::HTML)

    # Used to produce the map.
    leaflet() %>%
      setView(-96, 37.8, 4) %>%
      addPolygons(
        data = states,
        fillColor = ~ pal(states@data$totalprod),
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
          bringToFront = TRUE
        ),
        label = labels
      ) %>%
      addLegend(
        pal = pal,
        values = states@data$totalprod,
        opacity = 0.7,
        title = "Total Production",
        position = "bottomleft"
      )
  })

  # This renders the map
  output$map <- renderLeaflet({
    map_nation()
  })

  # This render the value box with avg production.
  output$avg <- renderValueBox({
    States <- filter(honey_production_data, year == input$yearchoice) %>%
      summarise(TotalAvg = mean(totalprod))
    avg <- round(States$TotalAvg[1], digits = 2)
    valueBox(
      paste0(avg), "Average Production",
      icon = icon("product-hunt"),
      color = "red"
    )
  })

  # This render the value box with year selected
  output$yearselected <- renderValueBox({
    valueBox(
      paste0(input$yearchoice), "Year Selected",
      icon = icon("calendar"),
      color = "blue"
    )
  })

  # This render the value box with total prodction
  output$total <- renderValueBox({
    States <- filter(honey_production_data, year == input$yearchoice) %>%
      summarise(Total = sum(totalprod))
    total <- round(States$Total[1], digits = 2)
    valueBox(
      paste0(total), "Total Production",
      icon = icon("product-hunt"),
      color = "yellow"
    )
  })
}

# This is used to take in the server create to
# run the app.
shinyServer(my_server)
