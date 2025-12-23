#===============================================================================
# APP: app.R
# TITLE: Interactive Passport Power Explorer (Shiny)
# PURPOSE: Final working Shiny app extracted verbatim from the author’s Rmd.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# NOTE: Code below is unchanged; only this header comment was added.
#===============================================================================

library(shiny)
library(shinyWidgets)
library(jsonlite)
library(tidyverse)
library(DT)
library(plotly)
library(readxl)

rank_by_year <- read_csv("rank_by_year.csv")

mobility_changes <- rank_by_year %>%
  filter(year %in% c(2006, 2025)) %>%
  group_by(country, region) %>%
  summarise(
    visa_2006 = visa_free_count[year == 2006],
    visa_2025 = visa_free_count[year == 2025],
    visa_power_change = visa_2025 - visa_2006,
    .groups = "drop") %>%
  arrange(visa_power_change)


tail_extremes <- mobility_changes %>%
  slice_head(n = 10) %>%       
  bind_rows(mobility_changes %>% 
              slice_tail(n = 10))

tail_extremes <- tail_extremes %>%
  mutate(change_type = case_when(
    visa_power_change < 0 ~ "Decline",
    visa_power_change <= 20 ~ "Small Improvement",
    TRUE ~ "Major Improvement"),
    change_type = factor(change_type,
                         levels = c("Decline", "Small Improvement","Major Improvement" )))

selected_countries <- c(
  "Singapore",        # Asian powerhouse
  "Japan",            # Traditional Asian leader
  "Germany",          # European Leader
  "United States",    # North American Leader 
  "United Arab Emirates",  # Rising Middle Eastern Leader
  "Brazil"           # South American Leader
)

key_events <- tibble::tibble(country = c(
  "United Arab Emirates",
  "Singapore",
  "Japan",
  "Germany",
  "United States",
  "Brazil"),
  year = c(
    2015,  
    2012, 
    2008, 
    2010, 
    2017, 
    2010),
  event = c(
    "Major increase in global visa agreements",
    "Business/travel diplomacy increases access",
    "Europe visa-waiver expands passport mobility",
    "Schengen EU consolidation strengthens access",
    "Rapid growth before plateauing",
    "Growth during regional/global expansion"),
  detail = c(
    "Strategic diplomatic reforms transformed UAE from regional to global passport power.",
    "Financial hub status and diplomatic engagement reinforced Singapore's top-tier passport.",
    "EU visa-waiver agreements expanded Japan's already strong global access.",
    "Schengen Area integration positioned Germany at the top tier of travel documents.",
    "Rapid visa-waiver growth plateaued as other nations caught up after 2018.",
    "Regional integration and bilateral agreements steadily improved Brazil's global access."))


leader_growth <- rank_by_year %>%
  filter(visa_free_count >0, !is.na(visa_free_count)) %>%
  filter(country %in% selected_countries)

leader_growth_change <- leader_growth %>%
  arrange(year, desc(visa_free_count)) %>%  
  group_by(year) %>%                        
  mutate(rank = row_number()) %>%
  ungroup() %>%
  arrange(country, year) %>%
  group_by(country) %>%
  mutate(
    previous_rank = lag(rank),
    change_in_rank = rank - previous_rank,
    previous_visa_free_count = lag(visa_free_count),
    change_in_free_count = visa_free_count - previous_visa_free_count,
    indicator = case_when(
      change_in_rank < 0 ~ "↑",
      change_in_rank > 0 ~ "↓",   
      is.na(change_in_rank) ~ "-",  
      TRUE ~ "-"
    )
  ) %>%
  ungroup()


true_years <- sort(unique(leader_growth$year))
true_years <- true_years[!true_years %in% c(2007, 2009)]

ui <- fluidPage(
  titlePanel("Passport Power: Across Context"),
  p("Interactive exploration of visa-free access (2006–2025)"),
  
  conditionalPanel(
    condition = "input.tabset != 'Power Shift'",  
    checkboxGroupInput(
      "countries",
      "Filter Countries:",
      choices = selected_countries,
      selected = selected_countries,
      inline = TRUE)
  ),
  
  tabsetPanel(id = "tabset",
              tabPanel("Powerhouse Passports",
                       h3("Powerhouse Passport Trends"),
                       plotlyOutput("power_plot", height = "400px"),
                       actionButton("show_leaderboard", "View Leaderboard Table")),
              tabPanel("Power Shift",
                       plotOutput("improvers_plot", height = "450px"))
  )
)

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    leader_growth %>%
      filter(country %in% input$countries)})
  
  leaderboard_data <- reactive({
    filtered_data() %>%
      filter(year == input$year) %>%
      arrange(desc(visa_free_count))})
  
  output$power_plot <- renderPlotly({
    events_data <- filtered_data() %>%
      inner_join(key_events, by = c("country", "year"))
    trend_plot <- ggplot(filtered_data(), aes(
      x = year,
      y = visa_free_count,
      color = country,
      group = country)) +
      geom_point(data = events_data, aes(text = paste0(
        "<b>", country, "</b><br>",
        "Year: ", year, "<br>",
        "Visa-Free Access: ", visa_free_count, "<br><br>",
        "<b>", event, "</b><br>",
        detail)),
        size = 3)+
      geom_line() +
      labs(title = "The Regional Power Players (2006-2025)",
           x = "Year",
           y = "Visa-Free Destinations",
           color = "Country") +
      theme_minimal() +
      theme(panel.grid.major.y = element_blank(),
            plot.title = element_text(face = "bold", size = 14))
    
    ggplotly(trend_plot, tooltip = "text") %>%
      layout(title = list(text = "The Regional Power Players (2006–2025)"))%>%
      style(hoverinfo = "text")
  })
  
  observeEvent(input$show_leaderboard, {
    showModal(modalDialog(
      title = "Powerhouse Leaderboard",
      sliderTextInput(
        inputId = "year",
        label = "Select Year:",
        choices = true_years,
        selected = min(true_years),
        animate = TRUE
      ),
      dataTableOutput("leaderboard"),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  
  output$leaderboard <- DT::renderDT({
    leaderboard_table <- leader_growth_change %>%
      filter(country %in% input$countries,
             year == as.numeric(input$year)) %>%
      arrange(desc(visa_free_count)) %>%
      transmute(Leaderboards = as.character(indicator),
                Rank = row_number(),
                Country = country,
                `Visa-Free Destinations` = visa_free_count,
                `Year over Change` = change_in_free_count
      ) 
    DT::datatable(
      leaderboard_table,
      rownames = FALSE,
      escape = FALSE,
      options = list(dom = "t",
                     ordering = FALSE,
                     autoWidth = TRUE)) %>%
      formatStyle("Leaderboards",
                  fontWeight = "bold",
                  color = DT::styleEqual(
                    c("↑", "↓", "-"),
                    c("green", "red", "gray")
                  )
      )
  })
  
  
  output$improvers_plot <- renderPlot({
    ggplot(tail_extremes, aes(x = reorder(country, visa_power_change),
                              y = visa_power_change,
                              fill = change_type)) +
      geom_col() +
      geom_text(aes(label = ifelse(visa_power_change > 0,
                                   paste0("+", visa_power_change),
                                   as.character(visa_power_change))),
                hjust = ifelse(tail_extremes$visa_power_change > 0, -0.2, 1.2),
                fontface = "bold", size = 3) +
      scale_fill_manual(values = c("Decline" = "red3",
                                   "Small Improvement" = "gold",
                                   "Major Improvement" = "mediumseagreen"),
                        name = "Change Category") +
      coord_flip() +
      labs(title = "How Passport Power Has Shifted Around the World (2006–2025)",
           subtitle = "Most countries gained visa-free access, but gains have been uneven and Bolivia is \nthe only country that has lost visa-free access since 2006",
           x = NULL,
           y = "Change in Visa-Free Destinations")+
      theme_minimal() +
      theme(panel.grid.major.y = element_blank(),
            plot.title = element_text(face = "bold", size = 14),
            legend.position = "top",
            axis.title.x = element_text(vjust = -2))
  })
} 
  shinyApp(ui, server)
