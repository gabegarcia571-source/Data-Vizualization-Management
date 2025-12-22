#===============================================================================
# SCRIPT: 99_exploratory_notes.R
# PURPOSE: Preserve prototype/debug chunks exactly as written (not part of the primary reproducible pipeline).
# AUTHOR: Gabriel Garcia
# DATE: 2025-12-22
# SOURCE: TidyTuesdayDecemberCodeArchive.Rmd (code chunks extracted verbatim; only comments added)
# DEPENDENCIES: As listed in the extracted chunks (see library() calls).
#===============================================================================

#-------------------------------------------------------------------------------
# CHUNK 16: confirm bolivia is low (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] confirm bolivia is low
##only country without growth is indeed bolivia. Thinking to show low growth as a seperate category instead
mobility_changes %>%
  filter(visa_power_change < 0) %>%
  arrange(visa_power_change)


#-------------------------------------------------------------------------------
# CHUNK 19: rank cleaning and visuals logic line (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] rank cleaning and visuals logic line
##Possible Idea and Logic Line
##Add a arrow or track changes in leaderboard. If equal gray, if rising green, if dropping red. run some sort of loop within each year. some sort of change calculation. Current rank - previous rank. This is for the leader growth set. So if change is positive , dropped rank, red arrow down. If change is negative, rose rank, green arrow up. If zero, same rank, gray dash. 

leader_growth <- rank_by_year %>%
    filter(visa_free_count >0, !is.na(visa_free_count)) %>%
    filter(country %in% selected_countries)

view(leader_growth)

#-------------------------------------------------------------------------------
# CHUNK 20: rank ordering data (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] rank ordering data
##order the data 
leader_growth <- leader_growth %>%
  arrange(country, year)%>%
  group_by(country)

view(leader_growth)

#-------------------------------------------------------------------------------
# CHUNK 21: rank mutating attempt 1 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] rank mutating attempt 1
##This worked! I have changes in ranks as negative or positive. Unfortunately, its the wrong thing. the rank in the leaderboard table is based on row which is based on visas. But the logic remains the same, just different variables.
leader_growth_change <- leader_growth %>%
  mutate(
   previous_rank = lag(rank),
   change_in_rank = rank - previous_rank)%>%
  select(country,year,rank,previous_rank,change_in_rank)%>%
  ungroup()

view(leader_growth_change)

#-------------------------------------------------------------------------------
# CHUNK 22: rank mutating attempt 2 (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] rank mutating attempt 2
##got ranks fixed between the groups, used rank = row number from shiny app build, transmute function
leader_growth_change <- leader_growth %>%
  arrange(year, desc(visa_free_count)) %>%  
  group_by(year) %>%                        
  mutate(rank = row_number()) %>%
  ungroup() %>%
  arrange(country, year) %>%
  group_by(country)

view(leader_growth_change)

#-------------------------------------------------------------------------------
# CHUNK 26: dt package for arrow color rendering (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] dt package for arrow color rendering
library(DT)

formatStyle('Change',
            color = styleEqual(c('↑', '↓', '—'), c('green4', 'red3', 'gray')))

#-------------------------------------------------------------------------------
# CHUNK 28: original leadeboard creation (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] original leadeboard creation
  output$leaderboard <- renderTable({
    leaderboard_data() %>%
      transmute(
        Rank = row_number(),
        Country = country,
        `Visa-Free Destinations` = visa_free_count)})

#-------------------------------------------------------------------------------
# CHUNK 29: DT modification for non interactive tables (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] DT modification for non interactive tables
      options  = list(dom = "t", ordering = FALSE)) %>%

#-------------------------------------------------------------------------------
# CHUNK 30: rendering for DT (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] rendering for DT
datatable(
  leaderboard_data(),
  rownames = FALSE,
  escape   = FALSE,     
  options  = list(
    dom       = "t",
    paging    = FALSE,
    ordering  = FALSE,
    autoWidth = TRUE

#-------------------------------------------------------------------------------
# CHUNK 33: interactive work on Power Trend Graph (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] interactive work on Power Trend Graph
  text = paste0( "<b>", country, "</b><br>",
                 "Year: ", year, "<br>"
                 "Visa-Free Acces: ", visa_free_count)

#-------------------------------------------------------------------------------
# CHUNK 37: labs to html plotly (no preceding heading found)
#-------------------------------------------------------------------------------

# [CHUNK HEADER] labs to html plotly
##debug. br sup convenions unclear? Looks like break and then line. Makes sense 
 text = paste0(
          "Passport Power: The Powerhouses (2006–2025)",
          "<br><sup>Powerhouse Countries are reaching maturity</sup>",
      "<br><sup>Hover to explore how each passport has changed</sup>"
 )
