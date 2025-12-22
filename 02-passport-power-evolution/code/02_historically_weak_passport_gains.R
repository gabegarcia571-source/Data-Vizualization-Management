#===============================================================================
# SCRIPT: 02_historically_weak_passport_gains.R
# PURPOSE: Replicate 'Historically Weak Passport Gains' attempts and final plot exactly as in the source.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 4: Historically Weak Passport Gains attempt 1 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Historically Weak Passport Gains attempt 1
low_mobility_growth <- rank %>%
  filter(year == 2006 if rank<20) %>%
  count(visa_free_count) %>%
  mutate(visa_free_count_change('visa_free_count %in% year==2025'- 'visa_free_count %in% year==2006')) %>%
    select(country,year, visa_free_count_change)%>%
  arrange(desc(country based on visa_free_count_change))%>%
  slice_head(n=20) %>%

#-------------------------------------------------------------------------------
# CHUNK 5: Historically Weak Passport Gains attempt 2 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Historically Weak Passport Gains attempt 2
##Mutate still not working debug? something about the way its named visa_free_count %in% isnt working. 
low_mobility_growth <- rank_by_year %>% 
  filter(year == 2006 & visa_free_count < 20) %>% 
  count(visa_free_count) %>%
  mutate(visa_free_count_change('visa_free_count %in% year==2025'- 'visa_free_count %in% year==2006')) %>%
    select(country, year, visa_free_count_change) %>%
  arrange(desc(country, visa_free_count_change)) %>%
  slice_head(n=20) %>%

#-------------------------------------------------------------------------------
# CHUNK 6: Historically Weak Passport Gains attempt 3 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Historically Weak Passport Gains attempt 3
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

#-------------------------------------------------------------------------------
# CHUNK 7: Historically Weak Passport Gains attempt Final (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Historically Weak Passport Gains attempt Final
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

#-------------------------------------------------------------------------------
# CHUNK 8: Historically Weak Passport Gains Final Plot (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] Historically Weak Passport Gains Final Plot
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
