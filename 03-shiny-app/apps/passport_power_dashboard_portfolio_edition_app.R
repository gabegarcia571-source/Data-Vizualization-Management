#===============================================================================
# APP: passport_power_dashboard_portfolio_edition_app.R
# PURPOSE: Shiny app - Portfolio edition dashboard with multiple analytical tabs
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# NOTE: Code preserved as provided; only this header/comment added.
# INPUT: rank_by_year.csv (local file)
#===============================================================================

# =============================================================================
# PASSPORT POWER DASHBOARD - PORTFOLIO EDITION
# Professional-grade Shiny application with advanced analytics
# =============================================================================

# Library Management ----------------------------------------------------------
suppressPackageStartupMessages({
  library(shiny)
  library(shinyWidgets)
  library(tidyverse)
  library(DT)
  library(plotly)
  library(scales)
  library(viridis)
})

# Constants & Configuration ---------------------------------------------------
CONFIG <- list(
  PRIMARY_COUNTRIES = c(
    "Singapore", "Japan", "Germany", "United States", 
    "United Arab Emirates", "Brazil"
  ),
  ANALYSIS_YEARS = c(2006, 2025),
  EXCLUDED_YEARS = c(2007, 2009),
  TOP_N_EXTREMES = 10,
  PLOT_HEIGHT = "500px",
  COLORS = list(
    decline = "#d32f2f",
    small_improvement = "#ffa726",
    major_improvement = "#43a047",
    rank_up = "#2e7d32",
    rank_down = "#c62828",
    rank_neutral = "#757575"
  )
)

KEY_EVENTS <- tibble(
  country = c("United Arab Emirates", "Singapore", "Japan", 
              "Germany", "United States", "Brazil"),
  year = c(2015, 2012, 2008, 2010, 2017, 2010),
  event = c(
    "Major increase in global visa agreements",
    "Business/travel diplomacy increases access",
    "Europe visa-waiver expands passport mobility",
    "Schengen EU consolidation strengthens access",
    "Rapid growth before plateauing",
    "Growth during regional/global expansion"
  ),
  detail = c(
    "Strategic diplomatic reforms transformed UAE from regional to global passport power.",
    "Financial hub status and diplomatic engagement reinforced Singapore's top-tier passport.",
    "EU visa-waiver agreements expanded Japan's already strong global access.",
    "Schengen Area integration positioned Germany at the top tier of travel documents.",
    "Rapid visa-waiver growth plateaued as other nations caught up after 2018.",
    "Regional integration and bilateral agreements steadily improved Brazil's global access."
  )
)

# Data Loading & Validation ---------------------------------------------------
load_data <- function(file_path = "rank_by_year.csv") {
  tryCatch({
    possible_paths <- c(
      file_path,
      file.path(dirname(getwd()), "Downloads", "rank_by_year.csv"),
      file.path(Sys.getenv("USERPROFILE"), "Downloads", "rank_by_year.csv"),
      file.path("~", "Downloads", "rank_by_year.csv")
    )

    valid_path <- NULL
    for (path in possible_paths) {
      if (file.exists(path)) {
        valid_path <- path
        break
      }
    }

    if (is.null(valid_path)) {
      stop(paste0(
        "'rank_by_year.csv' not found. Please ensure the file is in:
",
        "1. Current directory: ", getwd(), "
",
        "2. Or specify full path in load_data() function"
      ))
    }

    data <- read_csv(valid_path, show_col_types = FALSE)

    required_cols <- c("country", "region", "year", "visa_free_count")
    missing_cols <- setdiff(required_cols, names(data))

    if (length(missing_cols) > 0) {
      stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
    }

    message("✓ Data loaded successfully from: ", valid_path)
    data
  }, error = function(e) {
    stop(paste("Failed to load data:", e$message))
  })
}

# Data Transformation Functions -----------------------------------------------
calculate_mobility_changes <- function(data, year_start, year_end) {
  data %>%
    filter(year %in% c(year_start, year_end)) %>%
    group_by(country, region) %>%
    summarise(
      visa_start = visa_free_count[year == year_start],
      visa_end = visa_free_count[year == year_end],
      visa_power_change = visa_end - visa_start,
      .groups = "drop"
    ) %>%
    filter(!is.na(visa_power_change), length(visa_start) > 0, length(visa_end) > 0) %>%
    arrange(visa_power_change)
}

categorize_changes <- function(mobility_data, n_extremes = 10) {
  extremes <- bind_rows(
    slice_head(mobility_data, n = n_extremes),
    slice_tail(mobility_data, n = n_extremes)
  )

  extremes %>%
    mutate(
      change_type = case_when(
        visa_power_change < 0 ~ "Decline",
        visa_power_change <= 20 ~ "Small Improvement",
        TRUE ~ "Major Improvement"
      ),
      change_type = factor(
        change_type,
        levels = c("Decline", "Small Improvement", "Major Improvement")
      )
    )
}

calculate_rankings <- function(data, countries) {
  data %>%
    filter(
      visa_free_count > 0, 
      !is.na(visa_free_count),
      country %in% countries
    ) %>%
    arrange(year, desc(visa_free_count)) %>%
    group_by(year) %>%
    mutate(rank = row_number()) %>%
    ungroup() %>%
    arrange(country, year) %>%
    group_by(country) %>%
    mutate(
      previous_rank = lag(rank),
      change_in_rank = rank - previous_rank,
      previous_visa_free = lag(visa_free_count),
      change_in_free_count = visa_free_count - previous_visa_free,
      rank_indicator = case_when(
        is.na(change_in_rank) ~ "−",
        change_in_rank < 0 ~ "↑",
        change_in_rank > 0 ~ "↓",
        TRUE ~ "−"
      )
    ) %>%
    ungroup()
}

calculate_regional_stats <- function(data) {
  data %>%
    filter(!is.na(visa_free_count), visa_free_count > 0) %>%
    group_by(region, year) %>%
    summarise(
      avg_access = mean(visa_free_count, na.rm = TRUE),
      median_access = median(visa_free_count, na.rm = TRUE),
      min_access = min(visa_free_count, na.rm = TRUE),
      max_access = max(visa_free_count, na.rm = TRUE),
      countries_count = n(),
      .groups = "drop"
    )
}

calculate_growth_rates <- function(data) {
  data %>%
    filter(!is.na(visa_free_count), visa_free_count > 0) %>%
    arrange(country, year) %>%
    group_by(country) %>%
    mutate(
      yoy_change = visa_free_count - lag(visa_free_count),
      yoy_pct_change = (yoy_change / lag(visa_free_count)) * 100
    ) %>%
    filter(!is.na(yoy_pct_change)) %>%
    summarise(
      avg_annual_growth = mean(yoy_change, na.rm = TRUE),
      avg_pct_growth = mean(yoy_pct_change, na.rm = TRUE),
      total_growth = last(visa_free_count) - first(visa_free_count),
      volatility = sd(yoy_change, na.rm = TRUE),
      region = first(region),
      .groups = "drop"
    ) %>%
    arrange(desc(avg_annual_growth))
}

# UI Components ---------------------------------------------------------------
ui <- fluidPage(
  theme = bslib::bs_theme(version = 5, bootswatch = "cosmo"),

  tags$head(
    tags$style(HTML("
      .main-title { 
        font-size: 2.8rem; 
        font-weight: 700; 
        margin-bottom: 0.5rem;
        color: #2c3e50;
        text-align: center;
      }
      .subtitle { 
        color: #7f8c8d; 
        margin-bottom: 2rem;
        font-size: 1.2rem;
        text-align: center;
      }
      .metric-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 15px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      }
      .metric-value {
        font-size: 2.5rem;
        font-weight: 700;
      }
      .metric-label {
        font-size: 0.9rem;
        opacity: 0.9;
      }
      .info-box {
        background: #f8f9fa;
        padding: 15px;
        border-left: 4px solid #667eea;
        margin: 20px 0;
        border-radius: 4px;
      }
    "))
  ),

  div(
    class = "container-fluid",
    div(class = "main-title", "🌍 Global Passport Power Analytics"),
    div(class = "subtitle", "Advanced Interactive Dashboard | Visa-Free Access Trends (2006–2025)"),

    fluidRow(
      column(3, uiOutput("metric_total_countries")),
      column(3, uiOutput("metric_avg_growth")),
      column(3, uiOutput("metric_top_performer")),
      column(3, uiOutput("metric_biggest_gainer"))
    ),

    conditionalPanel(
      condition = "input.tabset === 'Powerhouse Passports'",
      wellPanel(
        style = "background: white; border-radius: 8px;",
        checkboxGroupInput(
          inputId = "countries",
          label = "Select Countries:",
          choices = CONFIG$PRIMARY_COUNTRIES,
          selected = CONFIG$PRIMARY_COUNTRIES,
          inline = TRUE
        )
      )
    ),

    tabsetPanel(
      id = "tabset",
      type = "tabs",

      tabPanel(
        "Powerhouse Passports",
        icon = icon("globe"),
        br(),
        plotlyOutput("power_plot", height = CONFIG$PLOT_HEIGHT),
        br(),
        fluidRow(
          column(6, plotlyOutput("velocity_plot", height = "350px")),
          column(6, plotlyOutput("volatility_plot", height = "350px"))
        ),
        br(),
        actionButton(
          "show_leaderboard", 
          "View Detailed Leaderboard",
          class = "btn-primary",
          icon = icon("table")
        )
      ),

      tabPanel(
        "Power Shift",
        icon = icon("exchange-alt"),
        br(),
        plotOutput("shift_plot", height = "550px"),
        br(),
        div(
          class = "info-box",
          h4("📊 Key Insights"),
          p("This chart reveals the most dramatic shifts in passport power over the past two decades. 
             Countries in the 'Major Improvement' category have added 20+ visa-free destinations, 
             while 'Small Improvement' shows gains under 20 destinations.")
        )
      ),

      tabPanel(
        "Regional Analysis",
        icon = icon("map"),
        br(),
        fluidRow(
          column(12, plotlyOutput("regional_trends", height = "450px"))
        ),
        br(),
        fluidRow(
          column(6, plotlyOutput("regional_distribution", height = "400px")),
          column(6, plotlyOutput("regional_heatmap", height = "400px"))
        )
      ),

      tabPanel(
        "Growth Analytics",
        icon = icon("chart-line"),
        br(),
        fluidRow(
          column(12,
                 selectInput(
                   "growth_region_filter",
                   "Filter by Region:",
                   choices = NULL,
                   selected = NULL
                 )
          )
        ),
        plotlyOutput("growth_scatter", height = "500px"),
        br(),
        h4("Top 15 Growth Champions"),
        DTOutput("growth_table")
      ),

      tabPanel(
        "Race Chart",
        icon = icon("trophy"),
        br(),
        div(
          class = "info-box",
          h4("🏁 Passport Power Race"),
          p("Watch how countries compete for the top positions over time. 
             Use the controls below to animate the rankings.")
        ),
        fluidRow(
          column(3,
                 sliderInput(
                   "race_year",
                   "Select Year:",
                   min = 2006,
                   max = 2025,
                   value = 2006,
                   step = 1,
                   animate = animationOptions(interval = 800, loop = TRUE)
                 )
          ),
          column(3,
                 numericInput(
                   "race_top_n",
                   "Show Top N:",
                   value = 15,
                   min = 5,
                   max = 30
                 )
          ),
          column(6,
                 actionButton("play_race", "▶ Play Animation", class = "btn-success"),
                 actionButton("reset_race", "⟲ Reset", class = "btn-secondary")
          )
        ),
        plotlyOutput("race_chart", height = "600px")
      )
    )
  )
)

# Server Logic ----------------------------------------------------------------
server <- function(input, output, session) {

  raw_data <- load_data()

  mobility_changes <- calculate_mobility_changes(
    raw_data, 
    CONFIG$ANALYSIS_YEARS[1], 
    CONFIG$ANALYSIS_YEARS[2]
  )

  extremes_data <- categorize_changes(mobility_changes, CONFIG$TOP_N_EXTREMES)
  leader_data <- calculate_rankings(raw_data, CONFIG$PRIMARY_COUNTRIES)
  regional_stats <- calculate_regional_stats(raw_data)
  growth_stats <- calculate_growth_rates(raw_data)

  available_years <- sort(unique(raw_data$year))
  available_years <- available_years[!available_years %in% CONFIG$EXCLUDED_YEARS]

  updateSelectInput(session, "growth_region_filter", 
                    choices = c("All Regions", unique(raw_data$region)),
                    selected = "All Regions")

  filtered_leaders <- reactive({
    req(input$countries)
    leader_data %>% filter(country %in% input$countries)
  })

  filtered_growth <- reactive({
    req(input$growth_region_filter)
    if (input$growth_region_filter == "All Regions") {
      growth_stats
    } else {
      growth_stats %>% filter(region == input$growth_region_filter)
    }
  })

  output$metric_total_countries <- renderUI({
    total <- length(unique(raw_data$country))
    div(class = "metric-card",
        div(class = "metric-value", total),
        div(class = "metric-label", "Countries Analyzed"))
  })

  output$metric_avg_growth <- renderUI({
    avg_growth <- mean(mobility_changes$visa_power_change, na.rm = TRUE)
    div(class = "metric-card",
        style = "background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);",
        div(class = "metric-value", sprintf("+%.1f", avg_growth)),
        div(class = "metric-label", "Avg. Growth (2006-2025)"))
  })

  output$metric_top_performer <- renderUI({
    top_country <- raw_data %>%
      filter(year == max(year)) %>%
      arrange(desc(visa_free_count)) %>%
      slice(1) %>%
      pull(country)

    div(class = "metric-card",
        style = "background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);",
        div(class = "metric-value", top_country),
        div(class = "metric-label", "Current #1 Passport"))
  })

  output$metric_biggest_gainer <- renderUI({
    biggest <- mobility_changes %>%
      arrange(desc(visa_power_change)) %>%
      slice(1)

    div(class = "metric-card",
        style = "background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);",
        div(class = "metric-value", paste0(biggest$country)),
        div(class = "metric-label", sprintf("Biggest Gainer (+%d)", biggest$visa_power_change)))
  })

  output$power_plot <- renderPlotly({
    req(nrow(filtered_leaders()) > 0)

    plot_data <- filtered_leaders()
    events_data <- plot_data %>%
      inner_join(KEY_EVENTS, by = c("country", "year"))

    p <- ggplot(plot_data, aes(x = year, y = visa_free_count, 
                               color = country, group = country)) +
      geom_line(linewidth = 1.2, alpha = 0.8) +
      geom_point(
        data = events_data,
        aes(text = paste0(
          "<b>", country, "</b><br>",
          "Year: ", year, "<br>",
          "Visa-Free Access: ", visa_free_count, "<br><br>",
          "<b>", event, "</b><br>",
          detail
        )),
        size = 5,
        alpha = 0.9
      ) +
      scale_y_continuous(labels = comma) +
      scale_color_viridis_d(option = "plasma") +
      labs(
        title = "Regional Passport Power Trends (2006–2025)",
        x = "Year",
        y = "Visa-Free Destinations",
        color = "Country"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold", size = 16, margin = margin(b = 15)),
        panel.grid.minor = element_blank(),
        legend.position = "right",
        plot.background = element_rect(fill = "white", color = NA)
      )

    ggplotly(p, tooltip = "text") %>%
      layout(
        hovermode = "closest",
        legend = list(orientation = "v", x = 1.02, y = 1)
      )
  })

  output$velocity_plot <- renderPlotly({
    req(nrow(filtered_leaders()) > 0)

    velocity_data <- filtered_leaders() %>%
      arrange(country, year) %>%
      group_by(country) %>%
      mutate(velocity = visa_free_count - lag(visa_free_count)) %>%
      filter(!is.na(velocity))

    p <- ggplot(velocity_data, aes(x = year, y = velocity, color = country)) +
      geom_line(linewidth = 1) +
      geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5) +
      scale_color_viridis_d(option = "plasma") +
      labs(
        title = "Growth Velocity (Year-over-Year Change)",
        x = "Year",
        y = "Annual Change",
        color = "Country"
      ) +
      theme_minimal(base_size = 11) +
      theme(
        plot.title = element_text(face = "bold", size = 13),
        legend.position = "right"
      )

    ggplotly(p)
  })

  output$volatility_plot <- renderPlotly({
    req(nrow(filtered_leaders()) > 0)

    volatility_data <- filtered_leaders() %>%
      arrange(country, year) %>%
      group_by(country) %>%
      mutate(velocity = visa_free_count - lag(visa_free_count)) %>%
      filter(!is.na(velocity)) %>%
      summarise(
        volatility = sd(velocity, na.rm = TRUE),
        avg_growth = mean(velocity, na.rm = TRUE),
        .groups = "drop"
      )

    p <- ggplot(volatility_data, aes(x = reorder(country, volatility), 
                                     y = volatility, fill = avg_growth)) +
      geom_col() +
      scale_fill_gradient2(low = "#d32f2f", mid = "#ffa726", high = "#43a047",
                           midpoint = mean(volatility_data$avg_growth)) +
      coord_flip() +
      labs(
        title = "Growth Volatility by Country",
        x = NULL,
        y = "Standard Deviation",
        fill = "Avg Growth"
      ) +
      theme_minimal(base_size = 11) +
      theme(
        plot.title = element_text(face = "bold", size = 13),
        legend.position = "right"
      )

    ggplotly(p)
  })

  observeEvent(input$show_leaderboard, {
    showModal(modalDialog(
      title = tags$h3("🏆 Passport Power Leaderboard", style = "font-weight: 700;"),
      size = "l",

      sliderTextInput(
        inputId = "year",
        label = "Select Year:",
        choices = available_years,
        selected = min(available_years),
        animate = animationOptions(interval = 1000)
      ),

      DTOutput("leaderboard"),

      footer = tagList(modalButton("Close")),
      easyClose = TRUE
    ))
  })

  output$leaderboard <- renderDT({
    req(input$year, input$countries)

    table_data <- leader_data %>%
      filter(
        country %in% input$countries,
        year == as.numeric(input$year)
      ) %>%
      arrange(desc(visa_free_count)) %>%
      transmute(
        ` ` = rank_indicator,
        Rank = row_number(),
        Country = country,
        `Visa-Free Access` = visa_free_count,
        `Annual Change` = replace_na(change_in_free_count, 0)
      )

    datatable(
      table_data,
      rownames = FALSE,
      options = list(
        dom = "t",
        ordering = FALSE,
        pageLength = 20,
        columnDefs = list(
          list(className = "dt-center", targets = 0:1),
          list(width = "50px", targets = 0)
        )
      )
    ) %>%
      formatStyle(
        " ",
        fontWeight = "bold",
        fontSize = "18px",
        color = styleEqual(
          c("↑", "↓", "−"),
          c(CONFIG$COLORS$rank_up, CONFIG$COLORS$rank_down, CONFIG$COLORS$rank_neutral)
        )
      ) %>%
      formatStyle(
        "Rank",
        fontWeight = "bold",
        background = styleInterval(c(1, 3, 5), c("#FFD700", "#C0C0C0", "#CD7F32", "white"))
      )
  })

  output$shift_plot <- renderPlot({
    req(nrow(extremes_data) > 0)

    ggplot(extremes_data, 
           aes(x = reorder(country, visa_power_change), 
               y = visa_power_change,
               fill = change_type)) +
      geom_col(width = 0.7, alpha = 0.9) +
      geom_text(
        aes(label = sprintf("%+d", visa_power_change)),
        hjust = ifelse(extremes_data$visa_power_change > 0, -0.2, 1.2),
        fontface = "bold",
        size = 4
      ) +
      scale_fill_manual(
        values = c(
          "Decline" = CONFIG$COLORS$decline,
          "Small Improvement" = CONFIG$COLORS$small_improvement,
          "Major Improvement" = CONFIG$COLORS$major_improvement
        ),
        name = "Change Category"
      ) +
      scale_y_continuous(labels = comma) +
      coord_flip() +
      labs(
        title = "Global Passport Power Shifts (2006–2025)",
        subtitle = "Most nations expanded visa-free access, though gains remain uneven.
Bolivia is the only country with net decline.",
        x = NULL,
        y = "Change in Visa-Free Destinations"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold", size = 16, margin = margin(b = 5)),
        plot.subtitle = element_text(size = 11, color = "grey40", margin = margin(b = 20)),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "top",
        legend.title = element_text(face = "bold"),
        axis.title.x = element_text(margin = margin(t = 15))
      )
  })

  output$regional_trends <- renderPlotly({
    p <- ggplot(regional_stats, aes(x = year, y = avg_access, color = region, group = region)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 2) +
      scale_color_viridis_d() +
      labs(
        title = "Average Visa-Free Access by Region",
        x = "Year",
        y = "Average Visa-Free Destinations",
        color = "Region"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold", size = 15),
        legend.position = "right"
      )

    ggplotly(p)
  })

  output$regional_distribution <- renderPlotly({
    latest_year <- max(raw_data$year)
    region_data <- raw_data %>%
      filter(year == latest_year, !is.na(visa_free_count), visa_free_count > 0)

    p <- ggplot(region_data, aes(x = region, y = visa_free_count, fill = region)) +
      geom_violin(alpha = 0.7) +
      geom_boxplot(width = 0.2, alpha = 0.5) +
      scale_fill_viridis_d() +
      labs(
        title = paste("Distribution by Region (", latest_year, ")", sep = ""),
        x = NULL,
        y = "Visa-Free Destinations"
      ) +
      theme_minimal(base_size = 11) +
      theme(
        plot.title = element_text(face = "bold", size = 13),
        legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1)
      )

    ggplotly(p)
  })

  output$regional_heatmap <- renderPlotly({
    heatmap_data <- regional_stats %>%
      mutate(year_bin = cut(year, breaks = 4, labels = c("2006-2010", "2011-2015", "2016-2020", "2021-2025")))

    p <- ggplot(heatmap_data, aes(x = year_bin, y = region, fill = avg_access)) +
      geom_tile(color = "white", linewidth = 1) +
      scale_fill_viridis_c(option = "inferno") +
      labs(
        title = "Regional Access Heatmap",
        x = "Time Period",
        y = NULL,
        fill = "Avg Access"
      ) +
      theme_minimal(base_size = 11) +
      theme(
        plot.title = element_text(face = "bold", size = 13),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )

    ggplotly(p)
  })

  output$growth_scatter <- renderPlotly({
    p <- ggplot(filtered_growth(), 
                aes(x = avg_annual_growth, y = volatility, 
                    color = region, size = total_growth,
                    text = paste0(
                      "<b>", country, "</b><br>",
                      "Avg Annual Growth: ", round(avg_annual_growth, 2), "<br>",
                      "Volatility: ", round(volatility, 2), "<br>",
                      "Total Growth: ", total_growth, "<br>",
                      "Region: ", region
                    ))) +
      geom_point(alpha = 0.7) +
      scale_color_viridis_d() +
      scale_size_continuous(range = c(3, 15)) +
      labs(
        title = "Growth vs Volatility Analysis",
        subtitle = "Bubble size represents total growth from 2006-2025",
        x = "Average Annual Growth",
        y = "Volatility (Std Dev)",
        color = "Region",
        size = "Total Growth"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold", size = 15),
        legend.position = "right"
      )

    ggplotly(p, tooltip = "text")
  })

  output$growth_table <- renderDT({
    table_data <- filtered_growth() %>%
      slice_head(n = 15) %>%
      transmute(
        Rank = row_number(),
        Country = country,
        Region = region,
        `Avg Annual Growth` = round(avg_annual_growth, 2),
        `Total Growth` = round(total_growth, 0),
        `Volatility` = round(volatility, 2)
      )

    datatable(
      table_data,
      rownames = FALSE,
      options = list(
        dom = "t",
        pageLength = 15,
        columnDefs = list(
          list(className = "dt-center", targets = c(0, 3, 4, 5))
        )
      )
    ) %>%
      formatStyle(
        "Rank",
        fontWeight = "bold",
        background = styleInterval(c(1, 3, 5), c("#FFD700", "#C0C0C0", "#CD7F32", "white"))
      ) %>%
      formatStyle(
        "Avg Annual Growth",
        background = styleColorBar(range(table_data$`Avg Annual Growth`), "#43a047"),
        backgroundSize = "98% 88%",
        backgroundRepeat = "no-repeat",
        backgroundPosition = "center"
      )
  })

  output$race_chart <- renderPlotly({
    req(input$race_year, input$race_top_n)

    race_data <- raw_data %>%
      filter(
        year == input$race_year,
        !is.na(visa_free_count),
        visa_free_count > 0
      ) %>%
      arrange(desc(visa_free_count)) %>%
      slice_head(n = input$race_top_n) %>%
      mutate(rank = row_number())

    colors <- colorRampPalette(viridis::viridis(10))(nrow(race_data))

    plot_ly(
      race_data,
      x = ~visa_free_count,
      y = ~reorder(country, visa_free_count),
      type = "bar",
      orientation = "h",
      marker = list(
        color = colors,
        line = list(color = "white", width = 1)
      ),
      text = ~paste0(
        "<b>", country, "</b><br>",
        "Rank: #", rank, "<br>",
        "Visa-Free: ", visa_free_count, "<br>",
        "Region: ", region
      ),
      hoverinfo = "text"
    ) %>%
      layout(
        title = list(
          text = paste0("<b>Top ", input$race_top_n, " Passports in ", input$race_year, "</b>"),
          font = list(size = 18)
        ),
        xaxis = list(
          title = "Visa-Free Destinations",
          showgrid = TRUE,
          gridcolor = "#e0e0e0"
        ),
        yaxis = list(
          title = "",
          showgrid = FALSE,
          tickfont = list(size = 11)
        ),
        plot_bgcolor = "#f8f9fa",
        paper_bgcolor = "white",
        margin = list(l = 150, r = 50, t = 80, b = 50),
        showlegend = FALSE
      )
  })

  observeEvent(input$play_race, {
    updateSliderInput(session, "race_year", value = min(available_years))
  })

  observeEvent(input$reset_race, {
    updateSliderInput(session, "race_year", value = min(available_years))
  })
}

shinyApp(ui, server)
