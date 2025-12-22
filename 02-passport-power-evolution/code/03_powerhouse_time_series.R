#===============================================================================
# SCRIPT: 03_powerhouse_time_series.R
# PURPOSE: Replicate leading powerhouse passport time series attempts and final plot exactly as in the source.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 9: Time Series of Leading Powerhouse Passports attempt 1 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Time Series of Leading Powerhouse Passports attempt 1
leader_growth <- rank_by_year %>%
  group_by(country) %>%
  arrange(asc(visa_free_count)) %>%
  slice(head(n = 7)) %>%
  filter(country %in% leader_growth)

#-------------------------------------------------------------------------------
# CHUNK 10: Time Series of Leading Powerhouse Passports attempt 2 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Time Series of Leading Powerhouse Passports attempt 2
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

#-------------------------------------------------------------------------------
# CHUNK 11: Time Series of Leading Powerhouse Passports attempt 3 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Time Series of Leading Powerhouse Passports attempt 3
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

#-------------------------------------------------------------------------------
# CHUNK 12: US Check (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] US Check
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

#-------------------------------------------------------------------------------
# CHUNK 13: Time Series of Leading Powerhouse Passports with Plot (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Time Series of Leading Powerhouse Passports with Plot
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

