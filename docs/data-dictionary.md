# Data Dictionary

## `rank_by_year.csv`
Country-year passport mobility dataset.

Common fields (as used in the analysis scripts):
- `country` — country name
- `region` — region label
- `year` — year
- `visa_free_count` — count of visa-free destinations (proxy for “passport power”)
- `rank` — rank derived from visa-free counts (lower is stronger)

## `country_lists.csv`
Contains JSON/list columns describing destination groupings (visa-free, visa-on-arrival, etc.).
- Note: JSON list columns may require `jsonlite` parsing to unnest, as shown in import scripts.

## LPI dataset (Excel)
Imported via `readxl::read_excel()` from a hard-coded Windows path in the original code.
Fields used typically include overall score and component sub-scores by country and year.
