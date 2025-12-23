#===============================================================================
# SCRIPT: analysis.R
# TITLE: Passport Power Evolution (Henley-style mobility over time)
# PURPOSE: Reproduce the author’s passport ranking analysis, including ‘winners vs losers’ framing and time series visuals.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# DEPENDENCIES: (see library() calls below; preserved from source)
#
# IMPORTANT:
# - Code blocks below are extracted verbatim from the original .Rmd source.
# - Only comments/section headers were added for readability; logic is unchanged.
# - Hard-coded paths (if any) are preserved exactly as written in the source.
#===============================================================================

#===============================================================================
# CHUNK 1: setup
# RMD HEADER: {setup, include=FALSE}
#===============================================================================

knitr::opts_chunk$set(echo = TRUE)


#===============================================================================
# CHUNK 2: data upload
# RMD HEADER: {data upload}
#===============================================================================

# NOTE: The Windows path below is preserved exactly from the author’s source.
#       Update file_path to your local environment for portability if needed.
##Use these two libraries because JSON is a text format that stores structured data and this way the data wont be just text strings. tidyverse for data manipulation and for its use with ggplot.
library(jsonlite)
library(tidyverse)

rank_by_year <- read_csv("C:\\Users\\12022\\Downloads\\Shiny_Tidy_UI_Experiment\\rank_by_year.csv")
country_lists <- read_csv("C:\\Users\\12022\\Downloads\\country_lists.csv")


#===============================================================================
# CHUNK 3: data view
# RMD HEADER: {data view}
#===============================================================================

glimpse(rank_by_year)
summary(rank_by_year)
head(country_lists)


#===============================================================================
# CHUNK 4: Historically Weak Passport Gains attempt 1
# RMD HEADER: {Historically Weak Passport Gains attempt 1}
#===============================================================================
# The Henley Passport Indext dataset tracks the strength of passports from 2006 to 2025 for all countries. Each row represents a country each year with variables for its region, number of destinations travelers can go without a pre-visa, and its global ranking. The JSON files in country_lists classify the type of visa entry: visa free, visa on arrival, electronic travel, or required visa for travel. The rank_by_year dataset gives us ranking of countries that do not require a visa for passport holders when entering their country.

low_mobility_growth <- rank %>%
  filter(year == 2006 if rank<20) %>%
  count(visa_free_count) %>%
  mutate(visa_free_count_change('visa_free_count %in% year==2025'- 'visa_free_count %in% year==2006')) %>%
    select(country,year, visa_free_count_change)%>%
  arrange(desc(country based on visa_free_count_change))%>%
  slice_head(n=20) %>%


#===============================================================================
# CHUNK 5: Historically Weak Passport Gains attempt 2
# RMD HEADER: {Historically Weak Passport Gains attempt 2}
#===============================================================================

##Mutate still not working debug? something about the way its named visa_free_count %in% isnt working. 
low_mobility_growth <- rank_by_year %>% 
  filter(year == 2006 & visa_free_count < 20) %>% 
  count(visa_free_count) %>%
  mutate(visa_free_count_change('visa_free_count %in% year==2025'- 'visa_free_count %in% year==2006')) %>%
    select(country, year, visa_free_count_change) %>%
  arrange(desc(country, visa_free_count_change)) %>%
  slice_head(n=20) %>%


#===============================================================================
# CHUNK 6: Historically Weak Passport Gains attempt 3
# RMD HEADER: {Historically Weak Passport Gains attempt 3}
#===============================================================================

##count was the wrong way to find the number of visas in a country. Mutating syntax sould only affect df, not the name added after in previous itteration. Filtering for the years I wanted and then mutating to get the count 
low_mobility_growth <- rank_by_year %>% 
  filter(year %in% c(2006, 2025)) %>%
  group_by(country) %>%
  filter(n() == 2) %>%  
  mutate(
    visa_2006 = visa_free_count[year == 2006],
    visa_2025 = visa_free_count[year == 2025],
    visa_free_count_change = visa_2025 - visa_2006
  ) %>%
  filter(visa_2006 <= 20) %>%
  ungroup() %>%
  arrange(desc(visa_free_count_change)) %>%
  slice_head(n = 15) %>%
  select(country, visa_2006, visa_2025, visa_free_count_change)


#===============================================================================
# CHUNK 7: Historically Weak Passport Gains attempt Final
# RMD HEADER: {Historically Weak Passport Gains attempt Final}
#===============================================================================

##Mutating for some reason wasnt showing 15 countries. Switched to summarize and it works. I checked what the data looked like with mutate and it had observations for the same country in two rows but the years were missing so I think it was counting the top 15 which included only 7 countries.
low_mobility_growth <- rank_by_year %>%
  filter(year %in% c(2006, 2025)) %>%
  group_by(country) %>%
  filter(n() == 2) %>%
  summarize(
    visa_2006 = visa_free_count[year == 2006],
    visa_2025 = visa_free_count[year == 2025],
    visa_power_gain = visa_2025 - visa_2006
  ) %>%
  filter(visa_2006 <= 20) %>%
  arrange(desc(visa_power_gain)) %>%
  slice_head(n = 15)


#===============================================================================
# CHUNK 8: Historically Weak Passport Gains Final Plot
# RMD HEADER: {Historically Weak Passport Gains Final Plot}
#===============================================================================

##going forward use hjust for heig
ggplot(low_mobility_growth, aes(x = reorder(country, visa_power_gain), y = visa_power_gain)) +
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
        plot.title = element_text(face = "bold", size = 14))


#===============================================================================
# CHUNK 9: Time Series of Leading Powerhouse Passports attempt 1
# RMD HEADER: {Time Series of Leading Powerhouse Passports attempt 1}
#===============================================================================

leader_growth <- rank_by_year %>%
  group_by(country) %>%
  arrange(asc(visa_free_count)) %>%
  slice(head(n = 7)) %>%
  filter(country %in% leader_growth)


#===============================================================================
# CHUNK 10: Time Series of Leading Powerhouse Passports attempt 2
# RMD HEADER: {Time Series of Leading Powerhouse Passports attempt 2}
#===============================================================================

##Use desc as arranger and slice the top off to get highest passports. Also using simpler names for data frames.
leaders <- rank_by_year %>%
  filter(year %in% 2025) %>%
  arrange(desc(visa_free_count)) %>%
  slice_head(n=7) %>%
  pull(country)

leader_growth <- rank_by_year %>%
  filter(country %in% leaders)

ggplot(leader_growth, aes(x = year,
                          y= visa_free_count,
                          color = country,
                          group = country)) +
  geom_line() +
   labs(title = "Passport Power: The Powerhouses (2006-2025)",
       subtitle = "Countries with the highest visa-free access leaderboard changes",
       x = "Year",
       y = "Visa-Free Destinations",
       color = "Country") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 14))


#===============================================================================
# CHUNK 11: Time Series of Leading Powerhouse Passports attempt 3
# RMD HEADER: {Time Series of Leading Powerhouse Passports attempt 3}
#===============================================================================

##2007 and 2008 were dropping visa access and I couldnt debug why so I had them droped from the leader growth data frame. proper syntax: filter(variable >0 !is.na(variable))
leaders <- rank_by_year %>%
  filter(year %in% 2025) %>%
  arrange(desc(visa_free_count)) %>%
  slice_head(n=7) %>%
  pull(country)

leader_growth <- rank_by_year %>%
  filter(country %in% leaders)

leader_growth_clean <- leader_growth %>%
  filter(visa_free_count >0, !is.na(visa_free_count))

ggplot(leader_growth_clean, aes(x = year,
                          y= visa_free_count,
                          color = country,
                          group = country)) +
  geom_line() +
   labs(title = "Passport Power: The Powerhouses (2006-2025)",
       subtitle = "Countries with the highest visa-free access leaderboard changes",
       x = "Year",
       y = "Visa-Free Destinations",
       color = "Country") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 14))


#===============================================================================
# CHUNK 12: US Check
# RMD HEADER: {US Check}
#===============================================================================

##US doesnt show up because its tied. At the top of the leaderboards countries are getting to maturity so it would make sense to choose leaders in each region. US is 10th tied so iterate
rank_by_year %>%
  filter(grepl("united|america|USA|US", country, ignore.case = TRUE)) %>%
  distinct(country)

rank_by_year %>%
  filter(year %in% 2025) %>%
  filter(grepl("united|states|america|USA", country, ignore.case = TRUE))

rank_by_year %>%
  filter(year %in% 2025) %>%
  arrange(desc(visa_free_count)) %>%
  slice_head(n = 20) %>%
  select(country, visa_free_count)


#===============================================================================
# CHUNK 13: Time Series of Leading Powerhouse Passports with Plot
# RMD HEADER: {Time Series of Leading Powerhouse Passports with Plot}
#===============================================================================

## choose countries in significant regions. Same logic applies, country %in%
selected_countries <- c(
  "Singapore",        # Asian New
  "Japan",            # Traditional Asian 
  "Germany",          # European 
  "United States",    # North American  
  "United Arab Emirates",  # New Middle Eastern 
  "Brazil"           # South American 
)

leader_growth <- rank_by_year %>%
    filter(visa_free_count >0, !is.na(visa_free_count)) %>%
    filter(country %in% selected_countries)

powerhouse_plot <- ggplot(leader_growth, aes(x = year,
                          y= visa_free_count,
                          color = country,
                          group = country)) +
  geom_line() +
   labs(title = "Passport Power: The Powerhouses (2006-2025)",
       subtitle = "Countries with the highest visa-free access leaderboard changes",
       x = "Year",
       y = "Visa-Free Destinations",
       color = "Country") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 14))

ggsave("powerhouse_trends.png", 
       plot = powerhouse_plot,
       width = 10, 
       height = 6, 
       dpi = 300)


#===============================================================================
# CHUNK 14: Time Series of Leading Powerhouse Passports with Plot SHINY
# RMD HEADER: {Time Series of Leading Powerhouse Passports with Plot SHINY}
#===============================================================================

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


#===============================================================================
# CHUNK 15: visa power changes broader/more informative
# RMD HEADER: {visa power changes broader/more informative}
#===============================================================================

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

power_shift_plot <- ggplot(tail_extremes, aes(x = reorder(country, visa_power_change),
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
 labs(
  title = "How Passport Power Has Shifted Around the World (2006–2025)",
  subtitle = "Most countries gained visa-free access, but gains have been uneven and Bolivia is \nthe only country that has lost visa-free access since 2006",
  x = NULL,
  y = "Change in Visa-Free Destinations")+
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 14),
        legend.position = "top",
        axis.title.x = element_text(vjust = -3))

ggsave("power_shift.png", 
       plot = power_shift_plot,
       width = 10, 
       height = 6, 
       dpi = 300)


#===============================================================================
# CHUNK 16: confirm bolivia is low
# RMD HEADER: {confirm bolivia is low}
#===============================================================================

##only country without growth is indeed bolivia. Thinking to show low growth as a seperate category instead
mobility_changes %>%
  filter(visa_power_change < 0) %>%
  arrange(visa_power_change)


#===============================================================================
# CHUNK 17: shiny app tweaks
# RMD HEADER: {shiny app tweaks}
#===============================================================================

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


#===============================================================================
# CHUNK 18: Filter doesnt show up
# RMD HEADER: {Filter doesnt show up}
#===============================================================================

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


#===============================================================================
# CHUNK 19: rank cleaning and visuals logic line
# RMD HEADER: {rank cleaning and visuals logic line}
#===============================================================================

##Possible Idea and Logic Line
##Add a arrow or track changes in leaderboard. If equal gray, if rising green, if dropping red. run some sort of loop within each year. some sort of change calculation. Current rank - previous rank. This is for the leader growth set. So if change is positive , dropped rank, red arrow down. If change is negative, rose rank, green arrow up. If zero, same rank, gray dash. 

leader_growth <- rank_by_year %>%
    filter(visa_free_count >0, !is.na(visa_free_count)) %>%
    filter(country %in% selected_countries)

view(leader_growth)


#===============================================================================
# CHUNK 20: rank ordering data
# RMD HEADER: {rank ordering data}
#===============================================================================

##order the data 
leader_growth <- leader_growth %>%
  arrange(country, year)%>%
  group_by(country)

view(leader_growth)


#===============================================================================
# CHUNK 21: rank mutating attempt 1
# RMD HEADER: {rank mutating attempt 1}
#===============================================================================

##This worked! I have changes in ranks as negative or positive. Unfortunately, its the wrong thing. the rank in the leaderboard table is based on row which is based on visas. But the logic remains the same, just different variables.
leader_growth_change <- leader_growth %>%
  mutate(
   previous_rank = lag(rank),
   change_in_rank = rank - previous_rank)%>%
  select(country,year,rank,previous_rank,change_in_rank)%>%
  ungroup()

view(leader_growth_change)


#===============================================================================
# CHUNK 22: rank mutating attempt 2
# RMD HEADER: {rank mutating attempt 2}
#===============================================================================

##got ranks fixed between the groups, used rank = row number from shiny app build, transmute function
leader_growth_change <- leader_growth %>%
  arrange(year, desc(visa_free_count)) %>%  
  group_by(year) %>%                        
  mutate(rank = row_number()) %>%
  ungroup() %>%
  arrange(country, year) %>%
  group_by(country)

view(leader_growth_change)


#===============================================================================
# CHUNK 23: build out rank change
# RMD HEADER: {build out rank change}
#===============================================================================

leader_growth_change <- leader_growth_change %>%
  mutate(
    previous_rank = lag(rank),
    change_in_rank = rank - previous_rank)
  
view(leader_growth_change)


#===============================================================================
# CHUNK 24: assign arrows/indicators for rank change
# RMD HEADER: {assign arrows/indicators for rank change}
#===============================================================================

##Debug
leader_growth_change <- leader_growth_change %>%
  mutate(
    case_when(change_in_rank < 0 = arrow(angle=90, length = unit(.25, inches), color = "green4"),
              change_in_rank = 0 = arrow(angle=0, length = unit(.25, inches), color = "grey"),
              change_in_rank > 1 = arrow(angle=180, length = unit(.25, inches), color = "red3"),
              change_in_rank = NA = NULL
  )


#===============================================================================
# CHUNK 25: assign arrows/indicators for rank change
# RMD HEADER: {assign arrows/indicators for rank change}
#===============================================================================

##code for arrows is only for ggplot so by changing to html I  can direect insert. 
leader_growth_change <- leader_growth_change %>%
  mutate(
    indicator = case_when(
      change_in_rank < 0 ~ "↑",
      change_in_rank > 0 ~ "↓",   
      change_in_rank == 0 ~ "—",  
      TRUE ~ ""                      
    )
  )


#===============================================================================
# CHUNK 26: dt package for arrow color rendering
# RMD HEADER: {dt package for arrow color rendering}
#===============================================================================

library(DT)

formatStyle('Change',
            color = styleEqual(c('↑', '↓', '—'), c('green4', 'red3', 'gray')))


#===============================================================================
# CHUNK 27: adjusted leaderboard
# RMD HEADER: {adjusted leaderboard}
#===============================================================================

##adjusting this table to include arrows might be hard.  adding filters by year since leadergrowthchange is by years and hasnt been previously filtered? would have to do something with the format style as a change in style. Colors switched in app version because DT cant read them. Standard colors worked
  output$leaderboard <- renderDT({
    leader_growth_change %>%
      transmute(
        Change = indicator,
        Rank = row_number(),
        Country = country,
        `Visa-Free Destinations` = visa_free_count)}),
formatStyle('Change',
            color = styleEqual(c('↑', '↓', '—'), c('green4', 'red3', 'gray')))
##green, red, gray


#===============================================================================
# CHUNK 28: original leadeboard creation
# RMD HEADER: {original leadeboard creation}
#===============================================================================

  output$leaderboard <- renderTable({
    leaderboard_data() %>%
      transmute(
        Rank = row_number(),
        Country = country,
        `Visa-Free Destinations` = visa_free_count)})


#===============================================================================
# CHUNK 29: DT modification for non interactive tables
# RMD HEADER: {DT modification for non interactive tables}
#===============================================================================

      options  = list(dom = "t", ordering = FALSE)) %>%


#===============================================================================
# CHUNK 30: rendering for DT
# RMD HEADER: {rendering for DT}
#===============================================================================

datatable(
  leaderboard_data(),
  rownames = FALSE,
  escape   = FALSE,     
  options  = list(
    dom       = "t",
    paging    = FALSE,
    ordering  = FALSE,
    autoWidth = TRUE


#===============================================================================
# CHUNK 31: change since 2006 iterative change
# RMD HEADER: {change since 2006 iterative change}
#===============================================================================

baseline_2006 <- rank_by_year %>%
  filter(year == 2006) %>%
  select(country, visa_2006 = visa_free_count)


#===============================================================================
# CHUNK 32: change since prior year visa free coutn
# RMD HEADER: {change since prior year visa free coutn}
#===============================================================================

change_in_visa_free_count <- leader_growth_change %>%
  mutate(
    previous_visa_free_coutn = lag(visa_free_count),
    change_in_free_count = visa_free_count - previous_visa_free_count)


#===============================================================================
# CHUNK 33: interactive work on Power Trend Graph
# RMD HEADER: {interactive work on Power Trend Graph}
#===============================================================================

  text = paste0( "<b>", country, "</b><br>",
                 "Year: ", year, "<br>"
                 "Visa-Free Acces: ", visa_free_count)


#===============================================================================
# CHUNK 34: key events for selected countries point pop ups
# RMD HEADER: {key events for selected countries point pop ups}
#===============================================================================

   geom_point(
      data = events_data,
      aes(
        text = paste0(
          "<b>", country, "</b><br>",
          "Year: ", year, "<br>",
          "Visa-Free Access: ", visa_free_count, "<br><br>",
          "<b>", event, "</b><br>",
          detail)))


#===============================================================================
# CHUNK 35: data join (key events and events data)
# RMD HEADER: {data join (key events and events data)}
#===============================================================================

events_data <- filtered_data() %>%
  inner_join(key_events, by = c("country", "year"))


#===============================================================================
# CHUNK 36: actual event data
# RMD HEADER: {actual event data}
#===============================================================================

## the importnat thing here was making this a tible and its own tab. Because selected coutnries was a vector of names I filtered to get the data but this is metadata and this would need a year column an event column and detail column and that would take forever. 
key_events <- tibble::tibble(
  country = c(
    "United Arab Emirates",
    "Singapore",
    "Japan",
    "Germany",
    "United States",
    "Brazil"
  ),
  year = c(
    2015,  # the UAE makes new law
    2012,  # Singapore gov makes pledge
    2008,  # Japan access to europe
    2010,  # Germany EU Schengen
    2017,  # United States visa waiver partnership
    2010   # Brazil improvement in global regions
  ),
  event = c(
    "Major increase in global visa agreements",
    "Business/travel diplomacy increases access",
    "Europe visa-waiver expands passport mobility",
    "Schengen EU consolidation strengthens access",
    "Rapid growth before plateauing",
    "Growth during regional/global expansion"
  ),
  detail = c(
    "UAE’s strategic reforms make its passport one of the fastest-improving in the world.",
    "Singapore cements its status as a leading travel and business hub.",
    "Japan broadens visa-free access across Europe and beyond.",
    "EU mobility benefits help Germany reach top-tier status.",
    "Visa-waiver partnerships expand, but others begin catching up after 2018.",
    "Steady improvements raise Brazil’s global mobility significantly."
  )
)


#===============================================================================
# CHUNK 37: labs to html plotly
# RMD HEADER: {labs to html plotly}
#===============================================================================

##debug. br sup convenions unclear? Looks like break and then line. Makes sense 
 text = paste0(
          "Passport Power: The Powerhouses (2006–2025)",
          "<br><sup>Powerhouse Countries are reaching maturity</sup>",
      "<br><sup>Hover to explore how each passport has changed</sup>"
 )
