# Passport Power Evolution (TidyTuesday)

This folder reproduces the passport “power” analysis (visa-free counts + ranks over time), preserving the original **winners vs losers** framing and visualization style.

## Research question
How has passport mobility changed over time, and which countries gained or lost the most access?

## Scripts (run in order)
1. `code/01_import_and_initial_exploration.R` — libraries, import, and basic structure checks  
2. `code/02_historically_weak_passport_gains.R` — all attempts + final “low-mobility growth” plot  
3. `code/03_powerhouse_time_series.R` — leading passports time series attempts + final plot  
4. `code/04_winners_vs_losers_leaderboard.R` — mobility change calculations + leaderboard logic  

Exploration/prototypes (not required for reproduction):
- `code/99_exploratory_notes.R`

## Data
- `data/rank_by_year.csv` — country-year passport mobility metrics  
- `data/country_lists.csv` — JSON destination lists (kept for completeness; not always used in final story)

## Author narrative excerpts
### Data summary
```
Data Summary
I started by loading jsonlite and tidyverse and reading in the two
main files:
rank_by_year.csv – the core data I use for almost everything
country_lists.csv – the JSON columns that break destinations into
visa-free, visa-on-arrival, etc.
I used glimpse() and summary() to make sure I understood the
structure. One row per country–year with variables for country, region,
visa_free_count, rank, and year. After looking at both datasets, I
decided the JSON list columns weren’t necessary for the story I wanted
to tell, so I focused my analysis on the first csv. The key decision
here was: keep the pipeline simple and stick to the variables that
directly connect to passport strength (visa-free count + year +
country).
Data: - Country and Region: Geographic identification - Visa-Free
Count: Number of destinations travelers can visit without obtaining a
pre-visa - Global Ranking: The country’s position relative to other
passports
Over the last two decades diplomatic relationships, economic
development, and geopolitical shifts have transformed global mobility.
```

### Winners vs losers framing
```
I grabbed the bottom 10 and top 10 countries and stacked them into
one data frame so the viewer immediately sees who gained the most and
also sees who either barely improved or actually lost ground (Bolivia).
I wanted the colors to mean something. So I created a change_type column
with case_when. Then I converted that to a factor and used
scale_fill_manual() to lock in consistent colors:
Red for decline
Gold for small improvement
Green for major improvement
This is what lets the viewer understand the chart at a glance without
reading every number.
For the final plot I ordered the bars from best to worst change. I
went horizontal to keep the country names readable. I added custom
labels (+99, -5, etc.) and nudged them left/right depending on whether
the change was positive or negative. I wrote the subtitle to explicitly
call out the Bolivia finding. Those coding decisions turn a giant table
of numbers into a clean narrative about inequality in global mobility.
The horizontal layout and sorting make the “winners vs losers” structure
```
