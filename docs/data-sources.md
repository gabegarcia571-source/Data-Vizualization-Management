# Data Sources

## Logistics Performance Index (LPI)
The logistics analysis uses the World Bank Logistics Performance Index dataset (2007–2023) as referenced in the original blog narrative.

> The import step includes a **hard-coded Windows path** to an Excel download. The path is preserved verbatim for fidelity.

## Passport power dataset
The passport analysis uses:
- `rank_by_year.csv` — core country-year mobility dataset
- `country_lists.csv` — destination lists in JSON-like columns (used for additional context in development)

Both files are included in this repository under the `data/` directories for Part 02 and Part 03.
