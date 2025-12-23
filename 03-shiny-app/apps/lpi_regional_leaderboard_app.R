#===============================================================================
# APP: lpi_regional_leaderboard_app.R
# PURPOSE: Shiny app - Regional LPI leaderboard with animated year slider
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# NOTE: Code preserved as provided; only this header/comment added.
# INPUT: International_LPI_from_2007_to_2023_0 (1).xlsx (local file)
#===============================================================================

library(readxl)
library(dplyr)
library(purrr)
library(janitor)
library(countrycode)
library(tidyr)
library(ggplot2)
library(shiny)
library(gganimate)
library(plotly)

file_path <- "International_LPI_from_2007_to_2023_0 (1).xlsx"

component_cols <- c(
  "customs_score", 
  "infrastructure_score", 
  "international_shipments_score", 
  "logistics_competence_and_quality_score", 
  "timeliness_score", 
  "tracking_and_tracing_score"
)

component_labels <- c(
  customs_score = "Customs",
  infrastructure_score = "Infrastructure",
  international_shipments_score = "Intl Shipments",
  logistics_competence_and_quality_score = "Logistics Quality",
  timeliness_score = "Timeliness",
  tracking_and_tracing_score = "Tracking"
)

component_palette <- c(
  "Customs" = "#8B0000",           
  "Infrastructure" = "#00008B",    
  "Intl Shipments" = "#228B22",   
  "Logistics Quality" = "#FF8C00", 
  "Timeliness" = "#FF4500",      
  "Tracking" = "#C71585"          
)

region_palette <- c(
  "Africa" = "#9370DB",      
  "Americas" = "#4682B4", 
  "Asia" = "#2F4F2F",        
  "Europe" = "#DAA520",      
  "Oceania" = "#8B4513"      
)

primary_color <- "#4682B4"

manual_regions <- c(
  "Hong Kong SAR, China" = "Asia",
  "Taiwan, China" = "Asia",
  "Korea, Rep." = "Asia",
  "Korea, Dem. Rep." = "Asia",
  "Congo, Dem. Rep." = "Africa",
  "Congo, Rep." = "Africa",
  "Egypt, Arab Rep." = "Africa",
  "Iran, Islamic Rep." = "Asia",
  "Russian Federation" = "Europe"
)

custom_theme <- theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0, margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "gray30", hjust = 0, margin = margin(b = 15)),
    plot.caption = element_text(size = 9, color = "gray50", hjust = 1, margin = margin(t = 10)),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 11),
    legend.title = element_text(size = 11, face = "bold"),
    legend.text = element_text(size = 10),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray90"),
    plot.margin = margin(15, 15, 15, 15)
  )

theme_set(custom_theme)

# load all sheets and build dataLPI_all
sheets <- excel_sheets(file_path)

dataLPI_all <- map_dfr(sheets, function(sh) {
  read_excel(file_path, sheet = sh) %>%
    clean_names() %>%
    mutate(year = as.integer(sh))
})

dataLPI_all <- dataLPI_all %>%
  mutate(
    region = if_else(
      country %in% names(manual_regions), 
      manual_regions[country],
      countrycode(country, origin = "country.name", destination = "continent")
    )
  ) %>%
  filter(!is.na(region))


survey_years <- c(2007, 2010, 2012, 2014, 2016, 2018, 2023)

ui <- fluidPage(
  titlePanel("Regional LPI Leaderboard: Track Leaders Over Time"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Select Region:", 
                  choices = sort(unique(dataLPI_all$region))),
      selectInput("top_n", "Number of Countries to Display:",
                  choices = c(3, 5, 7, 10),
                  selected = 5),
      sliderInput("year", "Select Year:", 
                  min = min(survey_years),
                  max = max(survey_years),
                  value = max(survey_years),
                  step = NULL,
                  animate = animationOptions(interval = 1500, loop = TRUE),
                  sep = ""),
      hr(),
      helpText("Use the play button to animate rankings over time. Different regions show different patterns of leadership stability.")
    ),
    mainPanel(
      plotOutput("leaderboard", height = "550px")
    )
  )
)

server <- function(input, output, session) {
  observe({
    updateSliderInput(session, "year",
                      min = min(survey_years),
                      max = max(survey_years),
                      value = input$year,
                      step = NULL)
  })

  output$leaderboard <- renderPlot({
    req(input$region, input$year)

    closest_year <- survey_years[which.min(abs(survey_years - input$year))]

    top_countries <- dataLPI_all %>%
      filter(region == input$region, year == closest_year) %>%
      arrange(desc(lpi_score)) %>%
      head(as.numeric(input$top_n))

    ggplot(top_countries, aes(x = reorder(country, lpi_score), y = lpi_score)) +
      geom_col(fill = primary_color, width = 0.7, alpha = 0.9) +
      geom_text(aes(label = round(lpi_score, 2)), 
                hjust = -0.2, size = 5.5, fontface = "bold", color = "gray20") +
      coord_flip() +
      labs(
        title = paste("Top", input$top_n, "Logistics Performers in", input$region),
        subtitle = paste("Year:", closest_year, "| Scores range from 1 (worst) to 5 (best)"),
        x = NULL,
        y = "LPI Score",
        caption = "Source: World Bank LPI | Countries ranked by overall logistics performance"
      ) +
      theme(
        axis.text.y = element_text(size = 13, face = "bold"),
        plot.title = element_text(size = 16, face = "bold")
      ) +
      expand_limits(y = 5)
  })
}

shinyApp(ui, server)
