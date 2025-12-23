#===============================================================================
# APP: lpi_growth_explorer_app.R
# PURPOSE: Shiny app - Compare percent change in LPI components between two countries
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# NOTE: Code preserved as provided; only this header/comment added.
# INPUT: International_LPI_from_2007_to_2023_0 (1).xlsx (local file)
#===============================================================================

library(shiny)
library(readxl)
library(tidyverse)
library(janitor)

file_path <- "International_LPI_from_2007_to_2023_0 (1).xlsx"

component_labels <- c(
  customs_score = "Customs",
  infrastructure_score = "Infrastructure",
  international_shipments_score = "Intl Shipments",
  logistics_competence_and_quality_score = "Logistics Quality",
  timeliness_score = "Timeliness",
  tracking_and_tracing_score = "Tracking"
)

cleaned_LPI <- map_dfr(
  c(2007, 2010, 2012, 2014, 2016, 2018, 2023),
  ~ read_excel(file_path, sheet = as.character(.x)) %>%
    mutate(year = .x)
) %>%
  clean_names() %>%
  filter(!if_all(names(component_labels), is.na))

growth <- cleaned_LPI %>%
  select(country, year, names(component_labels)) %>%
  pivot_longer(cols = names(component_labels),
               names_to = "component",
               values_to = "score") %>%
  filter(!is.na(score)) %>%
  mutate(component = component_labels[component])

ui <- fluidPage(
  titlePanel("LPI Growth Explorer: 2007-2023"),
  sidebarLayout(
    sidebarPanel(
      selectInput("country1", "Country 1:", 
                  choices = unique(growth$country)),
      selectInput("country2", "Country 2:", 
                  choices = unique(growth$country)),
      hr(),
      selectInput("start_year", "Start Year:", 
                  choices = c(2007, 2010, 2012, 2014, 2016, 2018, 2023),
                  selected = 2007),
      selectInput("end_year", "End Year:", 
                  choices = c(2007, 2010, 2012, 2014, 2016, 2018, 2023),
                  selected = 2023),
      hr(),
      checkboxGroupInput("component_select", "Select Components:",
                         choices = unique(growth$component),
                         selected = unique(growth$component))
    ),
    mainPanel(
      plotOutput("growth_plot"),
      hr(),
      verbatimTextOutput("summary_stats")
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    req(input$component_select)  
    req(input$start_year != input$end_year) 

    start_yr <- as.numeric(input$start_year)
    end_yr <- as.numeric(input$end_year)

    growth %>%
      filter(country %in% c(input$country1, input$country2),
             component %in% input$component_select,
             year %in% c(start_yr, end_yr)) %>%
      pivot_wider(names_from = year, values_from = score) %>%
      mutate(
        start_score = get(as.character(start_yr)),
        end_score = get(as.character(end_yr)),
        change = round((end_score - start_score) / start_score * 100, 1)
      ) %>%
      select(country, component, change)
  })

  output$growth_plot <- renderPlot({
    data <- filtered_data()

    ggplot(data, aes(x = component, y = change, fill = country)) +
      geom_col(position = "dodge") +
      labs(
        x = "LPI Component",
        y = paste0("Percent Change (", input$start_year, "–", input$end_year, ")")
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 30, hjust = 1))
  })

  output$summary_stats <- renderText({
    data <- filtered_data()

    avg1 <- mean(data$change[data$country == input$country1], na.rm = TRUE)
    avg2 <- mean(data$change[data$country == input$country2], na.rm = TRUE)

    paste0(
      input$country1, " Average Growth: ", round(avg1, 1), "%
",
      input$country2, " Average Growth: ", round(avg2, 1), "%
",
      "(Across selected components, ", input$start_year, "–", input$end_year, ")"
    )
  })
}

shinyApp(ui = ui, server = server)
