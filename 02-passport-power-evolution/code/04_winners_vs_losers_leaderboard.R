#===============================================================================
# SCRIPT: 04_winners_vs_losers_leaderboard.R
# PURPOSE: Replicate 'winners vs losers' mobility changes and leaderboard logic exactly as in the source.
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 15: visa power changes broader/more informative (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] visa power changes broader/more informative
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


#-------------------------------------------------------------------------------
# CHUNK 23: build out rank change (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] build out rank change
leader_growth_change <- leader_growth_change %>%
  mutate(
    previous_rank = lag(rank),
    change_in_rank = rank - previous_rank)
  
view(leader_growth_change)


#-------------------------------------------------------------------------------
# CHUNK 24: assign arrows/indicators for rank change (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] assign arrows/indicators for rank change
##Debug
leader_growth_change <- leader_growth_change %>%
  mutate(
    case_when(change_in_rank < 0 = arrow(angle=90, length = unit(.25, inches), color = "green4"),
              change_in_rank = 0 = arrow(angle=0, length = unit(.25, inches), color = "grey"),
              change_in_rank > 1 = arrow(angle=180, length = unit(.25, inches), color = "red3"),
              change_in_rank = NA = NULL
  )

#-------------------------------------------------------------------------------
# CHUNK 25: assign arrows/indicators for rank change (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] assign arrows/indicators for rank change
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

#-------------------------------------------------------------------------------
# CHUNK 27: adjusted leaderboard (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] adjusted leaderboard
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

#-------------------------------------------------------------------------------
# CHUNK 31: change since 2006 iterative change (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] change since 2006 iterative change
baseline_2006 <- rank_by_year %>%
  filter(year == 2006) %>%
  select(country, visa_2006 = visa_free_count)

#-------------------------------------------------------------------------------
# CHUNK 32: change since prior year visa free coutn (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] change since prior year visa free coutn
change_in_visa_free_count <- leader_growth_change %>%
  mutate(
    previous_visa_free_coutn = lag(visa_free_count),
    change_in_free_count = visa_free_count - previous_visa_free_count)
