#===============================================================================
# SCRIPT: 01_prototypes.R
# PURPOSE: Early Shiny experiments and debugging preserved verbatim.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 14: Time Series of Leading Powerhouse Passports with Plot SHINY (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Time Series of Leading Powerhouse Passports with Plot SHINY
library(shiny)
library(shinyWidgets)

selected_countries <- c(
  "Singapore",        # Asian powerhouse
  "Japan",            # Traditional Asian leader
  "Germany",          # European Leader
  "United States",    # North American Leader 
  "United Arab Emirates",  # Rising Middle Eastern Leader
  "Brazil"           # South American Leader
)

leader_growth <- rank_by_year %>%
    filter(visa_free_count >0, !is.na(visa_free_count)) %>%
    filter(country %in% selected_countries)

true_years <- sort(unique(leader_growth$year))
true_years <- true_years[!true_years %in% c(2007, 2009)]

ui <- fluidPage(
  titlePanel("Passport Power: Across Context"),
  p("Interactive exploration of visa-free access (2006–2025)"),
  checkboxGroupInput(
    "countries",
    "Filter Countries:",
    choices  = selected_countries,
    selected = selected_countries,
    inline = TRUE),
  
  
  conditionalPanel(
    condition = "input.second == 'Powerhouse Leaderboard'",
    sliderTextInput(
      inputId  = "year",
      label    = "Year:",
      choices  = true_years,
      selected = min(true_years),
      animate  = TRUE)),
 
  
   tabsetPanel(id = "second",
    tabPanel("Powerhouse Leaderboard",
      tableOutput("leaderboard")),
    tabPanel("Trends",
      plotOutput("power_plot", height = "450px")),
    tabPanel("Biggest Improvers",
      plotOutput("improvers_plot", height = "450px"))
  )
)


server <- function(input, output, session) {
  
filtered_data <- reactive({leader_growth %>%
    filter(country %in% input$countries)})

leaderboard_data <- reactive({
    filtered_data() %>%
      filter(year == input$year) %>%
      arrange(desc(visa_free_count))})

output$power_plot <- renderPlot({
    ggplot(filtered_data(), aes(
      x = year,
      y= visa_free_count,
      color = country,
      group = country)) +
    geom_line() +
    labs(title = "Passport Power: The Powerhouses (2006-2025)",
         subtitle = "Powerhouse Countries are reaching maturity",
       x = "Year",
       y = "Visa-Free Destinations",
       color = "Country") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 14))})

output$leaderboard <- renderTable({
    leaderboard_data() %>%
      transmute(
        Rank = row_number(),
        Country = country,
        `Visa-Free Destinations` = visa_free_count)})

output$improvers_plot <- renderPlot({ggplot(low_mobility_growth, aes(x = reorder(country, visa_power_gain), y = visa_power_gain)) +
  geom_col(fill = "green4", alpha = 0.8) +
  geom_text(aes(label = paste0("+", visa_power_gain)), 
            hjust = -0.2, size = 3.5, fontface = "bold") +
  coord_flip() +
  labs(title = "Passport Power: Biggest Improvers (2006-2025)",
       subtitle = "Countries starting with ≤20 visa-free destinations in 2006",
       x = NULL,
       y = "Increase in Visa-Free Destinations") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 14))})
}

shinyApp(ui, server)

#-------------------------------------------------------------------------------
# CHUNK 17: shiny app tweaks (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] shiny app tweaks
##Direct copy paste graph into ggplot output table but change so filters dont show up on that tab. Debug 

ui <- fluidPage(
  titlePanel("Passport Power: Across Context"),
  p("Interactive exploration of visa-free access (2006–2025)"),
  checkboxGroupInput(
    "countries",
    "Filter Countries:",
    choices  = selected_countries,
    selected = selected_countries,
    inline = TRUE),
  
  conditionalPanel(
    condition = input.tabset != #name it
      ))

#-------------------------------------------------------------------------------
# CHUNK 18: Filter doesnt show up (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Filter doesnt show up
##Since we want the checboxes to show up for the otehr two we can put it inside the conditional statement and just make the power shift tab not true so it shows up when not on that tab
ui <- fluidPage(
  titlePanel("Passport Power: Across Context"),
  p("Interactive exploration of visa-free access (2006–2025)"),
  
  conditionalPanel(
    condition = "input.tabset != 'Power Shift'",  
    checkboxGroupInput(
      "countries",
      "Filter Countries:",
      choices  = selected_countries,
      selected = selected_countries,
      inline = TRUE))
