# Travel & Logistics (World Bank LPI 2007–2023)

This folder contains the complete workflow from your original LPI R Markdown source:
- multi-sheet Excel import
- region construction (including manual overrides)
- 4 core visuals (histogram, regional trends, component trends, component growth ranking)
- 2 Shiny tools (regional leaderboard + country vs region benchmarking)
- gganimate scatterplot (infrastructure vs overall LPI)
- Tableau map screenshot inclusion

## Files
- `analysis.Rmd` — original source copied as-is
- `analysis.R` — extracted code chunks in order with added section comments (logic unchanged)

## Data
Your source uses a hard-coded Windows path for the LPI Excel file (`file_path <- ...`).
That path is preserved in `analysis.R` exactly as written; update it locally to point to your copy of the Excel workbook.

## Outputs
Generated plots/animation should be saved into `outputs/` according to your script settings.
