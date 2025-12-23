# Global Mobility Analysis: Logistics, Passport Power, and Interactive Exploration

> *Understanding global mobility through the lens of infrastructure, diplomacy, and data*

This repository tells a comprehensive story about **what determines global mobility** — not just where citizens can travel, but the underlying systems that make international movement easier or harder.

---

## 🌍 Live Interactive Demos

Explore the findings through four interactive Shiny applications:

| Application | Focus | Link |
|------------|-------|------|
| **Passport Power Dashboard** | Multi-tab analysis of visa-free access trends, leaderboards, and power shifts | [Launch App](https://ggarcia-stats.shinyapps.io/passport-power-analytics/) |
| **Regional LPI Leaderboard** | Track logistics performance leaders over time with animated year slider | [Launch App](https://ggarcia-stats.shinyapps.io/regional-lpi-leaderboard/) |
| **LPI Growth Explorer** | Compare two countries' logistics performance trajectories (2007-2023) | [Launch App](https://ggarcia-stats.shinyapps.io/lpi-growth-explorer/) |
| **Component Benchmarking** | Country vs. regional component-level growth analysis | [Launch App](https://ggarcia-stats.shinyapps.io/lpi-component-benchmark/) |

---

## 📖 Project Narrative

The project follows a logical progression through three connected analyses:

### 1. **Logistics Infrastructure** → The Foundation of Movement
*How efficiently can countries move goods through borders, ports, and transport networks?*

Using the World Bank's Logistics Performance Index (LPI) from 2007–2023, this analysis explores:
- Geographic and regional patterns in logistics performance
- Which components drive improvement (infrastructure, customs, tracking, timeliness)
- How technology accelerates progress while geography and bureaucracy constrain it

**Key Finding:** Infrastructure investment is the primary engine of logistics performance improvement, but regional disparities persist.

### 2. **Passport Power Evolution** → The Human-Facing Outcome
*How does diplomatic capital translate into citizen mobility?*

This chapter frames passport rankings as a **"winners vs losers"** story to highlight inequality in global mobility access:
- Time-series analysis of visa-free access changes (2006–2024)
- Identification of "powerhouse passports" and emerging improvers
- Regional agreements and geopolitical shifts captured in the data

**Key Finding:** Passport power is dynamic—diplomatic relationships, regional integration, and policy reforms create significant year-over-year changes.

### 3. **Interactive Exploration** → Making Data Explorable
*Can we turn static insights into an interface for discovery?*

Four interconnected Shiny applications enable:
- Side-by-side country comparisons
- Temporal trend visualization with event annotations
- Leaderboard rankings and "biggest mover" identification
- Component-level deep dives into what drives performance

**Key Finding:** Interactive tools reveal patterns invisible in static analysis—users can test hypotheses and explore their own questions.

---

## 🗂️ Repository Structure

```
global-mobility-analysis/
├── README.md                          # This file
├── FILE_OUTLINE.md                    # Detailed file inventory
├── 01-travel-logistics/
│   ├── README.md                      # Component-specific documentation
│   ├── analysis.R                     # Annotated R scripts (extracted from Rmd)
│   ├── analysis.Rmd                   # Original source with narrative
│   ├── data/                          # World Bank LPI data
│   └── outputs/                       # Generated visualizations
├── 02-passport-evolution/
│   ├── README.md
│   ├── analysis.R                     # Annotated R scripts
│   ├── analysis.Rmd                   # Original source
│   ├── data/                          # Passport ranking data (2006-2024)
│   └── outputs/                       # Generated visualizations
├── 03-shiny-app/
│   ├── README.md
│   ├── app.R                          # Main Shiny application
│   ├── apps/                          # Additional specialized apps
│   │   ├── lpi_regional_leaderboard_app.R
│   │   ├── lpi_growth_explorer_app.R
│   │   ├── passport_power_three_tabs_windows_path_app.R
│   │   └── passport_power_dashboard_portfolio_edition_app.R
│   └── data/                          # App-ready datasets
├── assets/
│   └── images/                        # Screenshots and diagrams
└── archive/                           # Original rendered artifacts
    ├── TidyTuesdaySubmission.html
    ├── Blog_Final_Project_2.html
    ├── Shiny_App_Contest_Documentation.html
    ├── Comments_and_Sources.pdf
    └── LPI_Tableau_Map.twbx
```

---

## 🚀 How to Run Locally

### Prerequisites
```r
# Install required packages
install.packages(c("tidyverse", "shiny", "plotly", "gganimate", 
                   "readxl", "countrycode", "scales", "DT"))
```

### Running the Analyses

#### 1. Travel & Logistics Analysis
```r
# Option A: Run the annotated script
source("01-travel-logistics/analysis.R")

# Option B: Knit the original Rmd with narrative
rmarkdown::render("01-travel-logistics/analysis.Rmd")
```
**Note:** Update the `file_path` variable to point to your local LPI Excel file location.

#### 2. Passport Evolution Analysis
```r
# Run the analysis
source("02-passport-evolution/analysis.R")
```

#### 3. Shiny Applications
```r
# Run the main dashboard
shiny::runApp("03-shiny-app")

# Or run specific apps
shiny::runApp("03-shiny-app/apps/lpi_growth_explorer_app.R")
shiny::runApp("03-shiny-app/apps/passport_power_dashboard_portfolio_edition_app.R")
```

---

## 🎯 Key Insights

### From the Logistics Analysis
- **Regional Divergence**: Europe and North America maintain consistently high scores, while Sub-Saharan Africa and South Asia show slower improvement
- **Component Drivers**: Infrastructure quality shows the strongest correlation with overall LPI improvement
- **Technology's Role**: Tracking and tracing capabilities have improved across all regions, but baseline infrastructure gaps limit their impact

### From the Passport Evolution Analysis
- **Winners**: UAE passport jumped from 65 to 185 visa-free destinations (2006-2024)
- **Losers**: Several countries lost access due to diplomatic tensions and policy changes
- **Powerhouses**: Japan, Singapore, and European nations maintain consistently strong positions
- **Regional Patterns**: ASEAN integration and EU expansion drove significant improvements for member states

### From the Interactive Tools
- **Comparison Value**: Side-by-side views reveal diverging strategies (infrastructure-first vs. diplomatic-first)
- **Temporal Context Matters**: Year-over-year changes often reflect specific policy events or regional agreements
- **User-Driven Discovery**: Interactive exploration enables hypothesis testing beyond the static analysis

---

## 📊 Data Sources

- **Logistics Performance Index (LPI)**: [World Bank - International LPI 2007-2023](https://lpi.worldbank.org/)
- **Passport Rankings**: Henley & Partners Passport Index (2006-2024)
- **Regional Classifications**: World Bank country groupings

---

## 💡 Technical Highlights

- **Reproducible Analysis**: All code preserved from original research; annotated for clarity but logic unchanged
- **Professional Documentation**: Each component includes detailed README with methodology and interpretation
- **Interactive Deployment**: Four production Shiny apps hosted on shinyapps.io
- **Visualization Design**: Custom ggplot2 themes, animated time-series, and plotly interactivity
- **Data Transformation**: Complex reshaping, time-series calculations, and ranking algorithms

---

## 🎓 Project Context

This portfolio project demonstrates:
- **Data wrangling** with complex multi-year datasets
- **Statistical analysis** including time-series trends and correlation analysis  
- **Data visualization** with static plots, animations, and interactive dashboards
- **Shiny development** with multiple reactive interfaces and deployment
- **Narrative communication** connecting technical analysis to real-world insights

---

## 📝 Original Artifacts

The complete rendered deliverables from the original submission are preserved in `archive/`:
- **TidyTuesday Submission** (Passport Power write-up)
- **Blog/Final Project** (LPI analysis write-up)
- **Shiny App Contest Documentation** (Application design rationale)
- **Comments & Sources PDF** (Project methodology and visualization explanations)
- **Tableau Workbook** (Geographic LPI visualization)

---

## 🔗 Connect

- **Live Apps**: See links at the top of this README
- **Questions or Feedback**: [Open an issue](../../issues) or connect via LinkedIn

---

## 📜 License

This project is shared for portfolio and educational purposes. Data sources retain their original licenses (World Bank, Henley & Partners).

---

**Built with:** R • Shiny • ggplot2 • plotly • gganimate • tidyverse
