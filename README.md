# Global Mobility Analysis: Logistics, Passport Power, and Interactive Exploration

This repository packages three connected analyses into one narrative about **global mobility** — not just *where you can go*, but *how the world’s systems make movement easier or harder*.

The arc of the project follows a simple logic:

1. **Logistics infrastructure (LPI)** describes how efficiently countries move goods through borders, ports, and transport networks.
2. **Passport power evolution** shows the citizen-facing outcome: how visa-free access rises and falls over time.
3. **Interactive Shiny exploration** turns the results into an interface where you can compare countries, track trajectories, and surface “winners vs losers”.

---

## Repository structure

```
global-mobility-analysis/
├── README.md
├── FILE_OUTLINE.md
├── 01-travel-logistics/
│   ├── README.md
│   ├── analysis.R          # extracted code chunks + annotations (logic unchanged)
│   ├── analysis.Rmd        # original source copied as-is
│   ├── data/
│   └── outputs/
├── 02-passport-evolution/
│   ├── README.md
│   ├── analysis.R          # extracted code chunks + annotations (logic unchanged)
│   ├── analysis.Rmd        # original source copied as-is
│   ├── data/
│   └── outputs/
├── 03-shiny-app/
│   ├── README.md
│   ├── app.R               # final Shiny app (extracted verbatim)
│   └── data/
├── assets/
│   └── images/
└── archive/                # original rendered artifacts (HTML/PDF/Tableau workbook)
```

---

## Key findings (in the author’s original framing)

### Travel & Logistics (World Bank LPI 2007–2023)
Your working thesis (from the write-up in `archive/Comments_and_Sources.pdf`):
> *technology accelerates, geography constrains, and bureaucracy stalls progress.*

The analysis is structured like a documentary: baseline distribution → regional trends → component drivers → interactive tools → animation + map.

### Passport Power Evolution
The passport chapter is explicitly framed as **“winners vs losers”** to communicate inequality in global mobility at a glance (see `archive/TidyTuesdaySubmission.html`).

It also isolates **powerhouse passports** and compares trends over time before moving into interactive exploration.

### Interactive Shiny Exploration
You described the Shiny layer as a way to “let people play with the data” using tabs like Trends / Leaderboard / Biggest Improvers (see `archive/TidyTuesdaySubmission.html`).

---

## How to run

### 01 — Travel & Logistics
1. Open `01-travel-logistics/analysis.Rmd` (original) or run `01-travel-logistics/analysis.R` (extracted).
2. **Important:** the code contains a Windows `file_path` for the LPI Excel file. The path is preserved exactly from your source; update it locally if needed.
3. Outputs (plots/animation) will be generated according to your script settings.

### 02 — Passport Evolution
Run `02-passport-evolution/analysis.R` (or knit `analysis.Rmd`).  
Place required datasets in `02-passport-evolution/data/` (some are already included if provided).

### 03 — Shiny Apps
From R (default app):
```r
shiny::runApp("03-shiny-app")
```

Additional apps live in `03-shiny-app/apps/`:

- `lpi_regional_leaderboard_app.R` — Regional LPI leaderboard (animated year slider)
- `lpi_growth_explorer_app.R` — LPI component growth comparison (two-country explorer)
- `passport_power_three_tabs_windows_path_app.R` — Passport app with Leaderboard/Trends/Power Shift (hard-coded Windows path preserved)
- `passport_power_dashboard_portfolio_edition_app.R` — Expanded “portfolio edition” passport dashboard

Run any app directly:
```r
shiny::runApp("03-shiny-app/apps/lpi_growth_explorer_app.R")
```

## Original artifacts preserved
The full rendered deliverables are kept in `archive/`:
- `TidyTuesdaySubmission.html` (passport write-up)
- `Blog_Final_Project_2.html` (LPI write-up)
- `Shiny_App_Contest_Documentation.html` (Shiny documentation write-up)
- `Comments_and_Sources.pdf` (project rationale + visualization explanations + sources)
- `LPI_Tableau_Map.twbx` (Tableau workbook)
