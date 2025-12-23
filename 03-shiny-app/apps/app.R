#===============================================================================
# APP: lpi-growth-explorer (Shiny)
# PURPOSE: Compare a selected country's LPI component growth to its region benchmark
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# DEPENDENCIES: readxl, dplyr, purrr, janitor, countrycode, tidyr, ggplot2, shiny
# INPUT: data/International_LPI_from_2007_to_2023_0.xlsx (one sheet per year)
# OUTPUT: Interactive Shiny UI with a component-level growth comparison bar chart
#===============================================================================

# SETUP -----------------------------------------------------------------------
library(readxl)
library(dplyr)
library(purrr)
library(janitor)
library(countrycode)
library(tidyr)
library(ggplot2)
library(shiny)

# NOTE: gganimate/plotly are not used in this app currently; remove if unused.
# library(gganimate)
# library(plotly)

# FILE PATH -------------------------------------------------------------------
# Keep paths relative so the app works when run from this folder via shiny::runApp()
file_path <- file.path("data", "International_LPI_from_2007_to_2023_0.xlsx")

if (!file.exists(file_path)) {
  stop(
    paste0(
      "Missing data file: ", file_path, "\n\n",
      "Add the Excel file to this location and re-run the app.\n",
      "Expected: one sheet per year (e.g., '2007', '2010', ...)."
    ),
    call. = FALSE
  )
}

# CONSTANTS -------------------------------------------------------------------
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

# Some country names won't map cleanly; force a few into regions manually
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

# DATA IMPORT -----------------------------------------------------------------
sheets <- excel_sheets(file_path)

dataLPI_all <- map_dfr(sheets, function(sh) {
  read_excel(file_path, sheet = sh) %>%
    clean_names() %>%
    mutate(year = as.integer(sh))
})

# DATA ENRICHMENT -------------------------------------------------------------
dataLPI_all <- dataLPI_all %>%
  mutate(
    region = if_else(
      country %in% names(manual_regions),
      manual_regions[country],
      countrycode(country, origin = "country.name", destination = "continent")
    )
  ) %>%
  filter(!is.na(region))

# UI --------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Country vs. Regional Benchmarking: Component-Level Growth"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "region2",
        "Select Region:",
        choices = sort(unique(dataLPI_all$region))
      ),
      uiOutput("country_ui"),
      checkboxInput("show_regional", "Overlay Regional Average", value = FALSE),
      hr(),
      helpText(
        "Compare individual country growth rates to regional averages. ",
        "Bars show percent change from earliest to latest survey for each component."
      )
    ),
    mainPanel(plotOutput("growth_plot", height = "550px"))
  )
)

# SERVER ----------------------------------------------------------------------
server <- function(input, output, session) {

  # Dynamically populate country list based on chosen region
  output$country_ui <- renderUI({
    req(input$region2)

    countries <- dataLPI_all %>%
      filter(region == input$region2) %>%
      distinct(country) %>%
      arrange(country) %>%
      pull(country)

    selectInput("country", "Select Country:", choices = countries)
  })

  # Render growth comparison plot
  output$growth_plot <- renderPlot({
    req(input$country, input$region2)

    # Country series
    country_data <- dataLPI_all %>%
      filter(country == input$country) %>%
      select(year, all_of(component_cols)) %>%
      pivot_longer(
        cols = all_of(component_cols),
        names_to = "component",
        values_to = "score"
      ) %>%
      mutate(
        component = recode(component, !!!component_labels),
        type = "Country"
      )

    # Optional regional average series
    if (isTRUE(input$show_regional)) {
      regional_data <- dataLPI_all %>%
        filter(region == input$region2) %>%
        select(year, all_of(component_cols)) %>%
        pivot_longer(
          cols = all_of(component_cols),
          names_to = "component",
          values_to = "score"
        ) %>%
        group_by(component, year) %>%
        summarise(score = mean(score, na.rm = TRUE), .groups = "drop") %>%
        mutate(
          component = recode(component, !!!component_labels),
          type = "Regional Avg"
        )

      plot_data <- bind_rows(country_data, regional_data)
    } else {
      plot_data <- country_data
    }

    # Growth calculation: earliest to latest year available per series/component
    growth <- plot_data %>%
      group_by(component, type) %>%
      summarise(
        start = score[which.min(year)],
        end = score[which.max(year)],
        growth_pct = (end - start) / start * 100,
        .groups = "drop"
      )

    ggplot(
      growth,
      aes(
        x = reorder(component, growth_pct),
        y = growth_pct,
        fill = component
      )
    ) +
      geom_col(
        aes(alpha = type),
        position = position_dodge(width = 0.8),
        width = 0.7
      ) +
      coord_flip() +
      scale_fill_manual(values = component_palette, guide = "none") +
      scale_alpha_manual(
        values = c("Country" = 1, "Regional Avg" = 0.5),
        name = "Comparison"
      ) +
      labs(
        title = paste(input$country, "vs.", input$region2, "Regional Average"),
        subtitle = "Component-level growth rates (earliest to latest survey)",
        x = NULL,
        y = "Growth (%)",
        caption = "Source: World Bank LPI | Toggle regional average to benchmark performance"
      ) +
      theme(
        axis.text.y = element_text(size = 13, face = "bold"),
        legend.position = "top",
        legend.title = element_text(size = 11)
      )
  })
}

shinyApp(ui, server)
