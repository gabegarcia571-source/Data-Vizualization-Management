# File Outline and How the Pieces Relate

This repository reorganizes **your existing project files** (R Markdown + rendered artifacts) into a portfolio-ready structure **without rewriting the underlying analysis code**.

---

## 1) `Annotated Code (1).Rmd` → Travel/Logistics (World Bank LPI)

**Location in repo:** `01-travel-logistics/`

**What it contains (in order):**
1. Global knitr setup (echo/warnings/messages)
2. Package load + `file_path` pointing to the multi-sheet LPI Excel file (Windows path)
3. Multi-sheet import using `excel_sheets()` + `purrr::map_dfr()` + `janitor::clean_names()`
4. Region creation with manual overrides (explicit mapping)
5. Visualization 1: histogram of 2023 LPI scores
6. Visualization 2: interactive regional trends (Plotly)
7. Visualization 3: component trend lines (6 components)
8. Visualization 4: ranked component improvements (bar chart)
9. Visualization 5: Shiny “Regional LPI Leaderboard”
10. Visualization 6: Shiny “Country vs Regional Benchmarking”
11. Animated scatterplot with `gganimate` (infrastructure vs overall LPI)
12. Embedded GIF include
13. Embedded Tableau map screenshot include

**How it connects:** this chapter builds the **infrastructure side of mobility** — how countries differ in logistics capability (and how that changes over time).

---

## 2) `TidyTuesdayDecemberCodeArchive (1).Rmd` → Passport Power Evolution + Shiny app

**Location in repo:**
- Passport analysis: `02-passport-evolution/`
- Final Shiny app: `03-shiny-app/`

**What it contains (high level):**
- Data import (CSV + JSON parsing)
- “Historically weak passports” analysis (multiple attempts + final approach)
- “Powerhouses” time series analysis and plotting
- “Winners vs losers” mobility change framing + leaderboard logic
- Prototyping/debug chunks (kept, not deleted)
- Final working Shiny app (extracted to `03-shiny-app/app.R`)

**How it connects:** this chapter measures the **people side of mobility** — visa-free access over time — and the Shiny app makes the patterns explorable.

---

## 3) Rendered artifacts / documentation files

**Location in repo:** `archive/`

- `TidyTuesdaySubmission (1).html`: narrative write-up and interpretation for the passport work
- `Blog_Final_Project_2 (3).html`: rendered write-up for the LPI logistics project
- `Shiny-App-Contest--Garcia,-Gabriel- (1).html`: documentation-style write-up for the Shiny work
- `Comments and Sources (1).pdf`: project rationale + visualization explanations + sources
- `Global Logistics Performance Visualization (LPI 2007-2023) (1).twbx`: Tableau workbook for the choropleth map

These files are preserved as **evidence of the original final deliverables**.

---


## Additional apps provided after initial upload

The following standalone Shiny apps were provided as extra code blocks and are stored under `03-shiny-app/apps/`:

- `lpi_regional_leaderboard_app.R`
- `lpi_growth_explorer_app.R`
- `passport_power_three_tabs_windows_path_app.R`
- `passport_power_dashboard_portfolio_edition_app.R`
