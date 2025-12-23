# Interactive Shiny Apps

This folder contains the Shiny applications used in the **Global Mobility Analysis** project.

The apps are intentionally kept in their **original form** (logic, object names, and styling preserved), with only light
portfolio-style headers/comments added for orientation.

## Data requirements

### Passport apps
- `data/rank_by_year.csv` (included in this repo)

### Logistics (LPI) apps
- `International_LPI_from_2007_to_2023_0 (1).xlsx`
  - This file is referenced by the apps with the filename **exactly as written**.
  - Place it next to the app file you are running (recommended: `03-shiny-app/data/`) or update your working directory accordingly.

> Note: Any hard-coded Windows paths in the original code are preserved as-is.

## Apps in this folder

### Default app (repo root)
- `app.R` — **Passport Power: Across Context**
  - Powerhouse trend lines with hoverable event annotations
  - “Power Shift” bar chart (largest improvers/decliners)

Run:
```r
shiny::runApp("03-shiny-app")
```

### Additional apps (stored under `apps/`)

1. `apps/lpi_regional_leaderboard_app.R` — **Regional LPI Leaderboard**
   - Choose a region, animate survey years, view top-N performers

2. `apps/lpi_growth_explorer_app.R` — **LPI Growth Explorer**
   - Compare two countries’ percent change in LPI components between two survey years

3. `apps/passport_power_three_tabs_windows_path_app.R` — **Passport Power: 3-Tab Version**
   - Leaderboard / Trends / Power Shift
   - Includes a hard-coded Windows path to `rank_by_year.csv` (preserved)

4. `apps/passport_power_dashboard_portfolio_edition_app.R` — **Passport Power Dashboard (Portfolio Edition)**
   - Expanded multi-tab dashboard and additional analytics

Run any of these directly:
```r
shiny::runApp("03-shiny-app/apps/lpi_regional_leaderboard_app.R")
```

## Sources and artifacts
Rendered documentation and writeups used to build this repository live in `archive/`.
