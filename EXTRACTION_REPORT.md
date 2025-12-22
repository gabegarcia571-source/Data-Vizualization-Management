# EXTRACTION_REPORT.md

Date: 2025-12-22

## Summary
- ✅ **Travel/Logistics:** All **11** code chunks from `Blog_Final_Project_2.Rmd` were extracted into scripts under `01-travel-logistics-analysis/code/`.
- ✅ **Passport + Shiny:** All **38** code chunks from `TidyTuesdayDecemberCodeArchive.Rmd` were extracted into scripts under `02-passport-power-evolution/` and `03-shiny-application/`.
- ✅ **Code fidelity:** The extracted code lines are **verbatim** from the Rmd sources. Only **comment blocks/annotations** were added.
- ✅ **Prototype/debug preservation:** All prototype/debug chunks were placed into `99_exploratory_notes.R` and `03-shiny-application/code/01_prototypes.R` exactly as written.

## Chunk placement inventory
| Source | Chunk | Label | Destination |
|---|---:|---|---|
| Blog_Final_Project_2.Rmd | 1 | setup | `01-travel-logistics-analysis/code/01_import_clean.R` |
| Blog_Final_Project_2.Rmd | 2 | global_setup | `01-travel-logistics-analysis/code/01_import_clean.R` |
| Blog_Final_Project_2.Rmd | 3 | dataload | `01-travel-logistics-analysis/code/01_import_clean.R` |
| Blog_Final_Project_2.Rmd | 4 | region_creation | `01-travel-logistics-analysis/code/01_import_clean.R` |
| Blog_Final_Project_2.Rmd | 5 | visualization_1 | `01-travel-logistics-analysis/code/02_visualizations.R` |
| Blog_Final_Project_2.Rmd | 6 | visualization_2_plotly | `01-travel-logistics-analysis/code/02_visualizations.R` |
| Blog_Final_Project_2.Rmd | 7 | visualization_3 | `01-travel-logistics-analysis/code/02_visualizations.R` |
| Blog_Final_Project_2.Rmd | 8 | visualization_4 | `01-travel-logistics-analysis/code/02_visualizations.R` |
| Blog_Final_Project_2.Rmd | 9 | animation_creation | `01-travel-logistics-analysis/code/03_animation.R` |
| Blog_Final_Project_2.Rmd | 10 | animate_graphic | `01-travel-logistics-analysis/code/04_external_assets.R` |
| Blog_Final_Project_2.Rmd | 11 | tableau_screenshot | `01-travel-logistics-analysis/code/04_external_assets.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 1 | setup | `02-passport-power-evolution/code/01_import_and_initial_exploration.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 2 | data upload | `02-passport-power-evolution/code/01_import_and_initial_exploration.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 3 | data view | `02-passport-power-evolution/code/01_import_and_initial_exploration.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 4 | Historically Weak Passport Gains attempt 1 | `02-passport-power-evolution/code/02_historically_weak_passport_gains.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 5 | Historically Weak Passport Gains attempt 2 | `02-passport-power-evolution/code/02_historically_weak_passport_gains.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 6 | Historically Weak Passport Gains attempt 3 | `02-passport-power-evolution/code/02_historically_weak_passport_gains.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 7 | Historically Weak Passport Gains attempt Final | `02-passport-power-evolution/code/02_historically_weak_passport_gains.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 8 | Historically Weak Passport Gains Final Plot | `02-passport-power-evolution/code/02_historically_weak_passport_gains.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 9 | Time Series of Leading Powerhouse Passports attempt 1 | `02-passport-power-evolution/code/03_powerhouse_time_series.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 10 | Time Series of Leading Powerhouse Passports attempt 2 | `02-passport-power-evolution/code/03_powerhouse_time_series.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 11 | Time Series of Leading Powerhouse Passports attempt 3 | `02-passport-power-evolution/code/03_powerhouse_time_series.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 12 | US Check | `02-passport-power-evolution/code/03_powerhouse_time_series.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 13 | Time Series of Leading Powerhouse Passports with Plot | `02-passport-power-evolution/code/03_powerhouse_time_series.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 14 | Time Series of Leading Powerhouse Passports with Plot SHINY | `03-shiny-application/code/01_prototypes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 15 | visa power changes broader/more informative | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 16 | confirm bolivia is low | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 17 | shiny app tweaks | `03-shiny-application/code/01_prototypes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 18 | Filter doesnt show up | `03-shiny-application/code/01_prototypes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 19 | rank cleaning and visuals logic line | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 20 | rank ordering data | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 21 | rank mutating attempt 1 | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 22 | rank mutating attempt 2 | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 23 | build out rank change | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 24 | assign arrows/indicators for rank change | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 25 | assign arrows/indicators for rank change | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 26 | dt package for arrow color rendering | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 27 | adjusted leaderboard | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 28 | original leadeboard creation | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 29 | DT modification for non interactive tables | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 30 | rendering for DT | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 31 | change since 2006 iterative change | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 32 | change since prior year visa free coutn | `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 33 | interactive work on Power Trend Graph | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 34 | key events for selected countries point pop ups | `03-shiny-application/code/02_event_annotations_dev.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 35 | data join (key events and events data) | `03-shiny-application/code/02_event_annotations_dev.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 36 | actual event data | `03-shiny-application/code/02_event_annotations_dev.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 37 | labs to html plotly | `02-passport-power-evolution/code/99_exploratory_notes.R` |
| TidyTuesdayDecemberCodeArchive.Rmd | 38 | Final Shiny App Code | `03-shiny-application/app.R` |

## Recommended execution order

### 01 — Travel/Logistics
1. `01-travel-logistics-analysis/code/01_import_clean.R`
2. `01-travel-logistics-analysis/code/02_visualizations.R`
3. `01-travel-logistics-analysis/code/03_animation.R`
4. `01-travel-logistics-analysis/code/04_external_assets.R`

### 02 — Passport Power
1. `02-passport-power-evolution/code/01_import_and_initial_exploration.R`
2. `02-passport-power-evolution/code/02_historically_weak_passport_gains.R`
3. `02-passport-power-evolution/code/03_powerhouse_time_series.R`
4. `02-passport-power-evolution/code/04_winners_vs_losers_leaderboard.R`

Optional / non-pipeline:
- `02-passport-power-evolution/code/99_exploratory_notes.R`

### 03 — Shiny
- Run: `03-shiny-application/app.R`

Prototype / development notes:
- `03-shiny-application/code/01_prototypes.R`
- `03-shiny-application/code/02_event_annotations_dev.R`

## Ambiguities / notes encountered
1. **Rendered HTML vs source code:** The HTML exports primarily embed outputs (plots) rather than exposing all code blocks in a reliably extractable form. For perfect replication, extraction was performed from the **original Rmd sources** included in `archive/`.
2. **Shiny documentation artifact:** The provided Shiny documentation HTML is narrative-only; the **final working Shiny app** code referenced in the project is preserved as **chunk 38** from the code archive Rmd, per the approved mapping and chunk assignment rules.
3. **Hard-coded paths:** Some chunks contain hard-coded Windows paths (preserved exactly). See inline “NOTE: hard-coded Windows path” comments in scripts.

## Hard-coded / environment-specific elements (preserved)
- Any `C:\Users\...` or `C:/Users/...` paths remain unchanged and are flagged in comments where they occur.
